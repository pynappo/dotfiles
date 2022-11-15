local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local function setup_colors()
  local get_hl = utils.get_highlight
  return {
    bright_bg = get_hl("StatusLine").bg,
    bright_fg = get_hl("StatusLineNC").fg,
    normal = get_hl("Normal").fg,
    red = get_hl("DiagnosticError").fg,
    dark_red = get_hl("DiffDelete").bg,
    green = get_hl("String").fg,
    blue = get_hl("Function").fg,
    gray = get_hl("NonText").fg,
    orange = get_hl("Constant").fg,
    purple = get_hl("Statement").fg,
    cyan = get_hl("Special").fg,
    diag_warn = get_hl("DiagnosticWarn").fg,
    diag_error = get_hl("DiagnosticError").fg,
    diag_hint = get_hl("DiagnosticHint").fg,
    diag_info = get_hl("DiagnosticInfo").fg,
    git_del = get_hl("DiffDelete").fg,
    git_add = get_hl("DiffAdded").fg,
    git_change = get_hl("DiffChange").fg,
  }
end
require('heirline').load_colors(setup_colors())

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local colors = setup_colors()
    utils.on_colorscheme(colors)
  end,
  group = "Heirline",
})


vim.api.nvim_create_autocmd("User", {
  pattern = 'HeirlineInitWinbar',
  callback = function(args)
    local buf = args.buf
    local buftype = vim.tbl_contains(
      { "prompt", "nofile", "help", "quickfix" },
      vim.bo[buf].buftype
    )
    local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
    if buftype or filetype then
      vim.opt_local.winbar = nil
    end
  end,
})

local c = require("pynappo.plugins.heirline.components")
local align = { provider = "%=" }
local space = { provider = " " }
c.vimode = utils.surround({ "", "" }, "bright_bg", { c.vimode })
local DefaultStatusline = {
  c.vimode, space, c.gitsigns, space, c.diagnostics, align,
  c.fileinfo, align,
  c.dap, c.lsps, space, c.ruler, space, c.scrollbar
}
local TerminalStatusline = {

  condition = function()
    return conditions.buffer_matches({ buftype = { "terminal" } })
  end,

  hl = { bg = "dark_red" },

  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, c.vimode, space }, c.fileicon, space, c.termname, align,
}
local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,

  c.filetype, space, c.helpfilename, align
}

local StatusLines = {

  hl = function()
    if conditions.is_active() then return "StatusLine"
    else return "StatusLineNC"
    end
  end,

  -- the first statusline with no condition, or which condition returns true is used.
  -- think of it as a switch case with breaks to stop fallthrough.
  fallthrough = false,

  SpecialStatusline, TerminalStatusline, DefaultStatusline,
}
local WinBars = {
  fallthrough = false,
  {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      })
    end,
    init = function()
      vim.opt_local.winbar = nil
    end
  },
  { c.navic, align, c.fileinfo }
}
require("heirline").setup(StatusLines, WinBars)

