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
function M.transparent_override()
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
    vim.cmd.highlight(highlight .. ' guibg=none ctermbg=none') --
  end
end
function M.link_highlights()
  local links = {
  }
  for source, destination in pairs(links) do
    vim.api.nvim_set_hl(0, source, {link = destination})
  end
end
return M
