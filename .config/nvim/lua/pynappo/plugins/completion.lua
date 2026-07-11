---@diagnostic disable: missing-fields
local utils = require('pynappo.utils')
if utils.is_termux then return end
local github = require('pynappo.utils').repourl.github

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    vim.print(name)
    if name:find('blink.cmp', 1, true) and kind == 'install' or kind == 'update' then
      vim.cmd.packadd('blink.cmp')
      require('blink.cmp').build():pwait()
    end
  end,
})
vim.pack.add({
  github('Saghen/blink.cmp'),
  github('Saghen/blink.lib'),
  github('rafamadriz/friendly-snippets'),
})
require('blink-cmp').setup({
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
      border = 'none',
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
  sources = {
    -- Add your default providers list here (like 'lsp', 'path', 'snippets', 'buffer')
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      path = {
        override = {
          get_trigger_characters = function(source) return { '/', '.', '\\', '@' } end,
        },
      },
    },
  },
})
