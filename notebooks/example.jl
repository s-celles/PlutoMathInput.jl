### A Pluto.jl notebook ###
# v0.20.22

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
    import Pkg
    Pkg.activate(joinpath(@__DIR__, ".."))
    Pkg.instantiate()
    using PlutoMathInput
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
@bind formula_latex_default MathInput(latex=raw"\mathcal{L}\{f\}(s) = \int_{0}^{\infty} f(t)\, e^{-st}\, \mathrm{d}t", format=:mathjson)

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
@bind formula_mathjson MathInput(default="1+x", format=:mathjson)

# ╔═╡ 0549da15-4b1d-42a8-a784-eb04e4eedc5a
formula_mathjson

# ╔═╡ Cell order:
# ╟─8a1b2c3d-4e5f-6a7b-8c9d-0e1f2a3b4c5d
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
