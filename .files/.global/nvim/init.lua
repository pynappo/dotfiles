local modules = { "impatient", "pynappo/plugins", "pynappo/keymaps", "pynappo/autocmd", "pynappo/theme", "pynappo/commands" }

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
  end
end

local opt = vim.opt
local o = vim.o
local wo = vim.wo
local g = vim.g

-- Status/windowline
if vim.g.started_by_firenvim then
  opt.laststatus = 0
  opt.showtabline = 0
  wo.winbar = ""
  wo.signcolumn = "no"
else
  opt.laststatus = 3
  wo.winbar = require("nvim-navic").get_location()
  opt.scrolloff = 8
  wo.signcolumn = "yes"
end
opt.cmdheight = 0

-- Make line numbers default
opt.relativenumber = true
opt.number = true

-- Enable mouse mode
opt.mouse = "a"

-- Tabs
opt.tabstop = 2
opt.shiftwidth = 0
opt.softtabstop = -1
opt.expandtab = true
opt.cursorline = true
opt.wrap = true

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
  eob = " "
}
g.do_filetype_lua = 1
g.guifont = "Inconsolata LGC"
o.clipboard = "unnamedplus"
opt.completeopt = { "menuone", "noselect" }
g.neo_tree_remove_legacy_commands = 1

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
