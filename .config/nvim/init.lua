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

require("pynappo/keymaps").setup.regular()
local signs = {
  DiagnosticSignError = {text = "", texthl = "DiagnosticSignError"},
  DiagnosticSignWarn = {text = "", texthl = "DiagnosticSignWarn"},
  DiagnosticSignInfo = {text = "", texthl = "DiagnosticSignInfo"},
  DiagnosticSignHint = {text = "", texthl = "DiagnosticSignHint"}
}
for name, sign in pairs(signs) do vim.fn.sign_define(name, sign) end
o.termguicolors = true
require("pynappo/plugins")
require("pynappo/autocmds")
require("pynappo/theme").transparent_override()
vim.cmd.colorscheme('ayu')

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.:Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.:Telescope <Cmd>Telescope<CR>]])
local commands = {
  {"CDhere", "cd %:p:h"},
  {
    "Trim",
    function()
      local curpos = vim.api.nvim_win_get_cursor(0)
      -- Trail whitespace
      vim.cmd([[keeppatterns %s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, curpos)

      --- Trim last blank lines
      local n_lines = vim.api.nvim_buf_line_count(0)
      local last_nonblank = vim.fn.prevnonblank(n_lines)
      if last_nonblank < n_lines then vim.api.nvim_buf_set_lines(0, last_nonblank, n_lines, true, {}) end
    end,
  },
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
if g.started_by_firenvim then
  vim.cmd.startinsert()
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

vim.g.hardcopy_default_directory = '~/Documents/'

local function export_to_html_and_open_output(params)
  vim.pretty_print(params)
  local range = params.range ~= 0 and {params.line1, params.line2} or {}
  local path = ''
  if #params.args > 0 then
    local stats = vim.loop.fs_stat(params.args)
    if stats and stats.type == 'directory' then
      vim.api.nvim_err_writeln([[E502: "]] .. params.args .. [[" is a directory]])
      return
    end
    path = vim.fn.expand(params.args)
  else
    if vim.g.hardcopy_default_directory then
      local default_directory = vim.fn.expand(vim.g.hardcopy_default_directory)
      local stats = vim.loop.fs_stat(default_directory)
      if not stats or stats.type ~= 'directory' then 
        vim.api.nvim_err_writeln('"' .. default_directory .. '" is not a valid default directory, cancelling.')
        return
      end
      path = vim.g.hardcopy_default_directory
    else
      path = vim.loop.fs_stat(vim.fn.expand('~/Downloads/')) and vim.fn.expand('~/Downloads/') or vim.fn.tempname()
    end
    -- Add filename
    path = path .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p:t')
    vim.pretty_print(path)
    -- Add range at end of filename if specified
    if params.range > 0 then
      path = path .. '(L' .. params.line1 .. (params.range > 1 and '-' .. params.line2 or '') .. ')'
    end
  end

  vim.cmd.TOhtml({ range = range })
  local tohtml_bufnr = vim.api.nvim_win_get_buf(0)

  path = vim.fn.fnameescape(path .. '.html')
  vim.api.nvim_buf_set_name(tohtml_bufnr, path)
  if vim.loop.fs_stat(path) and not params.bang then
    local choice = vim.fn.confirm(
      'A .html file with the same name exists. Continue and overwrite? (Default: No)',
      '&Yes\n&No',
      2,
      'Question'
    )
    if choice ~= 1 then
      vim.cmd.bwipeout({bang = true, args = { tohtml_bufnr }})
      return
    end
  end
  vim.cmd.wq({bang = true, args = {path}})
  vim.notify('Saved HTML at: ' .. path)

  vim.fn['netrw#BrowseX'](path, 0)

  vim.cmd.bwipeout({bang = true, args = { tohtml_bufnr }})
end

vim.api.nvim_create_user_command('Hardcopy', export_to_html_and_open_output, {
  desc = 'Dumps the buffer content into an HTML and opens the browser for viewing or printing',
  nargs = '?',
  range = true,
  bang = true,
  complete = 'file',
})

