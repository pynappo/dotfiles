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
require('heirline').load_colors(setup_colors())

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function() utils.on_colorscheme(setup_colors()) end,
  group = "Heirline",
})

vim.api.nvim_create_autocmd("User", {
  pattern = 'HeirlineInitWinbar',
  callback = function(args)
    local buf = args.buf
    local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
    local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
    if buftype or filetype then vim.opt_local.winbar = nil end
  end,
})

local c = require("pynappo/plugins/heirline/components/base")
local align = { provider = "%=" }
local space = { provider = " " }
c.vi_mode = utils.surround({ "", "" }, "bright_bg", { c.vi_mode })

local status = {
  { c.vi_mode, space, c.gitsigns, space, c.diagnostics, },
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
  { c.dap, c.lsp, space, c.ruler, space, c.scrollbar }
}
local StatusLines = { status, }

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
  { c.navic, align, c.file_info }
}

local t = require('pynappo/plugins/heirline/components/tabline')
local tabline_offset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == "neo-tree" then
      self.title = "Neo-Tree"
      return true
    end
  end,
  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)
    return string.rep(" ", pad) .. title .. string.rep(" ", pad)
  end,
  hl = function(self) return vim.api.nvim_get_current_win() == self.winid and "TablineSel" or "Tabline" end,
}
local bufferline = utils.make_buflist(
  t.tabline_buffer_block,
  { provider = "", hl = { fg = "gray" } },
  { provider = "", hl = { fg = "gray" } }
)
local tabpages = {
  condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
  utils.make_tablist({
    provider = function(self) return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T" end,
    hl = function(self) return self.is_active and "TabLineSel" or "TabLine" end,
  }),
  {
    provider = "%999X  %X",
    hl = "TabLine",
  },
}
local TabLines = { tabline_offset, bufferline, align, tabpages }

require("heirline").setup(StatusLines, WinBars, TabLines)

