# MathLive CDN URLs (UBI-04)
const MATHLIVE_CDN_JS  = "https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive.min.js"
const MATHLIVE_CDN_CSS = "https://cdn.jsdelivr.net/npm/mathlive/dist/mathlive-static.min.css"
const COMPUTE_ENGINE_CDN_JS = "https://cdn.jsdelivr.net/npm/@cortex-js/compute-engine/dist/compute-engine.min.js"

function Base.show(io::IO, mime::MIME"text/html", mi::MathInput)
    # Serialise options & macros to JSON for JS consumption
    options_json = isempty(mi.options) ? "{}" : JSON3.write(mi.options)
    macros_json  = isempty(mi.macros)  ? "{}" : JSON3.write(mi.macros)

    disabled_str = mi.disabled ? "true" : "false"
    style_attr   = isempty(mi.style) ? "" : mi.style

    # Determine what format to send back to Julia
    output_format = mi.format == :latex ? "latex" : "mathjson"

    # Determine initial value
    initial_latex    = mi.latex
    initial_mathjson = mi.default

    # Strategy:
    # - Load MathLive via a classic <script> tag (NOT module import)
    #   This avoids CSP issues with dynamic import() in Pluto
    # - The <script> tag registers the <math-field> custom element globally
    # - Our config script waits for the custom element to be defined
    # - Wrapper <span> gets .value and dispatches "input" for @bind

    result = @htl """
    <span style=$(style_attr)>
    <link rel="stylesheet" href=$(MATHLIVE_CDN_CSS) />
    <script defer src=$(MATHLIVE_CDN_JS)></script>
    <script defer src=$(COMPUTE_ENGINE_CDN_JS)></script>

    <math-field
        style="width: 100%; font-size: 1.2em; padding: 8px; border: 1px solid #ccc; border-radius: 4px; display: block;"
    ></math-field>

    <script>
    // Pluto provides `currentScript` — navigate to wrapper <span>
    const wrapper = currentScript.parentElement;
    const mf = wrapper.querySelector("math-field");

    const outputFormat = $(output_format);
    const initLatex = $(initial_latex);
    const initMathJSON = $(initial_mathjson);
    const isDisabled = $(disabled_str);
    const macros = $(HypertextLiteral.JavaScript(macros_json));
    const options = $(HypertextLiteral.JavaScript(options_json));

    function emitValue() {
        if (outputFormat === "latex") {
            wrapper.value = mf.getValue("latex");
        } else {
            try {
                const mjson = mf.getValue("math-json");
                const mjsonStr = (typeof mjson === "string") ? mjson : JSON.stringify(mjson);
                // Check if we got the "compute-engine-not-available" error
                if (mjsonStr.includes("compute-engine-not-available")) {
                    // Compute Engine not loaded yet — send LaTeX as fallback
                    // It will be replaced once CE loads and emitValue is called again
                    wrapper.value = mf.getValue("latex");
                } else {
                    wrapper.value = mjsonStr;
                }
            } catch (e) {
                wrapper.value = mf.getValue("latex");
            }
        }
        wrapper.dispatchEvent(new CustomEvent("input"));
    }

    function configureMathField() {
        // STA-04: Read-only mode
        if (isDisabled) {
            mf.readOnly = true;
        }

        // OPT-07: Custom macros
        if (Object.keys(macros).length > 0) {
            mf.macros = { ...mf.macros, ...macros };
        }

        // OPT-05: Custom MathLive options
        for (const [key, val] of Object.entries(options)) {
            try { mf[key] = val; } catch(e) { console.warn("PlutoMathInput: option error:", key, e); }
        }

        // STA-01: Virtual keyboard — force "manual" so the toggle
        // button (⌨) appears even on desktop
        mf.mathVirtualKeyboardPolicy = "manual";

        // Show/hide virtual keyboard on focus/blur
        mf.addEventListener("focusin", () => {
            window.mathVirtualKeyboard.show();
        });
        mf.addEventListener("focusout", () => {
            window.mathVirtualKeyboard.hide();
        });

        // EVT-04 / EVT-05: Set initial value
        if (initLatex) {
            mf.setValue(initLatex);
        } else if (initMathJSON) {
            try {
                const ce = window.MathfieldElement?.computeEngine
                         ?? mf.computeEngine;
                if (ce) {
                    const expr = JSON.parse(initMathJSON);
                    const boxed = ce.box(expr);
                    mf.setValue(boxed.latex);
                }
            } catch (e) {
                console.warn("PlutoMathInput: Invalid default MathJSON, starting empty.", e);
            }
        }

        // EVT-01: Emit on every edit
        mf.addEventListener("input", emitValue);
        // EVT-06: Also emit on Enter
        mf.addEventListener("change", emitValue);

        // Emit initial value for @bind
        emitValue();

        // Re-emit after a short delay in case the Compute Engine
        // loads after MathLive (needed for MathJSON output)
        if (outputFormat !== "latex") {
            setTimeout(emitValue, 1500);
            setTimeout(emitValue, 3000);
        }
    }

    // Wait for the <math-field> custom element to be registered
    // (the defer script may not have loaded yet)
    if (customElements.get("math-field")) {
        // Already loaded (e.g. second widget on the page)
        configureMathField();
    } else {
        customElements.whenDefined("math-field").then(() => {
            configureMathField();
        }).catch((e) => {
            // UNW-01: Fallback textarea
            console.warn("PlutoMathInput: MathLive failed to load.", e);
            const ta = document.createElement("textarea");
            ta.placeholder = "MathLive unavailable — enter LaTeX here";
            ta.style.cssText = "width:100%;font-family:monospace;min-height:2.5em;padding:8px;border:1px solid #ccc;border-radius:4px;";
            if (initLatex) ta.value = initLatex;
            ta.addEventListener("input", () => {
                wrapper.value = ta.value;
                wrapper.dispatchEvent(new CustomEvent("input"));
            });
            mf.replaceWith(ta);
            wrapper.value = ta.value;
            wrapper.dispatchEvent(new CustomEvent("input"));
        });
    }

    // Set initial value immediately so @bind doesn't stay at "nothing"
    if (outputFormat === "latex") {
        wrapper.value = initLatex || "";
    } else {
        wrapper.value = initMathJSON || "";
    }
    </script>
    </span>
    """

    show(io, mime, result)
end