return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufNewFile', 'BufReadPost' },
  build = function()
    if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
  end,
  cmd = 'TSUpdate',
  config = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require('nvim-treesitter.configs').setup(vim.tbl_deep_extend('force', {
      auto_install = vim.env.GIT_WORK_TREE == nil,
      ensure_installed = {
        'lua',
        'markdown',
        'vimdoc',
        'java',
        'markdown_inline',
        'regex',
        'gitcommit',
        'gitignore',
        'git_config',
        'git_rebase',
        'gitattributes',
        'comment',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'nim' },
      },
      textsubjects = {
        enable = true,
      },
      indent = {
        enable = false,
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
    {
      'nvim-treesitter/nvim-treesitter-context',
      enabled = false,
      opts = { min_window_height = 30 },
    },
    'nvim-treesitter/playground',
    'RRethy/nvim-treesitter-textsubjects',
    {
      'luckasRanarison/tree-sitter-hypr',
      config = function()
        require('nvim-treesitter.parsers').get_parser_configs().hypr = {
          install_info = {
            url = 'https://github.com/luckasRanarison/tree-sitter-hypr',
            files = { 'src/parser.c' },
            branch = 'master',
          },
          filetype = 'hypr',
        }
      end,
    },
  },
}
