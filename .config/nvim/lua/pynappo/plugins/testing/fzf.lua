return {
  {
    'vijaymarupudi/nvim-fzf',
    enabled = false,
    event = 'VeryLazy',
    config = function() local fzf = require('fzf') end,
  },
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- calling `setup` is optional for customization
      require('fzf-lua').setup({})
      vim.keymap.set(
        'c',
        '<C-H>',
        "getcmdtype() == ':' ? '<Home>FzfLua command_history query=<End><CR>' : '<C-R>'",
        { expr = true }
      )
    end,
  },
}
