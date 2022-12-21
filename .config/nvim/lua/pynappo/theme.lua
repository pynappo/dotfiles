local M = {}
vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})
local links = { }
for source, destination in pairs(links) do vim.api.nvim_set_hl(0, source, {link = destination}) end
function M.ayu()
  local colors = require("ayu.colors")
  require("ayu").setup({
    mirage = true,
    overrides = {
      Wildmenu = { bg = colors.bg , fg = colors.markup },
      Comment = { fg = 'gray', italic = true, },
      LineNr = { fg = 'gray' }
    }
  })
  vim.g.ayucolor = "mirage"
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
    "TablineFill"
  }
  for _, name in pairs(highlights) do vim.cmd.highlight(name .. ' guibg=none ctermbg=none') end
end
return M
