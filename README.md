# PlutoMathInput.jl

[![CI](https://github.com/s-celles/PlutoMathInput.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/s-celles/PlutoMathInput.jl/actions/workflows/CI.yml)
[![codecov](https://codecov.io/gh/s-celles/PlutoMathInput.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/s-celles/PlutoMathInput.jl)

A [Pluto.jl](https://github.com/JuliaPluto/Pluto.jl) widget for WYSIWYG mathematical formula input, powered by [MathLive](https://mathlive.io/).

![PlutoMathInput screenshot](assets/screenshot.png)
![virtual keyboard 1](assets/vk1.png)
![virtual keyboard 2](assets/vk2.png)
![virtual keyboard 3](assets/vk3.png)
![virtual keyboard 4](assets/vk4.png)

## Features

- 📝 **WYSIWYG math editor** — type formulas visually with TeX-quality rendering
- 🔗 **`@bind` compatible** — works seamlessly with Pluto's reactivity
- 📦 **MathJSON output** — interoperable with [MathJSON.jl](https://github.com/s-celles/MathJSON.jl)
- 🧮 **Symbolics.jl integration** — optional conversion to symbolic expressions
- ⌨️ **Virtual keyboard** — touch-friendly math keyboard on mobile devices
- 🔄 **Multiple output formats** — MathJSON, LaTeX, or Symbolics.Num
- 🖥️ **Read-only display** — `MathDisplay` renders centered, read-only formulas from LaTeX or MathJSON

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/s-celles/PlutoMathInput.jl")
```

## Quick Start

```julia
using PlutoMathInput

# Basic input — returns MathJSON string
@bind formula MathInput()

# With MathJSON default value
@bind formula MathInput(default="""["Add", "x", 1]""")

# With LaTeX default
@bind formula MathInput(latex="\\frac{x^2+1}{2}")

# Read-only display (centered, no editing)
MathDisplay(latex="E = mc^2")

# Read-only display from MathJSON
MathDisplay(default="""["Add", "x", 1]""")

# LaTeX output format
@bind tex MathInput(format=:latex)
```

## With MathJSON.jl

```julia
using PlutoMathInput, MathJSON

@bind formula MathInput()
expr = parse(MathJSONFormat, formula)
```

## With Symbolics.jl

```julia
using PlutoMathInput, Symbolics

# Direct symbolic output
@bind sym_expr MathInput(format=:symbolics)
```

## Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `default` | `String` | `""` | Default value as MathJSON |
| `latex` | `String` | `""` | Default value as LaTeX |
| `format` | `Symbol` | `:mathjson` | Output: `:mathjson`, `:latex`, `:symbolics` |
| `disabled` | `Bool` | `false` | Read-only mode |
| `style` | `String` | `""` | CSS style for container |
| `options` | `Dict` | `Dict()` | MathLive options (e.g., `"smartFence" => true`) — see [docs](docs/options-and-macros.md) |
| `macros` | `Dict` | `Dict()` | Custom LaTeX macros (e.g., `"\\R" => "\\mathbb{R}"`) — see [docs](docs/options-and-macros.md) |
| `icon_position` | `Symbol` | `:right` | Position of MathLive icons: `:left` or `:right` — see [docs](docs/icon-position.md) |

## Example Notebook

Open `notebooks/example.jl` in Pluto for an interactive demo.

## Related Projects

- [MathLive](https://mathlive.io/) — the math editing library powering this widget ([GitHub](https://github.com/arnog/mathlive))
- [`<math-field>`](https://mathlive.io/mathfield/) — the web component (custom element) providing the interactive math input field
- [MathJSON](https://cortexjs.io/math-json/) — a JSON representation for mathematical expressions ([specification](https://cortexjs.io/math-json/))
- [MathJSON.jl](https://github.com/s-celles/MathJSON.jl) — Julia package to parse and manipulate MathJSON expressions
- [Compute Engine](https://cortexjs.io/compute-engine/) — JavaScript symbolic computation engine by [CortexJS](https://cortexjs.io/)

## License

MIT
