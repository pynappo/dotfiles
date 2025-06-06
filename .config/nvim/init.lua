_G.pynappo = {}

package.path = package.path .. ';' .. vim.env.HOME .. '/.luarocks/share/lua/5.1/?/init.lua;'
package.path = package.path .. ';' .. vim.env.HOME .. '/.luarocks/share/lua/5.1/?.lua;'

if vim.env.NVIM_PROFILE then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath('data') .. '/lazy/snacks.nvim'
  vim.opt.rtp:append(snacks)
  require('snacks.profiler').startup({
    -- globals = {
    --   'vim',
    --   'vim.api',
    --   'vim.uv',
    --   'vim.loop',
    -- },
    startup = {
      event = 'VimEnter', -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config')
local g = vim.g
local o = vim.opt
local utils = require('pynappo.utils')

if utils.is_windows then
  o.shell = vim.fn.executable('pwsh') and 'pwsh' or 'powershell'
  o.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();'
    .. '$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText;'
    .. [[$PSDefaultParameterValues['Out-File:Encoding']='utf8';Remove-Alias -Force -ErrorAction SilentlyContinue tee;]]
  o.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
  o.shellpipe = [[2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode]]
  o.shellquote = ''
  o.shellxquote = ''
end

o.cmdheight = 1
o.showtabline = 1
o.laststatus = 3

-- Line numbers
o.signcolumn = 'auto:2'
o.foldcolumn = 'auto:1'
o.relativenumber = true
o.number = true

-- Enable mouse
o.mouse = 'a'
o.mousescroll = 'ver:8,hor:6'
o.mousemoveevent = true

-- Tabs
o.tabstop = 2
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true

-- Searching
o.ignorecase = true
o.smartcase = true

-- More intuitive splits
o.splitright = true
o.splitbelow = true

-- Line breaks
o.linebreak = true
o.breakindent = true
o.wrap = false
o.textwidth = 120
o.clipboard = 'unnamed'

-- Pop up menu stuff
o.pumblend = 20
o.updatetime = 500
o.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }
o.grepprg = 'rg --vimgrep'
o.grepformat = '%f:%l:%c:%m'

-- backup
o.backup = true
o.writebackup = true
o.backupdir = { vim.fn.stdpath('state') .. '/backup' }

-- Misc.
o.exrc = true
o.concealcursor = ''
o.conceallevel = 2
o.confirm = true
o.showmode = false
o.history = 1000
o.winblend = 0
o.scrolloff = 4
o.undofile = true
o.smoothscroll = true
o.sessionoptions = {
  'buffers',
  'curdir',
  'folds',
  'help',
  'tabpages',
  'winsize',
  'globals',
  'terminal',
  'options',
}
o.wildoptions:append('fuzzy')
o.diffopt = {
  'internal',
  'filler',
  'vertical',
  'linematch:60',
}

-- UI stuff
o.cursorline = true
o.whichwrap:append('<,>,h,l,[,]')
o.foldlevelstart = 4
o.foldtext = [[v:lua.require'pynappo.tweaks.foldtext'()]]
o.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
  diff = '╱',
}
o.list = true
o.listchars = {
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  tab = '╏ ',
  nbsp = '␣',
}
vim.api.nvim_create_autocmd('FileType', { callback = function() vim.opt_local.formatoptions:remove({ 'o' }) end })
o.termguicolors = true

vim.schedule(function()
  -- vim.o.spell = true
  vim.o.spelllang = 'en'
end)

g.mapleader = ' '
g.maplocalleader = '\\'

vim.diagnostic.config({
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    source = 'if_many',
  },
  -- virtual_lines = { only_current_line = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
  float = {
    border = 'single',
    format = function(d) return ('%s (%s) [%s]'):format(d.message, d.source, d.code or d.user_data.lsp.code) end,
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
o.runtimepath:prepend(lazypath)
vim.b.minitrailspace_disable = true
require('pynappo.autocmds')
local has_private = pcall(require, 'pynappo.private')
require('lazy').setup({
  profiling = {
    require = true,
    loader = true,
  },
  spec = {
    { import = 'pynappo.plugins.extras' },
    { import = 'pynappo.plugins.lang' },
    { import = 'pynappo.plugins' },
    { import = 'pynappo.private.plugins' },
    -- { import = 'pynappo.plugins.colorschemes' },
  },
  lockfile = has_private and vim.fn.stdpath('config') .. '/private-lazy-lock.json' or nil,
  -- debug = true,
  git = {
    log = { '--since=3 days ago' }, -- show commits from the last 3 days
    timeout = 90, -- seconds
  },
  ---@diagnostic disable-next-line: assign-type-mismatch
  dev = {
    fallback = true,
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { 'pynappo', 'nvim-neo-tree' }, -- For example {"folke"}
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
      ['<localleader>l'] = function(plugin)
        require('lazy.util').float_term({ 'lazygit', 'log' }, {
          cwd = plugin.dir,
        })
      end,

      -- open a terminal for the plugin dir
      ['<localleader>t'] = function(plugin)
        require('lazy.util').float_term(nil, {
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
      paths = {}, -- add any custom paths here that you want to incluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        -- 'matchit',
        -- 'matchparen',
        'netrw',
        'netrwPlugin',
        'netrwSettings',
        'netrwFileHandlers',
        -- 'gzip',
        -- 'zip',
        -- 'zipPlugin',
        -- 'tar',
        -- 'tarPlugin',
        -- 'getscript',
        -- 'getscriptPlugin',
        -- 'vimball',
        -- 'vimballPlugin',
        -- '2html_plugin',
        -- 'logipat',
        -- 'rrhelper',
      },
    },
  },
  readme = {
    root = vim.fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md' },
    skip_if_doc_exists = true,
  },
})

require('pynappo.keymaps').setup.regular()
require('pynappo.theme')
require('pynappo.commands')
require('pynappo.tweaks')
require('pynappo.autocmds').setup_overrides()
vim.cmd.colorscheme('ayu')

vim.filetype.add({
  pattern = {
    ['${XDG_CONFIG_HOME}/waybar/config'] = 'json',
    ['${XDG_CONFIG_HOME}/hypr/.-conf'] = 'hyprlang',
    ['${HOME}/%.ssh/config.-'] = 'sshconfig',
  },
  extension = {
    rasi = 'rasi',
    mdx = 'mdx',
    sxcu = 'json',
  },
})
-- GUI stuff
o.guifont = 'Inconsolata Nerd Font Mono:h12:#e-subpixelantialias'
if g.neovide then
  g.neovide_transparency = 0.8
  g.neovide_refresh_rate = 144
  g.neovide_cursor_vfx_mode = 'ripple'
  g.neovide_cursor_animation_length = 0.03
  g.neovide_cursor_trail_size = 0.9
  g.neovide_remember_window_size = true
end

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
-- vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])

vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    local logpath = vim.fn.stdpath('state') .. '/log'
    local log = vim.uv.fs_stat(logpath)
    if not log then return end
    if log.size > 1024 * 1024 then vim.notify('log >1mb') end
  end,
})
if vim.version().minor > 10 then
  if vim.env.EMMYLUA then vim.lsp.enable('emmylua') end
end
