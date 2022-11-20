local utils = require("heirline.utils")
local conditions = require("heirline.conditions")
local function setup_colors()
  local get_hl = utils.get_highlight
  return {
    panel_border = get_hl("CursorLineNr").fg,
    string = get_hl("String").fg,
    bright_bg = get_hl("StatusLine").bg,
    bright_fg = get_hl("StatusLineNC").fg,
    normal = get_hl("Normal").fg,
    func = get_hl("Function").fg,
    comment = get_hl("NonText").fg,
    constant = get_hl("Constant").fg,
    statement = get_hl("Statement").fg,
    special = get_hl("Special").fg,
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

local c = require("pynappo/plugins/heirline/components/base")
local align = { provider = "%=" }
local space = { provider = " " }
c.vimode = utils.surround({ "", "" }, "bright_bg", { c.vimode })
local default_status = {
  c.vi_mode, space, c.gitsigns, space, c.diagnostics, align,
  c.file_info, align,
  c.dap, c.lsp, space, c.ruler, space, c.scrollbar
}
local terminal_status = {
  condition = function() return conditions.buffer_matches({ buftype = { "terminal" } }) end,
  { condition = conditions.is_active, c.vi_mode, space }, c.file_icon, space, c.termname, align,
}
local special_status = {
  condition = function()
    return conditions.buffer_matches({
      buftype = { "nofile", "prompt", "help", "quickfix" },
      filetype = { "^git.*", "fugitive" },
    })
  end,

  c.filetype, space, c.help_filename, align
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

  special_status, terminal_status, default_status,
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
    init = function() vim.opt_local.winbar = nil end
  },
  { c.navic, align, c.file_info }
}

local t = require('pynappo/plugins/heirline/components/tabline')
local bufferline = utils.make_buflist(
  t.tabline_buffer_block,
  { provider = "", hl = { fg = "gray" } },
  { provider = "", hl = { fg = "gray" } }
)
local tabpages = {
  condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
  { provider = "%=" },
  utils.make_tablist({
    provider = function(self) return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T" end,
    hl = function(self) return self.is_active and "TabLineSel" or "TabLine" end,
  }),
  {
    provider = "%999X  %X",
    hl = "TabLine",
  },
}
local TabLines = { bufferline, tabpages }

require("heirline").setup(StatusLines, WinBars, TabLines)

