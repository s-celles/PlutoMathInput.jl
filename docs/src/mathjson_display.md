# MathJSON Display Extension

PlutoMathInput.jl includes an automatic rendering extension for MathJSON expressions. When both `PlutoMathInput` and `MathJSON` are loaded, all `AbstractMathJSONExpr` subtypes render as formatted mathematics in Pluto and IJulia notebooks.

## Setup

No additional setup is required. Simply load both packages:

```julia
using PlutoMathInput
using MathJSON
```

The `MathJSONDisplayExt` extension activates automatically via Julia's package extension mechanism.

## Supported Expression Types

| Type | Rendering | Example |
|------|-----------|---------|
| `NumberExpr` | Formatted math | `NumberExpr(42)` displays as **42** |
| `SymbolExpr` | Formatted math | `SymbolExpr("x")` displays as **x** |
| `FunctionExpr` | Formatted math | `FunctionExpr(:Add, [SymbolExpr("x"), NumberExpr(1)])` displays as **x + 1** |
| `StringExpr` | Inline code | `StringExpr("hello")` displays as `hello` |

## Operand Order Preservation

The extension preserves the original operand order for `Add` and `Multiply` operations. This is important for pedagogical use cases:

```julia
# Displays as "x + 1", not "1 + x"
FunctionExpr(:Add, [SymbolExpr("x"), NumberExpr(1)])

# Displays as "a · b", not "b · a"
FunctionExpr(:Multiply, [SymbolExpr("a"), SymbolExpr("b")])
```

## How It Works

1. The Julia extension serializes the MathJSON expression to a JSON string using `MathJSON.generate(MathJSONFormat, expr)`.
2. The HTML output includes a `<math-field read-only>` element from MathLive.
3. JavaScript in the browser loads the CortexJS Compute Engine and converts the MathJSON to LaTeX.
4. The `<math-field>` renders the LaTeX as formatted mathematics.

No MathJSON-to-LaTeX conversion happens in Julia. All rendering is delegated to the browser.

## Fallback Behavior

If the CDN resources (MathLive or Compute Engine) fail to load, the raw MathJSON JSON string is displayed as plain text. This ensures expressions are always visible, even offline.

## Integration with MathJSONComputeEngineBridge.jl

The display extension works seamlessly with computed results:

```julia
using PlutoMathInput
using MathJSON
using MathJSONComputeEngineBridge

# Parse, evaluate, and display — result auto-renders
input = parse(MathJSONFormat, """["Add", 1, ["Multiply", 2, 3]]""")
result = evaluate(input)   # Returns NumberExpr(7), auto-rendered as "7"
```
