require("nvim-autopairs").setup({
  enable_check_bracket_line = false,
  check_ts = true,
  ignored_next_char = "[%w%.]",
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", "\"", "'" },
    pattern = [=[[%"%"%)%>%]%)%}%,]]=],
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey = "Comment"
  },
})
