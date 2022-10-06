require("impatient").enable_profile()
local o = vim.o
local opt = vim.opt
local g = vim.g

-- Firenvim
if vim.g.started_by_firenvim then
  o.laststatus = 0
  o.showtabline = 0
  o.winbar = ""
else
  o.laststatus = 3
  o.scrolloff = 4
end
vim.g.firenvim_config = {
  globalSettings = {
    alt = 'all'
  },
  localSettings = {
    ['.*'] = {
      cmdline = 'neovim',
      takeover = 'never',
      priority = 0
    }
  }
}
-- Line numbers
o.signcolumn = "auto:2"
o.cmdheight = 0
g.gutentags_enabled = 1
o.relativenumber = true
o.number = true

-- Enable mouse
o.mouse = "a"

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
o.history = 50
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
}
o.guifont = "InconsolataLGC_NF"
o.list = true
opt.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  tab = '» ',
  nbsp = '␣',
}
o.cursorline = true
o.wrap = true

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
for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
local theme = require("pynappo/theme")
theme.ayu()
theme.transparent_override()
require("pynappo/plugins")
require("pynappo/keymaps").init()
require("pynappo/autocmds")
require("pynappo/commands")
