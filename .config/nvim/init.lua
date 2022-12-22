local o = vim.o
local opt = vim.opt
local g = vim.g
g.firenvim_config = {
  globalSettings = {
    alt = 'all',
  },
  localSettings = {
    ['.*'] = {
      cmdline = 'neovim',
      content = 'md',
      priority = 0,
      selector = 'textarea',
      takeover = 'never',
    },
  }
}
if vim.fn.has('win32') then
  o.shell = vim.fn.executable('pwsh') and 'pwsh' or 'powershell'
  o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  o.shellquote = ''
  o.shellxquote = ''
end
if g.started_by_firenvim then
  o.laststatus = 0
  o.cmdheight = 0
  o.showtabline = 0
else
  o.cmdheight = 1
  o.showtabline = 2
  o.laststatus = 3
end
if g.neovide then
  g.neovide_transparency = 0.8
  g.neovide_refresh_rate = 144
  g.neovide_cursor_vfx_mode = 'ripple'
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_trail_size = 0.9
  g.neovide_remember_window_size = true
end
-- Line numbers
o.undofile = true
o.signcolumn = "auto:2"
o.relativenumber = true
o.number = true

-- Enable mouse
o.mouse = "a"
o.mousescroll = "ver:4,hor:6"

-- Tabs
o.tabstop = 2
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- More intuitive splits
o.splitright = true
o.splitbelow = true

-- Line breaks
o.linebreak = true
o.breakindent = true
o.wrap = true

-- Misc
o.pumblend = 20
o.updatetime = 300
o.termguicolors = true
g.gutentags_enabled = 1
o.history = 1000
o.scrolloff = 4
opt.whichwrap:append("<,>,h,l,[,]")
opt.fillchars = {
  horiz     = '━',
  horizup   = '┻',
  horizdown = '┳',
  vert      = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
  eob       = ' ',
  fold      = ' ',
  diff      = '╱'
}
o.guifont = "InconsolataLGC_NF:h8:#e-subpixelantialias"
o.list = true
opt.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  tab = '» ',
  nbsp = '␣',
}
o.cursorline = true
o.formatoptions = "jcrql"

local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "matchparen"
}
for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end
require("pynappo/keymaps").setup.regular()
require("pynappo/autocmds")
vim.fn.sign_define("DiagnosticSignError", {text = "", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = "", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = "", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})
local theme = require("pynappo/theme")
require("pynappo/plugins")
local hl_list = {}
vim.cmd.colorscheme('ayu')
for i, color in pairs({ '#782121', '#6a6a21', '#216631', '#325f5f', '#324b7b', '#563155' }) do
  local name = 'IndentBlanklineIndent' .. i
  vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
  table.insert(hl_list, name);
end
vim.cmd.highlight('IndentBlanklineContextChar guifg=#888888 gui=bold,nocombine')
require('indent_blankline').setup {
  filetype_exclude = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
  show_trailing_blankline_indent = false,
  space_char_blankline = ' ',
  char_highlight_list = hl_list,
  use_treesitter = true,
  use_treesitter_scope = true,
  show_current_context = true
}
require("pynappo/commands")
