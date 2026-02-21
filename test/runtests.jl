using Test
using PlutoMathInput

@testset "PlutoMathInput.jl" begin

    @testset "Constructor defaults" begin
        mi = MathInput()
        @test mi.default == ""
        @test mi.latex == ""
        @test mi.format == :mathjson
        @test mi.disabled == false
        @test mi.style == ""
        @test isempty(mi.options)
        @test isempty(mi.macros)
    end

    @testset "Constructor with arguments" begin
        mi = MathInput(
            default = "[\"Add\", \"x\", 1]",
            format = :mathjson,
            disabled = true,
            style = "width: 100%",
            options = Dict{String,Any}("smartFence" => true),
            macros = Dict{String,String}("\\R" => "\\mathbb{R}"),
        )
        @test mi.default == "[\"Add\", \"x\", 1]"
        @test mi.disabled == true
        @test mi.style == "width: 100%"
        @test mi.options["smartFence"] == true
        @test mi.macros["\\R"] == "\\mathbb{R}"
    end

    @testset "Constructor with LaTeX default" begin
        mi = MathInput(latex = "x + 1")
        @test mi.latex == "x + 1"
        @test mi.default == ""
    end

    @testset "Invalid format" begin
        @test_throws ArgumentError MathInput(format = :invalid)
    end

    @testset "initial_value (STA-05)" begin
        # MathJSON format
        mi = MathInput(default = "[\"Add\", \"x\", 1]")
        @test PlutoMathInput.Bonds.initial_value(mi) == "[\"Add\", \"x\", 1]"

        # LaTeX format
        mi_latex = MathInput(latex = "x + 1", format = :latex)
        @test PlutoMathInput.Bonds.initial_value(mi_latex) == "x + 1"

        # Empty default
        mi_empty = MathInput()
        @test PlutoMathInput.Bonds.initial_value(mi_empty) == ""
    end

    @testset "possible_values" begin
        mi = MathInput()
        @test PlutoMathInput.Bonds.possible_values(mi) isa PlutoMathInput.Bonds.InfinitePossibilities
    end

    @testset "transform_value" begin
        # MathJSON format: pass-through
        mi = MathInput()
        @test PlutoMathInput.Bonds.transform_value(mi, "[\"Add\", \"x\", 1]") == "[\"Add\", \"x\", 1]"

        # LaTeX format: pass-through as string
        mi_latex = MathInput(format = :latex)
        @test PlutoMathInput.Bonds.transform_value(mi_latex, "x + 1") == "x + 1"

        # Symbolics format without Symbolics loaded: fallback to string
        mi_sym = MathInput(format = :symbolics)
        val = PlutoMathInput.Bonds.transform_value(mi_sym, "[\"Add\", \"x\", 1]")
        @test val isa String
    end

    @testset "HTML rendering (UBI-01, UBI-04)" begin
        mi = MathInput(latex = "x^2")
        html = repr(MIME"text/html"(), mi)
        @test occursin("math-field", html)
        @test occursin("mathlive", html)
        @test occursin("cdn.jsdelivr.net", html)
    end

    @testset "HTML disabled mode (STA-04)" begin
        mi = MathInput(latex = "E = mc^2", disabled = true)
        html = repr(MIME"text/html"(), mi)
        # disabled is applied dynamically via JS (isDisabled variable)
        @test occursin("true", html)  # isDisabled = "true" in the JS
    end

    @testset "HTML custom style (OPT-06)" begin
        mi = MathInput(style = "width: 50%; background: #f0f0f0;")
        html = repr(MIME"text/html"(), mi)
        @test occursin("width: 50%", html)
    end

    @testset "HTML options applied (OPT-05)" begin
        mi = MathInput(options = Dict{String,Any}("smartFence" => true))
        html = repr(MIME"text/html"(), mi)
        @test occursin("smartFence", html)
    end

    @testset "HTML macros applied (OPT-07)" begin
        mi = MathInput(macros = Dict{String,String}("\\R" => "\\mathbb{R}"))
        html = repr(MIME"text/html"(), mi)
        @test occursin("\\\\mathbb{R}", html) || occursin("mathbb", html)
    end

    @testset "HTML loading indicator (STA-03)" begin
        mi = MathInput()
        html = repr(MIME"text/html"(), mi)
        @test occursin("Loading math editor...", html)
        @test occursin("mathinput-fallback", html)
    end

    @testset "HTML invalid default renders (UNW-05)" begin
        mi = MathInput(default = "invalid json{{{")
        html = repr(MIME"text/html"(), mi)
        # Should render without error
        @test occursin("math-field", html)
    end

    @testset "HTML Web Components check (UNW-04)" begin
        mi = MathInput()
        html = repr(MIME"text/html"(), mi)
        @test occursin("customElements", html)
    end

    @testset "HTML static fallback (EVT-07)" begin
        mi = MathInput(latex = "x^2")
        html = repr(MIME"text/html"(), mi)
        @test occursin("mathinput-fallback", html)
        @test occursin("x^2", html)
    end
end

# Symbolics extension tests (only run if Symbolics is available)
const _HAS_SYMBOLICS = try
    using Symbolics
    true
catch
    false
end

if _HAS_SYMBOLICS
    @testset "Symbolics extension (OPT-01, OPT-02)" begin
        @testset "to_symbolics" begin
            expr = PlutoMathInput.to_symbolics("[\"Add\", \"x\", 1]")
            @test expr isa Symbolics.Num || expr isa Number
        end

        @testset "from_symbolics" begin
            Symbolics.@variables x
            mjson = PlutoMathInput.from_symbolics(x + 1)
            @test mjson isa String
        end

        @testset "transform_value with Symbolics" begin
            mi = MathInput(format = :symbolics)
            val = PlutoMathInput.Bonds.transform_value(mi, "[\"Add\", \"x\", 1]")
            # Should now return a Symbolics expression
            @test !(val isa String)
        end
    end
else
    @info "Symbolics.jl not available, skipping extension tests"
end
