### A Pluto.jl notebook ###
# v1.0.3

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 8a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d
begin
    # import Pkg
    # Pkg.activate(joinpath(@__DIR__, ".."))
    # Pkg.instantiate()
    using PlutoMathInput
	using MathJSON
end

# ╔═╡ 1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d
md"""
# PlutoMathInput.jl — Example Notebook

This notebook demonstrates the **PlutoMathInput** widget, which provides a
WYSIWYG math editor inside Pluto using [MathLive](https://mathlive.io/).
"""

# ╔═╡ 2a3b4c5d-6e7f-8a9b-0c1d-2e3f4a5b6c7d
md"""
## 1. Basic usage

Type a formula below — the MathJSON representation is shown in the next cell.
"""

# ╔═╡ 3a4b5c6d-7e8f-9a0b-1c2d-3e4f5a6b7c8d
@bind formula_basic MathInput(format=:mathjson)

# ╔═╡ 4a5b6c7d-8e9f-0a1b-2c3d-4e5f6a7b8c9d
formula_basic  # MathJSON string

# ╔═╡ b2d74da0-853b-4bae-bc95-5e8568f45233
md"""
## 2. Default value (MathJSON)

The widget can be pre-filled with a MathJSON expression:
"""

# ╔═╡ 42625fdb-c3b9-4a34-85f1-34a86d39137e
@bind formula_mathjson_default MathInput(default="[\"Derivative\", [\"Sin\", \"x\"], \"x\"]", format=:mathjson, canonicalize=false)

# ╔═╡ 70cf1f91-f021-4e18-9a71-b505c6fd4b7e
formula_mathjson_default  # MathJSON string

# ╔═╡ c582cc9c-994c-4b97-a9b7-2db3b71d30a3
@bind formula_mathjson_default2 MathInput(default="[\"Integrate\", [\"Sin\", \"x\"], \"x\"]", format=:mathjson, canonicalize=false)

# ╔═╡ c80f902d-c43f-4fcc-ac1b-d389606a2ff4
formula_mathjson_default2

# ╔═╡ 5a6b7c8d-9e0f-1a2b-3c4d-5e6f7a8b9c0d
md"""
## 3. Default value (LaTeX)

The widget can be pre-filled with a LaTeX expression:
"""

# ╔═╡ 6a7b8c9d-0e1f-2a3b-4c5d-6e7f8a9b0c1d
@bind formula_latex_default MathInput(latex=raw"\mathcal{L}\{f\}(s) = \int_{0}^{\infty} f(t)\, e^{-st}\, \mathrm{d}t", format=:latex)

# ╔═╡ 7a8b9c0d-1e2f-3a4b-5c6d-7e8f9a0b1c2d
formula_latex_default

# ╔═╡ 8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3d
md"""
## 4. Read-only display with LaTeX input
"""

# ╔═╡ 9a0b1c2d-3e4f-5a6b-7c8d-9e0f1a2b3c4d
MathInput(latex="E = mc^2", disabled=true)

# ╔═╡ 0a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d
md"""
## 5. LaTeX output format
"""

# ╔═╡ 1b2c3d4e-5f6a-7b8c-9d0e-1f2a3b4c5d6e
@bind formula_latex MathInput(latex=raw"\frac{1}{1+x}", format=:latex)

# ╔═╡ 2c3d4e5f-6a7b-8c9d-0e1f-2a3b4c5d6e7f
formula_latex  # LaTeX string

# ╔═╡ dee491e5-1375-416a-9b8e-07557debbd77
md"""
## 6. MathJSON output format
"""

# ╔═╡ 168bbc9a-aa43-4b90-ba1b-6641265ecec4
@bind formula_mathjson MathInput(default="[\"Add\", \"y\", 1, \"x\"]", format=:mathjson)

# ╔═╡ 0549da15-4b1d-42a8-a784-eb04e4eedc5a
formula_mathjson

# ╔═╡ 31c6d3cb-40fa-4b43-811f-d4ca36a32859
@bind formula_mathjson2 MathInput(default="[\"Multiply\", \"y\", 1, \"x\"]", format=:mathjson)

# ╔═╡ 6fca2315-42cb-4b3e-84dd-bf9de4497995
formula_mathjson2

# ╔═╡ 418a0962-bddb-4a69-8755-6787cfe70616
md"""
## 7. MathJSON Display (auto-rendering)

When both `PlutoMathInput` and `MathJSON` are loaded, MathJSON expressions are **automatically rendered** as formatted mathematics — no extra setup needed.
"""

# ╔═╡ f3b985bb-3778-4aad-8cdc-4df693c9ea73
NumberExpr(42)

# ╔═╡ 2ec67358-4a9a-4ac7-b04a-5dc581fd4e4d
SymbolExpr("x")

# ╔═╡ d10ebfc8-dc42-47cd-b0c9-cec631df75e8
FunctionExpr(:Add, [SymbolExpr("x"), NumberExpr(1)])

# ╔═╡ e5170e29-a403-4a4b-9742-757b25779853
FunctionExpr(:Multiply, [SymbolExpr("a"), SymbolExpr("b")])

# ╔═╡ e55a46d6-f1e1-4c5e-913c-e030950add25
md"""
Operand order is preserved — `x + 1` stays `x + 1`, not `1 + x`:
"""

# ╔═╡ 6bc4581e-845b-4bd2-8a77-3cc3807decc9
FunctionExpr(:Add, [SymbolExpr("y"), NumberExpr(2), SymbolExpr("x")])

# ╔═╡ b2d71d29-81c2-44e9-b08c-8b692cc0f91f
StringExpr("hello")  # StringExpr renders as inline code

# ╔═╡ 7368d2e5-b733-4bff-b0d6-80895fcee80d
md"""
## 8. MathDisplay

Display MathJSON or LaTeX expression through MathField:
"""

