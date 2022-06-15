local modules = { 'impatient', 'pynappo/plugins', 'pynappo/keymaps', 'pynappo/autocmd', 'pynappo/theme', 'pynappo/commands' }

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
o.laststatus = 3
wo.winbar = '%f'
o.cmdheight = 0

-- Make line numbers default
wo.relativenumber = true
wo.number = true
wo.signcolumn = 'yes'

-- Enable mouse mode
o.mouse = 'a'

-- Tabs
opt.tabstop = 2
opt.shiftwidth = 0
opt.softtabstop = -1
opt.expandtab = true

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.cursorline = true
o.wrap = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- More intuitive splits
o.splitright = true
o.splitbelow = true

-- Misc
o.history = 50
opt.whichwrap:append('<,>,h,l,[,]')
opt.fillchars:append("eob: ")
g.do_filetype_lua = 1
o.clipboard = 'unnamedplus'

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
