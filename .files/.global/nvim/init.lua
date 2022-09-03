local modules = {
  "impatient",
  "pynappo/theme",
  "pynappo/plugins",
  "pynappo/keymaps",
  "pynappo/autocmd",
  "pynappo/commands"
}

for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
  end
end

local o = vim.opt
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
o.signcolumn = "auto:9"
o.cmdheight = 0
g.gutentags_enabled = 1
-- Make line numbers default
o.relativenumber = true
o.number = true

-- Enable mouse mode
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
o.whichwrap:append("<,>,h,l,[,]")
o.fillchars = {
  horiz     = '━',
  horizup   = '┻',
  horizdown = '┳',
  vert      = '┃',
  vertleft  = '┫',
  vertright = '┣',
  verthoriz = '╋',
  eob       = " "
}
g.do_filetype_lua = 1
o.guifont = "InconsolataLGC_NF"
o.clipboard = "unnamedplus"
o.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·'
}
o.cursorline = true
o.wrap = true

-- Spell checking
o.spelllang = 'en,cjk'

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
