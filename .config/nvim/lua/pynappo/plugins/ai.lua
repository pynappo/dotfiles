local utils = require('pynappo.utils')
local github = utils.repourl.github
vim.pack.add({
  github('folke/sidekick.nvim'),
  github('deathbeam/slopcode.nvim'),
  github('lewis6991/async.nvim'),
})

require('sidekick').setup({
  cli = {
    mux = {
      enabled = true,
      backend = vim.fn.executable('zellij') == 1 and 'zellij' or 'tmux',
    },
  },
  nes = { enabled = false },
})

local config = require('slopcode.config')

config.model = 'deepseek/deepseek-v4-flash' -- default model
config.window.layout = 'vertical' -- 'vertical' | 'horizontal' | 'float' | 'replace'
