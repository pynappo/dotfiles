local Autocmds = require('pynappo/autocmds')

local o = vim.o
local g = vim.g
if vim.g.started_by_firenvim then
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
