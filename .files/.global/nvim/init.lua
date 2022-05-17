local modules = { 'plugins', 'keymaps', 'autocmd', 'theme' }

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
  end
end


local opt = vim.opt
local o = vim.o
local wo = vim.wo

o.laststatus = 3
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

-- Misc
opt.list = true
o.updatetime = 200
opt.whichwrap:append "<>[]hl"
opt.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·'
}
opt.list = true
o.completeopt = 'menuone,noselect'
o.breakindent = true
opt.undofile = true
o.ignorecase = true
o.smartcase = true
o.backup = false
o.writebackup = false
o.swapfile = false

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.cursorline = true
o.wrap = true
o.clipboard = 'unnamedplus'

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

o.history = 50

o.splitright = true
o.splitbelow = true

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
  "spellfile_plugin",
  "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end
