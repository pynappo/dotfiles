---@diagnostic disable: missing-fields
local utils = require('pynappo.utils')
if utils.is_termux then return end
local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('Saghen/blink.cmp'),
  github('Saghen/blink.lib'),
  github('rafamadriz/friendly-snippets'),
})
local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
  enabled = function()
    if vim.bo.filetype == 'slopcode' then return 'force' end
    return true
  end,
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
    per_filetype = {
      slopcode = { inherit_defaults = true, 'omni' },
    },
  },
})
