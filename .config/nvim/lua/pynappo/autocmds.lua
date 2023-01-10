local Autocmds = {}
local pynappo = vim.api.nvim_create_augroup('pynappo', { clear = true })
-- A little wrapper around nvim_create_autocmd
-- @param event -
function Autocmds:create(event, opts)
  opts.group = opts.group or pynappo
  local autocmd_id = vim.api.nvim_create_autocmd(event, opts)
  if opts.desc then
    Autocmds[opts.desc] = autocmd_id
  else
    table.insert(Autocmds, autocmd_id, { event, opts })
  end
end

if vim.g.started_by_firenvim then Autocmds:create('BufEnter', { callback = function() vim.cmd.startinsert() end }) end

Autocmds:create('TextYankPost', {
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
  desc = 'Highlight on yank',
})
Autocmds:create('BufWritePre', { command = [[keeppatterns %s/\s\+$//e]], desc = 'Trim ending whitespace' })

Autocmds:create('BufReadPost', {
  pattern = '*',
  callback = function()
    local fn = vim.fn
    if fn.line('\'"') > 0 and fn.line('\'"') <= fn.line('$') then
      fn.setpos('.', fn.getpos('\'"'))
      vim.cmd('normal zz')
      vim.cmd('silent! foldopen')
    end
  end,
})

Autocmds:create('DiagnosticChanged', {
  callback = function() vim.diagnostic.setloclist({ open = false }) end,
  desc = 'Update loclist',
})

local theme = require('pynappo/theme')

-- Replicating modes.nvim but using heirline mode colors
local heirline_colors = {}
Autocmds:create('ColorScheme', {
  callback = function()
    heirline_colors = {
      mode = require('pynappo/plugins/heirline').mode_colors,
      loaded = require('heirline.highlights').get_loaded_colors(),
    }
  end,
  desc = 'Make sure that the heirline colors are updated when colorscheme changes'
})
local CursorLine = vim.api.nvim_get_hl_by_name('CursorLine', true)
vim.api.nvim_set_hl(0, 'ModeCursorLine', { bg = '#' .. string.format('%x', CursorLine.background) })
Autocmds:create({ 'VimEnter', 'WinEnter' }, {
  callback = function() vim.opt_local.winhighlight:append('CursorLine:ModeCursorLine') end,
  desc = 'Enable mode cursorline for current windows',
})
Autocmds:create({ 'ModeChanged' }, {
  callback = function()
    local hex = string.format('%x', heirline_colors.loaded[heirline_colors.mode[vim.fn.mode()]])
    local rgb = {
      tonumber('0x' .. hex:sub(1, 2)),
      tonumber('0x' .. hex:sub(3, 4)),
      tonumber('0x' .. hex:sub(5, 6)),
    }
    hex = ''
    for _, v in ipairs(rgb) do
      hex = hex .. string.format('%x', v / 5)
    end
    vim.cmd.highlight('ModeCursorLine guibg=#' .. hex)
  end,
  desc = 'Change mode cursorline',
})
Autocmds:create('WinLeave', {
  callback = function() vim.opt_local.winhighlight:remove({ 'CursorLine' }) end,
  desc = 'Disable the mode cursorline for non-current windows',
})

Autocmds:create('UIEnter', {
  callback = function()
    if vim.v.event.chan == 1 then
      theme.transparent_override()
      Autocmds:create('ColorScheme', {
        callback = theme.transparent_override,
        desc = 'Transparent background',
      })
    end
  end,
})

return Autocmds
