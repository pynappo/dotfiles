return {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPost',
  build = function()
    if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
  end,
  cmd = 'TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup(vim.tbl_deep_extend('force', {
      auto_install = vim.env.GIT_WORK_TREE == nil,
      ensure_installed = {
        "lua",
        "markdown",
        "vimdoc",
        "java",
        "markdown_inline",
        "regex",
        'gitcommit',
        'gitignore',
        'git_config',
        'git_rebase',
        'gitattributes',
        'comment',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = {'nim'},
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
        enable = true
      },
      autotag = {
        enable = true,
      },
      rainbow = {
        enable = true,
        -- list of languages you want to disable the plugin for
        disable = {},
        -- Which query to use for finding delimiters
        query = 'rainbow-parens',
        -- Highlight the entire buffer all at once
        strategy = require('ts-rainbow').strategy.global,
        hlgroups = {
          'TSRainbowRed',
          'TSRainbowOrange',
          'TSRainbowYellow',
          'TSRainbowGreen',
          'TSRainbowCyan',
          'TSRainbowBlue',
          'TSRainbowViolet',
        },
      }
    }, require('pynappo.keymaps').treesitter))
    local colors = {
      Red = '#EF6D6D',
      Orange = '#FFA645',
      Yellow = '#EDEF56',
      Green = '#6AEF6F',
      Cyan = '#78F6FF',
      Blue = '#70A4FF',
      Violet = '#BDB2FF',
    }
    require('pynappo.theme').set_rainbow_colors('TSRainbow', colors, 'Set rainbow parentheses')
  end,
  dependencies = {
    'HiPhish/nvim-ts-rainbow2',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
    {
      'nvim-treesitter/nvim-treesitter-context',
      enabled = false,
      config = function() require('treesitter-context').setup({ min_window_height = 30 }) end,
    },
    'nvim-treesitter/playground',
    'RRethy/nvim-treesitter-textsubjects',
  },
}
