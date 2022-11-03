require("impatient")

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
  g.neovide_refresh_rate = 165
  g.neovide_cursor_vfx_mode = 'ripple'
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_trail_size = 0.9
  g.neovide_remember_window_size = true
end
-- Line numbers
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

-- Misc
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
o.wrap = false
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
  "matchit"
}
for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end
require("pynappo/plugins")
local theme = require("pynappo/theme")
theme.ayu()
if not g.neovide then theme.transparent_override() end
theme.link_highlights()
require("pynappo/commands")
require("pynappo/keymaps").init()
require("pynappo/autocmds")

