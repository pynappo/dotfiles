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
o.tabstop = 2
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- More intuitive splits
o.splitright = true
o.splitbelow = false

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
      { import = 'pynappo.plugins.testing', enabled = not require('pynappo.utils').is_termux },
    },
  },
  git = {
    log = { '--since=3 days ago' }, -- show commits from the last 3 days
    timeout = 90,                   -- seconds
  },
  dev = {
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
  },
  diff = { cmd = 'diffview.nvim' },
  checker = {
    enabled = true,
    notify = true,
    frequency = 60 * 60 * 24, -- once a day
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
vim.cmd.colorscheme('ayu')

local normalize_system_command = function(cmd)
  return utils.is_windows and vim.list_extend({ 'pwsh', '-NoProfile', '-c' }, cmd) or cmd
end
local print_system_command = function(cmd)
  local result = vim.system(normalize_system_command(cmd), { cwd = vim.fn.getcwd(), text = true }):wait()
  print(result.stdout:gsub('%%', [[\]]))
end
local commands = {
  { "CDhere", "cd %:p:h" },
  {
    "DotfilesGit",
    function()
      vim.env.GIT_WORK_TREE = vim.fn.expand("~")
      vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles.git/")
    end,
  },
  {
    'SwapFiles',
    function(args)
      local command_map = { list = 'ls', remove = 'rm' }
      if utils.truthy(args.args) and not command_map[args.args] then
        vim.notify('SwapFiles: not a valid argument', vim.log.levels.ERROR)
        return
      end
      local command = command_map[args.args] or command_map.list
      local modifiers = (args.bang and args.args == 'remove') and (utils.is_windows and '-Force' or '-f') or nil
      print_system_command({ command, vim.fn.stdpath('data') .. '/swap/*', modifiers })
    end,
    {
      nargs = '?',
      bang = true,
      complete = function()
        return {
          'list',
          'remove'
        }
      end
    }
  },
  {
    'Config',
    function(args)
      local new_tab = utils.truthy(args.args) and args.args == 'tab'
      if new_tab then vim.cmd.tabnew() end
      vim.cmd.tcd('~/.config/nvim')
      require('tabnames').set_tab_name(0, 'Config')
      if new_tab then vim.cmd('Alpha') end
    end
  },
  {
    'Messages',
    function()
      local scratch_buffer = vim.api.nvim_create_buf(false, true)
      vim.bo[scratch_buffer].filetype = 'vim'
      local messages = vim.split(vim.fn.execute('messages', "silent"), '\n')
      vim.api.nvim_buf_set_text(scratch_buffer, 0, 0, 0, 0, messages)
      vim.cmd('vertical sbuffer ' .. scratch_buffer)
    end,
  },
}
for _, cmd in ipairs(commands) do
  vim.api.nvim_create_user_command(
    cmd[1],
    type(cmd[2]) == 'table' and function() print_system_command(cmd[2]) end or cmd[2],
    cmd[3] or {}
  )
end
-- GUI stuff
o.guifont = "InconsolataLGC_NF:h8:#e-subpixelantialias"
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

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])
