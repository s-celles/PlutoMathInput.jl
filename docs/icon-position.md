# Icon Position

By default, the MathLive menu and virtual keyboard toggle icons appear
on the **right** side of the `MathInput` field. You can move them to
the **left** side using the `icon_position` keyword argument.

## Usage

```julia
# Icons on the left
@bind formula MathInput(icon_position=:left)

# Icons on the right (default)
@bind formula MathInput(icon_position=:right)

# Default behavior (icons on the right)
@bind formula MathInput()
```

## Combining with Other Options

```julia
@bind formula MathInput(
    icon_position=:left,
    latex="\\frac{x}{2}",
    macros=Dict("\\R" => "\\mathbb{R}"),
)
```

## How It Works

When `icon_position=:left`, a CSS rule is injected that uses the
`::part(content)` selector to reorder the MathLive flex layout via
`order: 1`, moving the icons (menu and virtual keyboard toggle) to
the left side of the field. All icon functionality remains identical
regardless of position.

## Valid Values

| Value | Description |
|-------|-------------|
| `:right` | Icons on the right side (default) |
| `:left` | Icons on the left side |

An `ArgumentError` is raised if any other value is provided.