# ╔═╡ a8dab61c-a81e-4e7c-967c-285d21970a45
MathDisplay(default="[\"Multiply\", \"y\", 3, \"x\"]")

# ╔═╡ ea36b7ee-a195-4915-b74b-f142f64a0701
MathDisplay(latex=raw"\frac{2}{\sqrt{1+x}}")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
MathJSON = "77215b4b-6f01-425c-beac-950ae6536d4d"
PlutoMathInput = "4bac68be-45d4-40a9-9f37-f14fc6d2878f"

[compat]
MathJSON = "~0.3.0"
PlutoMathInput = "~0.4.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.6"
manifest_format = "2.0"
project_hash = "c2172a4067760463f147ada77698e66640bfca3d"

[[deps.AbstractPlutoDingetjes]]
git-tree-sha1 = "6c3913f4e9bdf6ba3c08041a446fb1332716cbc2"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.4.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "PrecompileTools", "StructTypes", "UUIDs"]
git-tree-sha1 = "411eccfe8aba0814ffa0fdf4860913ed09c34975"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.14.3"

    [deps.JSON3.extensions]
    JSON3ArrowExt = ["ArrowTypes"]

    [deps.JSON3.weakdeps]
    ArrowTypes = "31f734f8-188a-4ce0-8406-c8a06bd891cd"

[[deps.MathJSON]]
deps = ["JSON3"]
git-tree-sha1 = "a5ff903af4886c9bb30510b2b3eb15368089f640"
uuid = "77215b4b-6f01-425c-beac-950ae6536d4d"
version = "0.3.0"

    [deps.MathJSON.extensions]
    MathJSONSymbolicsExt = ["Symbolics", "SymbolicUtils"]

    [deps.MathJSON.weakdeps]
    SymbolicUtils = "d1185830-fcd6-423d-90d6-eec64667417b"
    Symbolics = "0c5d862f-8b57-4792-8d23-62f2024744c7"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "32a4e09c5f29402573d673901778a0e03b0807b9"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.6"

[[deps.PlutoMathInput]]
deps = ["AbstractPlutoDingetjes", "HypertextLiteral", "JSON3"]
git-tree-sha1 = "a3ebc3890c89683953be8aaf783a2186b2c78537"
uuid = "4bac68be-45d4-40a9-9f37-f14fc6d2878f"
version = "0.4.1"
weakdeps = ["MathJSON"]

    [deps.PlutoMathInput.extensions]
    MathJSONDisplayExt = "MathJSON"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "edbeefc7a4889f528644251bdb5fc9ab5348bc2c"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "8b770b60760d4451834fe79dd483e318eee709c4"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.2"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "159331b30e94d7b11379037feeb9b690950cace8"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tricks]]
git-tree-sha1 = "311349fd1c93a31f783f977a71e8b062a57d4101"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.13"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"
"""

# ╔═╡ Cell order:
# ╠═8a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d
# ╟─1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d
# ╟─2a3b4c5d-6e7f-8a9b-0c1d-2e3f4a5b6c7d
# ╠═3a4b5c6d-7e8f-9a0b-1c2d-3e4f5a6b7c8d
# ╠═4a5b6c7d-8e9f-0a1b-2c3d-4e5f6a7b8c9d
# ╟─b2d74da0-853b-4bae-bc95-5e8568f45233
# ╠═42625fdb-c3b9-4a34-85f1-34a86d39137e
# ╠═70cf1f91-f021-4e18-9a71-b505c6fd4b7e
# ╠═c582cc9c-994c-4b97-a9b7-2db3b71d30a3
# ╠═c80f902d-c43f-4fcc-ac1b-d389606a2ff4
# ╟─5a6b7c8d-9e0f-1a2b-3c4d-5e6f7a8b9c0d
# ╠═6a7b8c9d-0e1f-2a3b-4c5d-6e7f8a9b0c1d
# ╠═7a8b9c0d-1e2f-3a4b-5c6d-7e8f9a0b1c2d
# ╟─8a9b0c1d-2e3f-4a5b-6c7d-8e9f0a1b2c3d
# ╠═9a0b1c2d-3e4f-5a6b-7c8d-9e0f1a2b3c4d
# ╟─0a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d
# ╠═1b2c3d4e-5f6a-7b8c-9d0e-1f2a3b4c5d6e
# ╠═2c3d4e5f-6a7b-8c9d-0e1f-2a3b4c5d6e7f
# ╟─dee491e5-1375-416a-9b8e-07557debbd77
# ╠═168bbc9a-aa43-4b90-ba1b-6641265ecec4
# ╠═0549da15-4b1d-42a8-a784-eb04e4eedc5a
# ╠═31c6d3cb-40fa-4b43-811f-d4ca36a32859
# ╠═6fca2315-42cb-4b3e-84dd-bf9de4497995
# ╟─418a0962-bddb-4a69-8755-6787cfe70616
# ╠═f3b985bb-3778-4aad-8cdc-4df693c9ea73
# ╠═2ec67358-4a9a-4ac7-b04a-5dc581fd4e4d
# ╠═d10ebfc8-dc42-47cd-b0c9-cec631df75e8
# ╠═e5170e29-a403-4a4b-9742-757b25779853
# ╟─e55a46d6-f1e1-4c5e-913c-e030950add25
# ╠═6bc4581e-845b-4bd2-8a77-3cc3807decc9
# ╠═b2d71d29-81c2-44e9-b08c-8b692cc0f91f
# ╟─7368d2e5-b733-4bff-b0d6-80895fcee80d
# ╠═a8dab61c-a81e-4e7c-967c-285d21970a45
# ╠═ea36b7ee-a195-4915-b74b-f142f64a0701
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
