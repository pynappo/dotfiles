local o = vim.o
local wo = vim.wo
local opt = vim.opt
if jit.os == "Windows" then
  o.shell = vim.fn.executable('pwsh') and 'pwsh' or 'powershell'
  o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  o.shellquote = ''
  o.shellxquote = ''
end

o.cmdheight = 1
o.showtabline = 2
o.laststatus = 3

-- Line numbers
wo.signcolumn = "auto:2"
o.relativenumber = true
o.number = true

-- Enable mouse
o.mouse = "a"
o.mousescroll = "ver:6,hor:6"

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

-- Pop up menu stuff
o.pumblend = 20
o.updatetime = 500

-- Misc.
o.showmode = false
o.history = 1000
o.scrolloff = 4
o.undofile = true
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
opt.formatoptions:remove('o')

local signs = {
  DiagnosticSignError = {text = "", texthl = "DiagnosticSignError"},
  DiagnosticSignWarn = {text = "", texthl = "DiagnosticSignWarn"},
  DiagnosticSignInfo = {text = "", texthl = "DiagnosticSignInfo"},
  DiagnosticSignHint = {text = "", texthl = "DiagnosticSignHint"}
}
for name, sign in pairs(signs) do vim.fn.sign_define(name, sign) end
o.termguicolors = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
require("pynappo/plugins")
require("pynappo/keymaps").setup.regular()
require("pynappo/autocmds")
require("pynappo/theme").transparent_override()
vim.cmd.colorscheme('ayu')

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
local commands = {
  {"CDhere", "cd %:p:h"},
  {
    "DotfilesGit",
    function()
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles.git/")
    end,
  },
  {
    'ClearSwapFiles',
    function()
      print(vim.fn.system('rm ' .. vim.fn.stdpath('data') .. '/swap/*' .. (jit.os == "Windows" and ' -Force' or ' -f')))
    end
  },
}
for _, cmd in ipairs(commands) do vim.api.nvim_create_user_command(cmd[1], cmd[2], cmd[3] or {}) end
if vim.fn.getcwd():find(vim.fn.expand("~/.config")) then vim.cmd('DotfilesGit') end
-- Gui stuff
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
  vim.cmd.startinsert()
  o.laststatus = 0
  o.cmdheight = 0
  o.showtabline = 0
elseif g.neovide then
  g.neovide_transparency = 0.8
  g.neovide_refresh_rate = 144
  g.neovide_cursor_vfx_mode = 'ripple'
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_trail_size = 0.9
  g.neovide_remember_window_size = true
end
