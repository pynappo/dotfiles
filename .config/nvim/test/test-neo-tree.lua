-- template from https://lazy.folke.io/developers#reprolua, feel free to replace if you have your own minimal init.lua
vim.env.LAZY_STDPATH = '.repro'
load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()
require('lazy.minit').repro({
  spec = {
    {
      'nvim-neo-tree/neo-tree.nvim',
      dev = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        -- "3rd/image.nvim", -- Optional image support
      },
      opts = {
        -- fill any relevant options here
        use_popups_for_input = false,
        window = {
          position = 'float',
          -- mappings = {
          --   a = { 'add', config = { show_path = 'relative' } },
          -- },
        },
        filesystem = {
          bind_to_cwd = false,
        },
        enable_git_status = true,
        enable_diagnostics = true,
      },
    },
  },
  dev = {
    fallback = true,
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = { 'pynappo' }, -- For example {"folke"}
  },
})
vim.o.cmdheight = 0
