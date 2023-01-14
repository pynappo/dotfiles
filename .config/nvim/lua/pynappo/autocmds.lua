local autocmds = {}
local pynappo = vim.api.nvim_create_augroup('pynappo', { clear = true })
-- A little wrapper around nvim_create_autocmd
function autocmds.create(event, opts)
  opts.group = opts.group or pynappo
  local autocmd_id = vim.api.nvim_create_autocmd(event, opts)
end

if vim.g.started_by_firenvim then autocmds.create('BufEnter', { callback = function() vim.cmd.startinsert() end }) end

autocmds.create('TextYankPost', {
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end,
  desc = 'Highlight on yank',
})
-- Autocmds.create('BufWritePre', { command = [[keeppatterns %s/\s\+$//e]], desc = 'Trim ending whitespace' })

autocmds.create('BufReadPost', {
  pattern = '*',
  callback = function()
    local fn = vim.fn
    if fn.line('\'"') > 0 and fn.line('\'"') <= fn.line('$') then
      fn.setpos('.', fn.getpos('\'"'))
      vim.cmd('normal zz')
      vim.cmd('silent! foldopen')
    end
  end,
  desc = 'Restore cursor position',
})

autocmds.create('DiagnosticChanged', {
  callback = function() vim.diagnostic.setloclist({ open = false }) end,
  desc = 'Update loclist',
})

local heirline_colors = {}
autocmds.create('ColorScheme', {
  callback = function()
    if pcall(require, 'pynappo/plugins/heirline') then
      heirline_colors = {
        mode = require('pynappo/plugins/heirline').mode_colors,
        loaded = require('heirline.highlights').get_loaded_colors(),
      }
    end
  end,
  desc = 'Make sure that the heirline colors are updated when colorscheme changes',
})
local cursorline_bg_hex = string.format('%06x', vim.api.nvim_get_hl_by_name('CursorLine', true).background)
vim.api.nvim_set_hl(0, 'ModeCursorLine', { bg = '#' .. cursorline_bg_hex })
vim.api.nvim_create_autocmd({ 'VimEnter', 'ModeChanged' }, {
  callback = function()
    local heirline_color = heirline_colors.loaded[heirline_colors.mode[vim.fn.mode()]]
    local hex
    if not heirline_color then hex = cursorline_bg_hex
    else 
      hex = ('%06x'):format(heirline_color)
      local rgb = {
        tonumber('0x' .. hex:sub(1, 2)),
        tonumber('0x' .. hex:sub(3, 4)),
        tonumber('0x' .. hex:sub(5, 6)),
      }
      hex = ''
      for _, v in ipairs(rgb) do hex = hex .. ('%02x'):format(v / 5) end
    end
    vim.cmd.highlight('ModeCursorLine guibg=#' .. hex)
    vim.cmd.redraw()
  end,
  desc = 'Change mode cursorline',
})
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'CmdLineLeave'}, {
  callback = function() vim.opt_local.winhighlight:append('CursorLine:ModeCursorLine') end,
  desc = 'Enable mode cursorline for current windows',
})
vim.api.nvim_create_autocmd({ 'WinLeave', 'CmdLineEnter' }, {
  callback = function() vim.opt_local.winhighlight:remove({ 'CursorLine' }) end,
  desc = 'Disable mode cursorline for non-current windows',
})

autocmds.create('UIEnter', {
  callback = function()
    if vim.v.event.chan == 1 then
      require('pynappo/theme').transparent_override()
      autocmds.create('ColorScheme', {
        callback = require('pynappo/theme').transparent_override,
        desc = 'Transparent background',
      })
    end
  end,
})

return autocmds
