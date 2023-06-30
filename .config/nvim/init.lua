_G.pynappo = {}
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
o.completeopt = 'menu,menuone,noinsert,noselect'

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = {only_current_line = true},
  signs = true,
  float = {
    border = "single",
    format = function(diagnostic)
      return string.format(
        "%s (%s) [%s]",
        diagnostic.message,
        diagnostic.source,
        diagnostic.code or diagnostic.user_data.lsp.code
      )
    end,
  },
})

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
opt.formatoptions = {
  c = true,
  j = true,
  l = true,
  o = false,
  q = true,
  r = true,
}

local signs = {
  DiagnosticSignError = {text = "", texthl = "DiagnosticSignError"},
  DiagnosticSignWarn = {text = "", texthl = "DiagnosticSignWarn"},
  DiagnosticSignInfo = {text = "", texthl = "DiagnosticSignInfo"},
  DiagnosticSignHint = {text = "󰌵", texthl = "DiagnosticSignHint"}
}
for name, sign in pairs(signs) do vim.fn.sign_define(name, sign) end
o.termguicolors = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- plugins
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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

local lazy_opts = {
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { '--since=3 days ago' }, -- show commits from the last 3 days
    timeout = 90, -- seconds
    url_format = 'https://github.com/%s.git',
  },
  dev = {
    -- directory where you store your local plugin projects
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { 'habamax' },
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = 'none',
    icons = {
      loaded = '●',
      not_loaded = '○',
      cmd = ' ',
      config = '',
      event = '',
      ft = ' ',
      init = ' ',
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = '',
      task = '✔ ',
      lazy = '󰒲 ',
      list = {
        '●',
        '➜',
        '★',
        '‒',
      },
    },
  },
  diff = { cmd = 'diffview.nvim' },
  checker = {
    -- automatically check for plugin updates
    enabled = false,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    notify = true, -- get a notification when new updates are found
    frequency = 3600, -- check for updates every hour
  },
  change_detection = {
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath('cache') .. '/lazy/cache',
      disable_events = { 'VimEnter', 'BufReadPre' },
      ttl = 3600 * 24 * 5, -- keep unused modules for up to 5 days
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to incluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        "matchit",
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
        -- "2html_plugin",
        "logipat",
        "rrhelper",
        "matchparen"
      },
    },
  },
  readme = {
    root = vim.fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md' },
    -- only generate markdown helptags for plugins that dont have docs
    skip_if_doc_exists = true,
  },
}
require('lazy').setup('pynappo.plugins', lazy_opts)
require("pynappo/keymaps").setup.regular()
require("pynappo/autocmds")
require("pynappo/theme").transparent_override()
vim.cmd.colorscheme('ayu')

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])

local normalize_system_command = function(cmd)
  return is_windows and vim.list_extend({'pwsh', '-NoProfile', '-c'}, cmd) or cmd
end
local print_system_command = function(cmd)
  local result = vim.system(normalize_system_command(cmd), {cwd = vim.fn.getcwd(), text = true}):wait()
  print(((result.stdout):gsub('%%', [[\]])))
end
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
    'SwapFiles',
    function(args)
      local command_map = { list = 'ls', remove = 'rm' }
      if utils.truthy(args.args) and not command_map[args.args] then
        vim.notify('SwapFiles: not a valid argument', vim.log.levels.ERROR)
        return
      end
      local command = command_map[args.args] or command_map.list
      local modifiers = (args.bang and args.args == 'remove') and (is_windows and '-Force' or '-f') or nil
      print_system_command({command, vim.fn.stdpath('data') .. '/swap/*', modifiers})
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
    function()
      vim.cmd.tabnew()
      vim.cmd.tcd('~/.config/nvim')
      require('tabnames').set_tab_name(0, 'Config')
      vim.cmd('Alpha')
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

vim.pretty_print(vim.tbl)
