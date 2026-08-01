;; extends

(call
  item: (ident) @outer_name (#eq? @outer_name "svelte")
  (content
    (code
      (call
        item: (ident) @inner_name (#eq? @inner_name "strfmt")
        (group
          (string) @injection.content (#set! injection.language "svelte")
        )
      )
    )
  )
)

