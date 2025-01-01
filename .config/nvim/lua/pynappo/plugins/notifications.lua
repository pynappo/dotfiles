local keymaps = require('pynappo.keymaps')
return {
  -- {
  --   'rcarriga/nvim-notify',
  --   config = function(_, opts)
  --     require('notify').setup({
  --       background_colour = '#000000',
  --       render = 'wrapped-compact',
  --       stages = 'slide',
  --       timeout = require('pynappo.utils').is_termux and 2000 or 5000,
  --       minimum_width = 10,
  --     })
  --     vim.notify = require('notify').notify
  --     local levels = {
  --       ERROR = 'Error',
  --       WARN = 'Warn',
  --       INFO = 'Info',
  --       DEBUG = 'Hint',
  --       TRACE = 'Ok',
  --     }
  --     local sections = {
  --       Title = '',
  --       Border = '',
  --       Icon = 'Sign',
  --     }
  --     for notify_level, diagnostic_level in pairs(levels) do
  --       for notify_section, diagnostic_section in pairs(sections) do
  --         require('pynappo.theme').overrides.all.links['Notify' .. notify_level .. notify_section] = 'Diagnostic'
  --           .. diagnostic_section
  --           .. diagnostic_level
  --       end
  --     end
  --   end,
  -- },
  {
    'j-hui/fidget.nvim',
    opts = {
      -- options
      notification = {
        window = {
          normal_hl = 'NormalFloat', -- Base highlight group in the notification window
          winblend = 0, -- Background color opacity in the notification window
          border = 'none', -- Border around the notification window
          zindex = 45, -- Stacking priority of the notification window
          max_width = 0, -- Maximum width of the notification window
          max_height = 0, -- Maximum height of the notification window
          x_padding = 1, -- Padding from right edge of window boundary
          y_padding = 0, -- Padding from bottom edge of window boundary
          align = 'bottom', -- How to align the notification window
          relative = 'editor', -- What the notification window position is relative to
        },
      },
    },
  },
}
