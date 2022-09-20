require("impatient").enable_profile()
local opt = vim.opt
local g = vim.g

-- Firenvim
if vim.g.started_by_firenvim then
  opt.laststatus = 0
  opt.showtabline = 0
  opt.winbar = ""
else
  opt.laststatus = 3
  opt.scrolloff = 4
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
opt.signcolumn = "auto:9"
opt.cmdheight = 0
g.gutentags_enabled = 1
-- Line numbers
opt.relativenumber = true
opt.number = true

-- Enable mouse
opt.mouse = "a"

-- Tabs
opt.tabstop = 2
opt.shiftwidth = 0
opt.softtabstop = -1
opt.expandtab = true

-- Case insensitive searching UNLESS /C or capital in search
opt.ignorecase = true
opt.smartcase = true

-- More intuitive splits
opt.splitright = true
opt.splitbelow = true

-- Misc
opt.history = 50
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
opt.guifont = "InconsolataLGC_NF"
opt.list = true
opt.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  tab = '» ',
  nbsp = '␣',
}
opt.cursorline = true
opt.wrap = true

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
require("pynappo/keymaps").setup()
require("pynappo/autocmds")
require("pynappo/commands")


