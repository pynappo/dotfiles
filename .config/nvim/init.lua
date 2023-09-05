_G.pynappo = {}
local o = vim.o
local g = vim.g
local opt = vim.opt
local utils = require('pynappo.utils')
if utils.is_windows then
  o.shell = vim.fn.executable('pwsh') and 'pwsh' or 'powershell'
  o.shellcmdflag =
  '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
  o.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
  o.shellpipe = [[2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode]]
  o.shellquote = ''
  o.shellxquote = ''
end

o.cmdheight = 1
o.showtabline = 2
o.laststatus = 3

-- Line numbers
o.signcolumn = "auto:2"
o.relativenumber = true
o.number = true

-- Enable mouse
o.mouse = "a"
o.mousescroll = "ver:8,hor:6"
o.mousemoveevent = true

-- Tabs
o.vartabstop = '2'
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
opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }

-- Misc.
o.confirm = true
o.showmode = false
o.history = 1000
o.scrolloff = 4
o.undofile = true
opt.sessionoptions = {
  'buffers', 'curdir', 'folds', 'help', 'tabpages', 'winsize', 'globals', 'terminal', 'options'
}
opt.wildoptions:append('fuzzy')
opt.diffopt = {
  'internal', 'filler', 'vertical', 'linematch:60'
}

-- UI stuff
o.cursorline = true
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
o.list = true
opt.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  tab = '» ',
  nbsp = '␣',
}
vim.api.nvim_create_autocmd('FileType', { callback = function() vim.opt_local.formatoptions:remove({ 'o' }) end })
local signs = {
  DiagnosticSignError = { text = "", texthl = "DiagnosticSignError" },
  DiagnosticSignWarn = { text = "", texthl = "DiagnosticSignWarn" },
  DiagnosticSignInfo = { text = "", texthl = "DiagnosticSignInfo" },
  DiagnosticSignHint = { text = "󰌵", texthl = "DiagnosticSignHint" }
}
for name, sign in pairs(signs) do vim.fn.sign_define(name, sign) end
o.termguicolors = true

g.mapleader = ' '
g.maplocalleader = '\\'

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { only_current_line = true },
  signs = true,
  float = {
    border = "single",
    format = function(d) return ("%s (%s) [%s]"):format(d.message, d.source, d.code or d.user_data.lsp.code) end,
  },
})

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

require("pynappo.autocmds")
require('lazy').setup({
  spec = {
    {
      { import = 'pynappo.plugins' },
      { import = 'pynappo.plugins.testing', enabled = true },
    },
  },
  git = {
    log = { '--since=3 days ago' }, -- show commits from the last 3 days
    timeout = 90,                   -- seconds
  },
  dev = {
    fallback = true,
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { "pynappo" }, -- For example {"folke"}
  },
  install = {
    missing = true,
    colorscheme = { 'ayu' },
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = 'single',
    custom_keys = {
      -- you can define custom key maps here.
      -- To disable one of the defaults, set it to false

      -- open lazygit log
      ["<localleader>l"] = function(plugin)
        require("lazy.util").float_term({ "lazygit", "log" }, {
          cwd = plugin.dir,
        })
      end,

      -- open a terminal for the plugin dir
      ["<localleader>t"] = function(plugin)
        require("lazy.util").float_term(nil, {
          cwd = plugin.dir,
        })
      end,
    },
  },
  diff = { cmd = 'diffview.nvim' },
  checker = {
    enabled = true,
    notify = true,
    frequency = 24 * 60 * 60,
  },
  change_detection = {
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  performance = {
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {},   -- add any custom paths here that you want to incluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        "matchit",
        "matchparen",
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
      },
    },
  },
  readme = {
    root = vim.fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md' },
    skip_if_doc_exists = true,
  },
})

require("pynappo.keymaps").setup.regular()
require("pynappo.theme")
require("pynappo.commands")
vim.cmd.colorscheme('ayu')

vim.filetype.add({
  pattern = {
    [(vim.env.XDG_CONFIG_HOME or ".-") .. "/waybar/config"] = 'json',
  },
  extension = {
    rasi = 'rasi'
  }
})
-- GUI stuff
o.guifont = "Inconsolata Nerd Font Mono:h12:#e-subpixelantialias"
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
  o.pumheight = 10
elseif g.neovide then
  g.neovide_transparency = 0.8
  g.neovide_refresh_rate = 144
  g.neovide_cursor_vfx_mode = 'ripple'
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_trail_size = 0.9
  g.neovide_remember_window_size = true
end

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])
