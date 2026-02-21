module PlutoMathInputSymbolicsExt

using PlutoMathInput
using Symbolics
using JSON3

"""
    to_symbolics(mathjson_str::String)

Convert a MathJSON string to a Symbolics.jl expression.

# Examples
```julia
using Symbolics, PlutoMathInput
expr = to_symbolics("[\"Add\", \"x\", 1]")
# x + 1
```
"""
function PlutoMathInput.to_symbolics(mathjson_str::String)
    # This is a bridge function. The actual MathJSON → Symbolics conversion
    # should be provided by MathJSON.jl. Here we provide a lightweight
    # fallback for common cases.
    json = JSON3.read(mathjson_str)
    return _mathjson_to_sym(json)
end

"""
    from_symbolics(expr) -> String

Convert a Symbolics expression to a MathJSON string suitable for
`MathInput(default=...)`.
"""
function PlutoMathInput.from_symbolics(expr)
    # Convert Symbolics → MathJSON string
    return _sym_to_mathjson(Symbolics.value(expr))
end

# Override the fallback so that format=:symbolics works
function PlutoMathInput._maybe_to_symbolics(s::String)
    try
        return PlutoMathInput.to_symbolics(s)
    catch e
        @warn "PlutoMathInput: Could not convert MathJSON to Symbolics" exception = e
        return s
    end
end

# ── Internal helpers ──

function _mathjson_to_sym(node)
    if node isa String
        # Variable name
        return Symbolics.variable(Symbol(node))
    elseif node isa Number
        return node
    elseif node isa AbstractVector
        isempty(node) && error("Empty MathJSON expression")
        head = node[1]
        args = [_mathjson_to_sym(a) for a in node[2:end]]
        return _apply_op(head, args)
    else
        error("Unsupported MathJSON node: $node")
    end
end

function _apply_op(op::String, args)
    if op == "Add"
        return sum(args)
    elseif op == "Subtract"
        length(args) == 2 || error("Subtract expects 2 arguments")
        return args[1] - args[2]
    elseif op == "Multiply"
        return prod(args)
    elseif op == "Divide"
        length(args) == 2 || error("Divide expects 2 arguments")
        return args[1] / args[2]
    elseif op == "Negate"
        length(args) == 1 || error("Negate expects 1 argument")
        return -args[1]
    elseif op == "Power"
        length(args) == 2 || error("Power expects 2 arguments")
        return args[1]^args[2]
    elseif op == "Sqrt"
        length(args) == 1 || error("Sqrt expects 1 argument")
        return sqrt(args[1])
    elseif op == "Sin"
        return sin(args[1])
    elseif op == "Cos"
        return cos(args[1])
    elseif op == "Tan"
        return tan(args[1])
    elseif op == "Exp"
        return exp(args[1])
    elseif op == "Ln"
        return log(args[1])
    else
        error("Unsupported MathJSON operator: $op")
    end
end

function _sym_to_mathjson(expr)
    # Simple serialisation of Symbolics expressions to MathJSON strings
    # For full support, use MathJSON.jl
    return JSON3.write(_sym_to_node(expr))
end

function _sym_to_node(x::Number)
    return x
end

function _sym_to_node(x::Symbolics.Sym)
    return string(x.name)
end

function _sym_to_node(x)
    # Fallback: convert to string (lossy)
    return string(x)
end

end # module
