# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Removed

- Symbolics.jl extension (`ext/PlutoMathInputSymbolicsExt.jl`) and `:symbolics` output format
- `to_symbolics` / `from_symbolics` functions

### Added

- `MathDisplay` component: read-only, centered mathematical formula display using MathLive
  - Accepts LaTeX (`latex` parameter) or MathJSON (`default` parameter) input
  - Always read-only with no editable cursor or keyboard affordances
  - Horizontally centered in the Pluto cell
  - Supports custom CSS styling (`style`), MathLive options (`options`), and LaTeX macros (`macros`)
  - Graceful fallback when CDN is unavailable (shows raw LaTeX/MathJSON text)
  - Does not participate in `@bind` interface (display-only)

## [0.2.0] - 2026-02-21

### Added

- `canonicalize` option (`Bool`, default `false`): controls whether the Compute Engine canonicalizes MathJSON output; when `false`, operand order and expression structure are preserved
- Non-canonical MathJSON output via `ce.parse(latex, {canonical: false})` when `canonicalize=false`
- Order-preserving MathJSON-to-LaTeX display: custom `mjsonToLatex` converter handles `Add` and `Multiply` operand order correctly (CE's `ce.box` always reorders commutative operations)
- Apply MathLive options to `<math-field>` element (OPT-05): options like `smartFence`, `smartSuperscript` are now forwarded to MathLive
- Apply custom LaTeX macros to `<math-field>` element (OPT-07): macros like `\R => \mathbb{R}` are now merged with MathLive's built-in macros
- Loading indicator while MathLive loads from CDN (STA-03): shows "Loading math editor..." text
- Enter key submission (EVT-06): pressing Enter emits an `input` event to update the bound Pluto variable
- Web Components incompatibility detection (UNW-04): shows a clear message on browsers without Custom Elements support
- Invalid default value handling (UNW-05): invalid MathJSON or LaTeX defaults result in console warnings, not broken UI
- Static HTML export fallback (EVT-07): LaTeX formula displayed as fallback text when JavaScript is not available
- MathJSON default display: `default` parameter now renders the expression in the math-field after Compute Engine loads

### Fixed

- MathLive sounds 404 errors: `soundsDirectory` now points to the correct CDN path
- Symbolics extension precompilation error: `_maybe_to_symbolics` fallback changed to generic dispatch to avoid method overwriting
- Double slash in sounds URL path
- CE canonicalization overwriting raw MathJSON bound value: `_suppressEmit` guard prevents async events from `mf.expression` setter

## [0.1.0] - 2026-02-21

### Added

- Initial release
- WYSIWYG math input widget using MathLive web component
- `@bind` compatibility via AbstractPlutoDingetjes
- MathJSON, LaTeX, and Symbolics output formats
- Read-only mode (`disabled=true`)
- Custom CSS styling
- Fallback `<textarea>` when CDN is unavailable
- Symbolics.jl extension for symbolic expression conversion
- Example Pluto notebook
