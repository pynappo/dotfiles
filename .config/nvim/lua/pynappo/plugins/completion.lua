---@diagnostic disable: missing-fields
local utils = require('pynappo.utils')
return {
  {
    'Saghen/blink.cmp',
    version = '*',
    dependencies = 'rafamadriz/friendly-snippets',
    enabled = not utils.is_termux,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
      },
      cmdline = {
        enabled = true,
        keymap = {
          preset = 'cmdline',
        },
      },
      completion = {
        list = {
          selection = {
            auto_insert = true,
            preselect = false,
          },
        },
        menu = {
          winblend = 25,
        },
        ghost_text = {
          enabled = true,
        },
        documentation = {
          auto_show = true,
        },
      },
      signature = {
        enabled = true,
      },
      appearance = {
        use_nvim_cmp_as_default = true,
      },
    },
  },
}
