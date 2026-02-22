# MathDisplay

`MathDisplay` renders read-only, centered mathematical formulas in Pluto notebooks. It accepts LaTeX or MathJSON input and uses [MathLive](https://mathlive.io/) for beautiful typesetting.

Unlike [`MathInput`](../README.md), `MathDisplay` is **display-only** and does not participate in Pluto's `@bind` interface.

## Basic Usage

### Display a LaTeX formula

```julia
using PlutoMathInput

MathDisplay(latex = "x^2 + y^2 = r^2")
```

### Display a MathJSON expression

```julia
MathDisplay(default = """["Add", "x", 1]""")
```

### Display output from MathInput

```julia
# Cell 1: capture formula
@bind formula MathInput(latex = "x + 1")

# Cell 2: display the captured formula (as MathJSON)
MathDisplay(default = formula)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `default` | `String` | `""` | MathJSON string to render |
| `latex` | `String` | `""` | LaTeX string to render (takes precedence over `default`) |
| `style` | `String` | `""` | CSS style for the container |
| `options` | `Dict{String,Any}` | `Dict()` | MathLive options (e.g., `"letterShapeStyle" => "french"`) |
| `macros` | `Dict{String,String}` | `Dict()` | Custom LaTeX macros (e.g., `"\\R" => "\\mathbb{R}"`) |

## Custom Styling

```julia
MathDisplay(latex = "E = mc^2", style = "font-size: 2em; color: blue;")
```

## Custom Macros

```julia
MathDisplay(
    latex = "\\R \\to \\R",
    macros = Dict{String,String}("\\R" => "\\mathbb{R}"),
)
```

## MathLive Options

```julia
MathDisplay(
    latex = "x + y",
    options = Dict{String,Any}("letterShapeStyle" => "french"),
)
```

For the full list of MathLive options, see [options-and-macros.md](options-and-macros.md).

## Differences from MathInput

| Aspect | MathInput | MathDisplay |
|--------|-----------|-------------|
| Editable | Yes (by default) | No (always read-only) |
| `@bind` compatible | Yes | No |
| Centered | No | Yes |
| `format` parameter | Yes | No (display-only) |
| `disabled` parameter | Yes | No (always read-only) |
| `canonicalize` parameter | Yes | No (display-only) |
