# MathLive Options and Macros

## Options (OPT-05)

Pass MathLive configuration options via the `options` parameter. Options are applied as direct properties on the `<math-field>` element.

```julia
# Enable smart fences (auto-matching brackets)
@bind formula MathInput(options=Dict{String,Any}("smartFence" => true))

# Multiple options
@bind formula MathInput(options=Dict{String,Any}(
    "smartFence" => true,
    "smartSuperscript" => true,
    "letterShapeStyle" => "tex",
))
```

### Available Options

Common MathLive options include:

| Option | Type | Description |
|--------|------|-------------|
| `smartFence` | Bool | Auto-match brackets contextually |
| `smartSuperscript` | Bool | Auto-exit superscript on digit entry |
| `smartMode` | Bool | Auto-switch between math and text modes |
| `letterShapeStyle` | String | Letter styling: `"auto"`, `"tex"`, `"iso"`, `"french"`, `"upright"` |
| `defaultMode` | String | Initial mode: `"math"`, `"inline-math"`, `"text"` |
| `placeholder` | String | Placeholder text when field is empty |

See the [MathLive API Reference](https://mathlive.io/mathfield/api/) for the full list.

## Custom Macros (OPT-07)

Define custom LaTeX macros via the `macros` parameter. Custom macros are merged with MathLive's 800+ built-in macros.

```julia
# Define \R as \mathbb{R}
@bind formula MathInput(macros=Dict{String,String}(
    "\\R" => "\\mathbb{R}",
    "\\C" => "\\mathbb{C}",
    "\\N" => "\\mathbb{N}",
))
```

### Macros with Arguments

MathLive macros support up to 8 arguments using `#1`, `#2`, etc.:

```julia
@bind formula MathInput(macros=Dict{String,String}(
    "\\smallfrac" => "{}^{#1}\\!\\!/\\!{}_{#2}",
))
```

See the [MathLive Macros Guide](https://mathlive.io/mathfield/guides/macros/) for more details.
