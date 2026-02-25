using Test
using PlutoMathInput
using MathJSON

@testset "MathJSONDisplayExt" begin

    @testset "NumberExpr HTML rendering" begin
        html = repr(MIME"text/html"(), NumberExpr(42))
        @test occursin("<math-field", html)
        @test occursin("read-only", html)
        @test occursin("mathjson-display", html)
        @test occursin(PlutoMathInput.MATHLIVE_CDN_JS, html)
        @test occursin(PlutoMathInput.COMPUTE_ENGINE_CDN_JS, html)
    end

    @testset "SymbolExpr HTML rendering" begin
        html = repr(MIME"text/html"(), SymbolExpr("x"))
        @test occursin("<math-field", html)
        @test occursin("read-only", html)
        @test occursin("mathjson-display", html)
        # JSON for symbol "x" should be present
        @test occursin("x", html)
    end

    @testset "FunctionExpr HTML rendering" begin
        expr = FunctionExpr(:Add, [SymbolExpr("x"), NumberExpr(1)])
        html = repr(MIME"text/html"(), expr)
        @test occursin("<math-field", html)
        @test occursin("read-only", html)
        @test occursin("mathjson-display", html)
        # JSON for the Add expression should be present
        @test occursin("Add", html)
    end

    @testset "StringExpr HTML rendering" begin
        html = repr(MIME"text/html"(), StringExpr("hello"))
        @test occursin("<code>", html)
        @test occursin("hello", html)
        @test occursin("</code>", html)
        # StringExpr should NOT have math-field
        @test !occursin("<math-field", html)
        @test !occursin("mathjson-display", html)
    end

    @testset "Operand order preservation (JS)" begin
        html = repr(MIME"text/html"(), FunctionExpr(:Add, [SymbolExpr("x"), NumberExpr(1)]))
        # The embedded JavaScript should contain mjsonToLatex with Add/Multiply handling
        @test occursin("mjsonToLatex", html)
        @test occursin("\"Add\"", html)
        @test occursin("\"Multiply\"", html)
    end

    @testset "Fallback handling (JS)" begin
        html = repr(MIME"text/html"(), NumberExpr(42))
        # Should have error handling
        @test occursin(".catch", html)
        @test occursin("mathjson-fallback", html)
        @test occursin("console.warn", html)
    end

    @testset "Script deduplication (JS)" begin
        html = repr(MIME"text/html"(), NumberExpr(42))
        @test occursin("loadScript", html)
        @test occursin("querySelector", html)
    end

    @testset "CDN URLs match PlutoMathInput constants" begin
        html = repr(MIME"text/html"(), NumberExpr(1))
        @test occursin(PlutoMathInput.MATHLIVE_CDN_CSS, html)
        @test occursin(PlutoMathInput.MATHLIVE_CDN_JS, html)
        @test occursin(PlutoMathInput.COMPUTE_ENGINE_CDN_JS, html)
    end

end
