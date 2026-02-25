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
        @test_throws ArgumentError MathInput(format = :symbolics)
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

@testset "MathDisplay" begin

    # --- Phase 2: Constructor tests (T003, T004) ---

    @testset "Constructor defaults" begin
        md = MathDisplay()
        @test md.default == ""
        @test md.latex == ""
        @test md.style == ""
        @test isempty(md.options)
        @test isempty(md.macros)
    end

    @testset "Constructor with arguments" begin
        md = MathDisplay(
            default = "[\"Add\", \"x\", 1]",
            latex = "x + 1",
            style = "font-size: 2em;",
            options = Dict{String,Any}("letterShapeStyle" => "french"),
            macros = Dict{String,String}("\\R" => "\\mathbb{R}"),
        )
        @test md.default == "[\"Add\", \"x\", 1]"
        @test md.latex == "x + 1"
        @test md.style == "font-size: 2em;"
        @test md.options["letterShapeStyle"] == "french"
        @test md.macros["\\R"] == "\\mathbb{R}"
    end

    # --- Phase 3: User Story 1 tests (T006-T010) ---

    @testset "HTML rendering" begin
        md = MathDisplay(latex = "x^2")
        html = repr(MIME"text/html"(), md)
        @test occursin("math-field", html)
        @test occursin("mathlive", html)
        @test occursin("cdn.jsdelivr.net", html)
    end

    @testset "HTML read-only attribute" begin
        md = MathDisplay(latex = "x^2")
        html = repr(MIME"text/html"(), md)
        @test occursin("read-only", html)
    end

    @testset "HTML centering" begin
        md = MathDisplay(latex = "x^2")
        html = repr(MIME"text/html"(), md)
        @test occursin("text-align", html)
    end

    @testset "HTML fallback" begin
        md = MathDisplay(latex = "x^2")
        html = repr(MIME"text/html"(), md)
        @test occursin("mathdisplay-fallback", html)
        @test occursin("x^2", html)
    end

    @testset "HTML empty LaTeX" begin
        md = MathDisplay()
        html = repr(MIME"text/html"(), md)
        @test occursin("mathdisplay-fallback", html)
    end

    # --- Phase 4: User Story 2 tests (T014-T016) ---

    @testset "HTML MathJSON rendering" begin
        md = MathDisplay(default = "[\"Add\", \"x\", 1]")
        html = repr(MIME"text/html"(), md)
        @test occursin("math-field", html)
        @test occursin("[\"Add\", \"x\", 1]", html) || occursin("[\\\"Add\\\", \\\"x\\\", 1]", html) || occursin("Add", html)
    end

    @testset "HTML LaTeX precedence over MathJSON" begin
        md = MathDisplay(default = "[\"Add\", \"x\", 1]", latex = "x+1")
        html = repr(MIME"text/html"(), md)
        @test occursin("x+1", html)
    end

    @testset "HTML invalid MathJSON" begin
        md = MathDisplay(default = "invalid json{{{")
        html = repr(MIME"text/html"(), md)
        @test occursin("math-field", html)
    end

    # --- Phase 5: User Story 3 tests (T020-T022) ---

    @testset "HTML custom style" begin
        md = MathDisplay(style = "width: 50%; background: #f0f0f0;")
        html = repr(MIME"text/html"(), md)
        @test occursin("width: 50%", html)
    end

    @testset "HTML macros" begin
        md = MathDisplay(macros = Dict{String,String}("\\R" => "\\mathbb{R}"))
        html = repr(MIME"text/html"(), md)
        @test occursin("\\\\mathbb{R}", html) || occursin("mathbb", html)
    end

    @testset "HTML options" begin
        md = MathDisplay(options = Dict{String,Any}("letterShapeStyle" => "french"))
        html = repr(MIME"text/html"(), md)
        @test occursin("letterShapeStyle", html)
    end

end
