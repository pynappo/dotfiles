vim.o.termguicolors = true
require('ayu').setup({
  mirage = true,
  overrides = {
    Comment = { fg = 'gray', italic = true, bg = "none" },
    Normal = { bg = 'none' },
    NonText = { fg = 'gray', bg = 'none' },
    SpecialKey = { bg = 'none' },
    VertSplit = { bg = 'none' },
    SignColumn = { bg = 'none' },
    EndOfBuffer = { fg = 'gray', bg = 'none' },
    Folded = { bg = 'none' },
  }
})
require('ayu').colorscheme()
