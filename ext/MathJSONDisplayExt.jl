module MathJSONDisplayExt

using PlutoMathInput
using MathJSON
using HypertextLiteral

import MathJSON: AbstractMathJSONExpr, NumberExpr, SymbolExpr, StringExpr, FunctionExpr,
                 MathJSONFormat, generate

# CDN constants from PlutoMathInput
const _MATHLIVE_CDN_JS  = PlutoMathInput.MATHLIVE_CDN_JS
const _MATHLIVE_CDN_CSS = PlutoMathInput.MATHLIVE_CDN_CSS
const _COMPUTE_ENGINE_CDN_JS = PlutoMathInput.COMPUTE_ENGINE_CDN_JS

"""
    _mathjson_html(expr::AbstractMathJSONExpr)

Generate an HTML fragment that renders a MathJSON expression as formatted
mathematics using MathLive's `<math-field>` custom element. The MathJSON-to-LaTeX
conversion is delegated entirely to the CortexJS Compute Engine in the browser.
"""
function _mathjson_html(expr::AbstractMathJSONExpr)
    json_str = generate(MathJSONFormat, expr)

    @htl """
    <span class="mathjson-display">
    <link rel="stylesheet" href=$(_MATHLIVE_CDN_CSS) />

    <math-field read-only
        style="border: none; padding: 0; background: transparent; font-size: 1.2em;">
    </math-field>
    <span class="mathjson-fallback" style="display:none;">$(json_str)</span>

    <script>
    (function() {
        const wrapper = currentScript.parentElement;
        const mf = wrapper.querySelector("math-field");
        const fallbackEl = wrapper.querySelector(".mathjson-fallback");
        const jsonStr = $(json_str);

        function showFallback() {
            if (mf) mf.style.display = "none";
            if (fallbackEl) fallbackEl.style.display = "inline";
        }

        function loadScript(src) {
            if (document.querySelector('script[src="' + src + '"]')) {
                return Promise.resolve();
            }
            return new Promise(function(resolve, reject) {
                var s = document.createElement("script");
                s.src = src;
                s.onload = resolve;
                s.onerror = reject;
                document.head.appendChild(s);
            });
        }

        function mjsonToLatex(node) {
            if (Array.isArray(node) && node.length > 1) {
                var head = node[0];
                var args = node.slice(1);
                if (head === "Add") {
                    var parts = args.map(mjsonToLatex);
                    return parts.reduce(function(acc, p, i) {
                        if (i === 0) return p;
                        if (p.startsWith("-")) return acc + p;
                        return acc + "+" + p;
                    }, "");
                }
                if (head === "Multiply") {
                    return args.map(mjsonToLatex).join("\\\\cdot ");
                }
            }
            try { return ce.box(node, {canonical: false}).latex || String(node); }
            catch(_) { return String(node); }
        }

        var timeoutId = setTimeout(showFallback, 10000);

        loadScript($(_MATHLIVE_CDN_JS)).then(function() {
            return loadScript($(_COMPUTE_ENGINE_CDN_JS));
        }).then(function() {
            var ce = window.MathfieldElement && window.MathfieldElement.computeEngine;
            if (!ce) { showFallback(); return; }
            try {
                var json = JSON.parse(jsonStr);
                var latex = mjsonToLatex(json);
                mf.setValue(latex);
                clearTimeout(timeoutId);
            } catch(e) {
                console.warn("MathJSONDisplayExt: Failed to parse MathJSON", e);
                showFallback();
                clearTimeout(timeoutId);
            }
        }).catch(function(e) {
            console.warn("MathJSONDisplayExt: Failed to load JS libraries", e);
            showFallback();
            clearTimeout(timeoutId);
        });
    })();
    </script>
    </span>
    """
end

# US1: Base.show methods for mathematical expressions
function Base.show(io::IO, mime::MIME"text/html", expr::NumberExpr)
    show(io, mime, _mathjson_html(expr))
end

function Base.show(io::IO, mime::MIME"text/html", expr::SymbolExpr)
    show(io, mime, _mathjson_html(expr))
end

function Base.show(io::IO, mime::MIME"text/html", expr::FunctionExpr)
    show(io, mime, _mathjson_html(expr))
end

# US1: StringExpr renders as inline code, no math formatting
function Base.show(io::IO, mime::MIME"text/html", expr::StringExpr)
    show(io, mime, @htl("<code>$(expr.value)</code>"))
end

end # module
