local M = {}
M.ayu = function ()
  vim.o.termguicolors = true
  local colors = require("ayu.colors")
  require("ayu").setup({
    mirage = true,
    overrides = {
      Wildmenu = { bg = colors.bg , fg = colors.markup },
      Comment = { fg = 'gray', italic = true, },
      LineNr = { fg = 'gray' }
    }
  })
  require("ayu").colorscheme()
end
M.transparent_override = function ()
  local highlights = {
    "Normal",
    "LineNr",
    "Folded",
    "NonText",
    "SpecialKey",
    "VertSplit",
    "SignColumn",
    "EndOfBuffer",
  }
  for _, highlight in pairs(highlights) do
    vim.cmd.highlight(highlight .. ' guibg=none ctermbg=none')
  end
end
return M
