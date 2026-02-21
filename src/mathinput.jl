"""
    MathInput(; kwargs...)

A Pluto widget that provides a WYSIWYG math input field using
[MathLive](https://mathlive.io/). Returns the formula as a MathJSON string
by default, compatible with [`MathJSON.jl`](https://github.com/s-celles/MathJSON.jl).

# Keyword Arguments
- `default::String=""`: default value as a MathJSON string (e.g. `"[\\"Add\\", \\"x\\", 1]"`)
- `latex::String=""`: default value as LaTeX (alternative to `default`, e.g. `"x + 1"`)
- `format::Symbol=:mathjson`: output format — `:mathjson`, `:latex`, or `:symbolics`
- `disabled::Bool=false`: if `true`, the field is read-only
- `style::String=""`: CSS style applied to the container `<div>`
- `options::Dict{String,Any}=Dict()`: extra MathLive options (e.g. `"smartFence" => true`)
- `macros::Dict{String,String}=Dict()`: custom LaTeX macros (e.g. `"\\\\R" => "\\\\mathbb{R}"`)

# Examples
```julia
# Simple input — returns MathJSON string
@bind formula MathInput()

# With a LaTeX default
@bind formula MathInput(latex="\\\\frac{x^2+1}{2}")

# Read-only display
MathInput(latex="E = mc^2", disabled=true)
```

See also the [specification (EARS)](docs/EARS.md) for the full requirements.
"""
struct MathInput
    default::String
    latex::String
    format::Symbol
    disabled::Bool
    style::String
    options::Dict{String,Any}
    macros::Dict{String,String}
end

function MathInput(;
    default::String = "",
    latex::String = "",
    format::Symbol = :mathjson,
    disabled::Bool = false,
    style::String = "",
    options::Dict{String,Any} = Dict{String,Any}(),
    macros::Dict{String,String} = Dict{String,String}(),
)
    format in (:mathjson, :latex, :symbolics) ||
        throw(ArgumentError("format must be :mathjson, :latex, or :symbolics, got :$format"))
    return MathInput(default, latex, format, disabled, style, options, macros)
end

# --- AbstractPlutoDingetjes interface ---

function Bonds.initial_value(mi::MathInput)
    if mi.format == :latex
        return mi.latex
    else
        # Return the default MathJSON string (or empty string)
        return mi.default
    end
end

function Bonds.possible_values(::MathInput)
    return Bonds.InfinitePossibilities()
end

function Bonds.transform_value(mi::MathInput, value_from_js)
    if mi.format == :latex
        return string(value_from_js)
    elseif mi.format == :symbolics
        # Symbolics conversion is handled via the extension.
        # If Symbolics is not loaded, return the raw MathJSON string.
        return _maybe_to_symbolics(string(value_from_js))
    else
        return string(value_from_js)
    end
end

# Fallback: just return the string. Overridden by the Symbolics extension.
_maybe_to_symbolics(s::String) = s
