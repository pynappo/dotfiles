---@type string|"relative"

return {
  'Saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = 'v0.*',
  build = 'cargo build --release',
  enabled = true,
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- "enter" keymap
    --   you may want to set `completion.list.selection = "manual" | "auto_insert"`
    --
    --   ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    --   ['<C-e>'] = { 'hide', 'fallback' },
    --   ['<CR>'] = { 'accept', 'fallback' },
    --
    --   ['<Tab>'] = { 'snippet_forward', 'fallback' },
    --   ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    --
    --   ['<Up>'] = { 'select_prev', 'fallback' },
    --   ['<Down>'] = { 'select_next', 'fallback' },
    --   ['<C-p>'] = { 'select_prev', 'fallback' },
    --   ['<C-n>'] = { 'select_next', 'fallback' },
    --
    --   ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    --   ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    keymap = {
      preset = 'enter',
      ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
      ['<C-n>'] = { 'show', 'select_next', 'fallback' },
      cmdline = {
        preset = 'super-tab',
        ['<Tab>'] = { 'select_prev', 'fallback' },
        ['<S-Tab>'] = { 'select_next', 'fallback' },
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
        winblend = vim.o.winblend,
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
  },
}
