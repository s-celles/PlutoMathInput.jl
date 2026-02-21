# MathLive CDN URLs (UBI-04)
const MATHLIVE_VERSION = "0.108.3"
const MATHLIVE_CDN_BASE = "https://cdn.jsdelivr.net/npm/mathlive@$(MATHLIVE_VERSION)"
const MATHLIVE_CDN_JS  = "$(MATHLIVE_CDN_BASE)/mathlive.min.js"
const MATHLIVE_CDN_CSS = "$(MATHLIVE_CDN_BASE)/mathlive-static.css"
const COMPUTE_ENGINE_CDN_JS = "https://cdn.jsdelivr.net/npm/@cortex-js/compute-engine/dist/compute-engine.min.umd.js"

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
    # - Load MathLive via a dynamically created <script> (non-ESM)
    # - Create <math-field> AFTER MathLive loads (avoids custom element
    #   upgrade issues in Pluto's DOM)
    # - Do NOT set mathVirtualKeyboardPolicy to "manual" — it hijacks
    #   keyboard events and breaks physical keyboard input
    # - Wrapper <span> gets .value and dispatches "input" for @bind

    result = @htl """
    <span style=$(style_attr)>
    <link rel="stylesheet" href=$(MATHLIVE_CDN_CSS) />

    <div class="math-field-container"
        style="width: 100%; min-height: 2.5em; border: 1px solid #ccc; border-radius: 4px; padding: 8px; font-size: 1.2em;">
    </div>

    <script>
    const wrapper = currentScript.parentElement;
    const container = wrapper.querySelector(".math-field-container");

    const outputFormat = $(output_format);
    const initLatex = $(initial_latex);
    const initMathJSON = $(initial_mathjson);
    const isDisabled = $(disabled_str);
    const macros = $(HypertextLiteral.JavaScript(macros_json));
    const options = $(HypertextLiteral.JavaScript(options_json));

    function loadScript(src) {
        if (document.querySelector('script[src=\"' + src + '\"]')) {
            return Promise.resolve();
        }
        return new Promise((resolve, reject) => {
            const s = document.createElement("script");
            s.src = src;
            s.onload = resolve;
            s.onerror = reject;
            document.head.appendChild(s);
        });
    }

    function setup() {
        const mf = document.createElement("math-field");
        mf.style.cssText = "width: 100%; font-size: inherit; display: block;";

        // Set initial value via textContent (works before custom element upgrade)
        if (initLatex) {
            mf.textContent = initLatex;
        }

        // Read-only via attribute (works before upgrade)
        if (isDisabled === "true") {
            mf.setAttribute("read-only", "");
        }

        // Insert into DOM
        container.style.border = "none";
        container.style.padding = "0";
        container.replaceChildren(mf);

        // @bind: forward math-field events to the wrapper
        function emitValue() {
            if (outputFormat === "latex") {
                wrapper.value = typeof mf.getValue === "function"
                    ? mf.getValue("latex") : (mf.value || "");
            } else {
                try {
                    const mjson = mf.getValue("math-json");
                    const mjsonStr = (typeof mjson === "string") ? mjson : JSON.stringify(mjson);
                    if (mjsonStr.includes("compute-engine-not-available")) {
                        wrapper.value = mf.getValue("latex");
                    } else {
                        wrapper.value = mjsonStr;
                    }
                } catch (e) {
                    wrapper.value = typeof mf.getValue === "function"
                        ? mf.getValue("latex") : (mf.value || "");
                }
            }
            wrapper.dispatchEvent(new CustomEvent("input"));
        }

        mf.addEventListener("input", emitValue);
        mf.addEventListener("change", emitValue);
    }

    // Load MathLive, then setup immediately.
    // Compute Engine loads in background (optional, for MathJSON output).
    loadScript($(MATHLIVE_CDN_JS)).then(() => {
        // Disable sounds globally — MathLive resolves sound paths relative to
        // the script URL, creating invalid CDN paths (mathlive.min.js/sounds/...)
        const MFClass = customElements.get("math-field");
        if (MFClass) MFClass.soundsDirectory = null;

        setup();

        // Load Compute Engine in background for MathJSON support
        if (outputFormat !== "latex") {
            loadScript($(COMPUTE_ENGINE_CDN_JS)).catch((e) => {
                console.warn("PlutoMathInput: Compute Engine not loaded, MathJSON output may fall back to LaTeX.", e);
            });
        }
    }).catch((e) => {
        // UNW-01: Fallback textarea
        console.warn("PlutoMathInput: MathLive failed to load.", e);
        const ta = document.createElement("textarea");
        ta.placeholder = "MathLive unavailable — enter LaTeX here";
        ta.style.cssText = "width:100%;font-family:monospace;min-height:2.5em;padding:8px;border:none;";
        if (initLatex) ta.value = initLatex;
        ta.addEventListener("input", () => {
            wrapper.value = ta.value;
            wrapper.dispatchEvent(new CustomEvent("input"));
        });
        container.replaceChildren(ta);
        wrapper.value = ta.value;
        wrapper.dispatchEvent(new CustomEvent("input"));
    });

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
