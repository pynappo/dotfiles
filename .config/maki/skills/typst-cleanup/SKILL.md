---
name: typst-cleanup
description: Clean up existing Typst files — currently converts plain a/b/c/d lettered lists into an enum block numbered a, b, c.
---

# Cleaning up Typst files

Use this when asked to tidy or normalize already-written `.typ` files. Apply
only the fixes below, one at a time; do not rewrite anything else.

## Lettered lists -> `enum` with `numbering: "a."`

Pandoc and hand-written files often spell a lettered list as plain lines
`a. ... / b. ...`, or as bullet items prefixed `A/B/C/D` or `a/b/c`. Replace
that with an `enum` block that numbers items a, b, c:

Before:

```typst
a. First point.
b. Second point.
c. Third point.
```

After:

```typst
#{
  set enum(numbering: "a.")
  [
    + First point.
    + Second point.
    + Third point.
  ]
}
```

Rules:

- One space of indent per level; the `+` items sit two spaces deeper than
  `set enum`.
- Keep each item's text exactly as written, minus the leading marker.
- Preserve surrounding blank lines so the block stays a top-level element.
- If the source used uppercase markers (`A.`, `B.`) or slash style
  (`a/b/c`), still emit the lowercase `numbering: "a."` form above.
- If an item's body wraps onto following indented lines, keep that body
  with its item.
- Leave real Markdown bullet lists (`-`), Typst `enum` blocks already
  using `numbering: "a."`, and numbered `1.` lists alone unless asked.
