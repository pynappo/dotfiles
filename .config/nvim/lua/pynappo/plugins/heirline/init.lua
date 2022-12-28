local utils = require("heirline.utils")
local get_hl = utils.get_highlight
local conditions = require("heirline.conditions")
local function setup_colors()
  print(vim.g.colors_name)
  return {
    panel_border = get_hl("CursorLineNr").fg,
    string = get_hl("String").fg,
    bright_bg = get_hl("StatusLine").bg,
    bright_fg = get_hl("StatusLineNC").fg,
    normal = get_hl("Normal").fg,
    func = get_hl("Function").fg,
    type = get_hl("Type").fg,
    debug = get_hl("Debug").fg,
    comment = get_hl("NonText").fg,
    directory = get_hl("Directory").fg,
    constant = get_hl("Constant").fg,
    statement = get_hl("Statement").fg,
    special = get_hl("Special").fg,
    diag_warn = get_hl("DiagnosticWarn").fg,
    diag_error = get_hl("DiagnosticError").fg,
    diag_hint = get_hl("DiagnosticHint").fg,
    diag_info = get_hl("DiagnosticInfo").fg,
    git_del = get_hl("DiffRemoved").fg,
    git_add = get_hl("DiffAdded").fg,
    git_change = get_hl("GitsignsChange").fg,
  }
end

-- These are default colors that builtin colorschemes should already have
local default_colors = {
  panel_border = get_hl("CursorLineNr").fg,
  string = get_hl("String").fg,
  bright_bg = get_hl("StatusLine").bg,
  bright_fg = get_hl("StatusLineNC").fg,
  normal = get_hl("Normal").fg,
  func = get_hl("Function").fg,
  type = get_hl("Type").fg,
  debug = get_hl("Debug").fg,
  comment = get_hl("NonText").fg,
  directory = get_hl("Directory").fg,
  constant = get_hl("Constant").fg,
  statement = get_hl("Statement").fg,
  special = get_hl("Special").fg,
  diag_warn = get_hl("DiagnosticWarn").fg,
  diag_error = get_hl("DiagnosticError").fg,
  diag_hint = get_hl("DiagnosticHint").fg,
  diag_info = get_hl("DiagnosticInfo").fg,
  git_del = get_hl("DiffDelete").bg,
  git_add = get_hl("DiffAdd").bg,
  git_change = get_hl("DiffChange").bg,
}
require('heirline').load_colors(default_colors)

vim.api.nvim_create_augroup("Heirline", { clear = true })
-- We're gonna assume that the user is applying a colorscheme with gitsigns support
vim.api.nvim_create_autocmd("ColorScheme", { callback = function()
  local plugin_support, new_colors = pcall(setup_colors)
  utils.on_colorscheme(plugin_support and new_colors or default_colors)
end, group = "Heirline", })

vim.api.nvim_create_autocmd("User", {
  pattern = 'HeirlineInitWinbar',
  callback = function(args)
    local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[args.buf].buftype)
    local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[args.buf].filetype)

    if buftype or filetype then vim.wo.winbar = nil end
  end,
})

local mode_colors = {
  n = "type",
  i = "string",
  v = "func",
  V = "func",
  ["\22"] = "",
  c = "debug",
  s = "constant",
  S = "constant",
  ["\19"] = "constant",
  R = "diag_error",
  r = "diag_error",
  ["!"] = "diag_error",
  t = "normal",
}
local get_mode_color = function(self)
  local mode = conditions.is_active() and vim.fn.mode() or "n"
  return self.mode_colors[mode]
end

local c = require("pynappo/plugins/heirline/components/base")
local align = { provider = "%=" }
local space = { provider = " " }
c.vi_mode = utils.surround({ "", " " }, function(self) return self:get_mode_color() end, { c.vi_mode, hl = {fg = 'black'} })
c.lsp = { {provider = 'LSP: ', hl = {fg = 'string'}}, utils.surround({ "", "" }, 'string', { c.lsp, hl = { fg = "black" } }) }
c.ruler = utils.surround({ " ", "" }, function(self) return self:get_mode_color() end, { c.ruler, hl = { fg = "black" } })

local StatusLine = {
  hl = function() return not conditions.buffer_matches({ buftype = { "terminal" } }) and "StatusLine" end,
  static = {
    mode_colors = mode_colors,
    get_mode_color = get_mode_color,
  },
  { c.vi_mode },
  align,
  {
    fallthrough = false,
    {
      condition = function()
        return conditions.buffer_matches({
          buftype = { "nofile", "prompt", "help", "quickfix" },
          filetype = { "^git.*", "fugitive" },
        })
      end,
      c.cwd, c.filetype, space, c.help_filename
    },
    {
      condition = function() return conditions.buffer_matches({ buftype = { "terminal" } }) end,
      c.file_icon, space, c.termname
    },
    {c.cwd, c.file_info}
  },
  align,
  { c.dap, c.lsp, space, c.ruler }
}
local WinBars = {
  hl = "Tabline",
  fallthrough = false,
  {
    condition = function()
      return conditions.buffer_matches({
        buftype = { "nofile", "prompt", "quickfix" },
        filetype = { "^git.*", "fugitive" },
      })
    end,
    init = function() vim.opt_local.winbar = nil end
  },
  {
    condition = function() return conditions.buffer_matches({ buftype = { "terminal" } }) end,
    align, c.file_icon, space, c.termname
  },
  { c.navic, align, c.diagnostics, c.gitsigns, space, c.file_info }
}

local t = require('pynappo/plugins/heirline/components/tabline')
local TabLines = { t.tabline_offset, t.bufferline, align, t.tabpages }

require("heirline").setup(StatusLine, WinBars, TabLines)

