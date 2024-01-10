return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufNewFile', 'BufReadPost' },
    build = function()
      if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
    end,
    cmd = 'TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      require('nvim-treesitter.configs').setup(vim.tbl_deep_extend('force', {
        auto_install = true,
        ensure_installed = {
          'lua',
          'markdown',
          -- 'vimdoc',
          'java',
          -- 'markdown_inline',
          'regex',
          -- 'comment',
        },
        highlight = {
          enable = true,
        },
        textsubjects = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          },
          swap = {
            enable = true,
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
          },
        },
        matchup = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
      }, require('pynappo.keymaps').treesitter))
    end,
    dependencies = {
      {
        'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
        config = function()
          local rainbow_highlight_names = require('pynappo.theme').set_rainbow_colors('RainbowDelimiter', {
            { 'Red', '#EF6D6D' },
            { 'Orange', '#FFA645' },
            { 'Yellow', '#EDEF56' },
            { 'Green', '#6AEF6F' },
            { 'Cyan', '#78E6EF' },
            { 'Blue', '#70A4FF' },
            { 'Violet', '#BDB2EF' },
          })
          local rainbow_delimiters = require('rainbow-delimiters')

          vim.g.rainbow_delimiters = {
            strategy = {
              [''] = rainbow_delimiters.strategy['global'],
              vim = rainbow_delimiters.strategy['local'],
            },
            query = {
              [''] = 'rainbow-delimiters',
            },
            highlight = rainbow_highlight_names,
          }
        end,
      },
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
      'nvim-treesitter/playground',
      'RRethy/nvim-treesitter-textsubjects',
      'luckasRanarison/tree-sitter-hypr',
    },
  },
}
