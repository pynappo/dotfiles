return {
  -- {
  --   'vijaymarupudi/nvim-fzf',
  --   enabled = false,
  --   event = 'VeryLazy',
  --   config = function() local fzf = require('fzf') end,
  -- },
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = require('pynappo.keymaps').setup.fzf({ lazy = true }),
  },
}
