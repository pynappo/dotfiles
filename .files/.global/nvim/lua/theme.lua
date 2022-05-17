vim.o.termguicolors = true
require('ayu').setup({
  mirage = true,
  overrides = {
    Comment = { fg = '#666666', italic = true, bg = "none" },
    Normal = { bg = 'none' },
    NonText = { bg = 'none' },
    SpecialKey = { bg = 'none' },
    VertSplit = { bg = 'none' },
    SignColumn = { bg = 'none' },
    EndOfBuffer = { bg = 'none' },
    Folded = { bg = 'none' },
  }
})
require('ayu').colorscheme()
