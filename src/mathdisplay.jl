"""
    MathDisplay(; kwargs...)

A read-only Pluto widget that renders mathematical formulas using
[MathLive](https://mathlive.io/). Unlike [`MathInput`](@ref), this component
is display-only and does not participate in Pluto's `@bind` interface.
Formulas are centered horizontally in the cell.

# Keyword Arguments
- `default::String=""`: value as a MathJSON string (e.g. `"[\\"Add\\", \\"x\\", 1]"`)
- `latex::String=""`: value as LaTeX (e.g. `"x^2 + y^2 = r^2"`). Takes precedence over `default`.
- `style::String=""`: CSS style applied to the container `<span>`
- `options::Dict{String,Any}=Dict()`: MathLive options (e.g. `"letterShapeStyle" => "french"`)
- `macros::Dict{String,String}=Dict()`: custom LaTeX macros (e.g. `"\\\\R" => "\\\\mathbb{R}"`)

# Examples
```julia
# Display a LaTeX formula
MathDisplay(latex="x^2 + y^2 = r^2")

# Display a MathJSON expression
MathDisplay(default=\\"\\"\\"[\\"Add\\", \\"x\\", 1]\\"\\"\\"\\")

# With custom styling
MathDisplay(latex="E = mc^2", style="font-size: 2em;")
```
"""
struct MathDisplay
    default::String
    latex::String
    style::String
    options::Dict{String,Any}
    macros::Dict{String,String}
end

function MathDisplay(;
    default::String = "",
    latex::String = "",
    style::String = "",
    options::Dict{String,Any} = Dict{String,Any}(),
    macros::Dict{String,String} = Dict{String,String}(),
)
    return MathDisplay(default, latex, style, options, macros)
end
