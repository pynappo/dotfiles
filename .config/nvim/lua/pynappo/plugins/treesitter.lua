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
          disable = { 'go' },
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
          lsp_interop = {
            enable = true,
            border = 'none',
            floating_preview_opts = {},
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
        },
        matchup = {
          enable = true,
        },
        autotag = {
          enable = true,
          filetypes = {
            'html',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'svelte',
            'vue',
            'tsx',
            'jsx',
            'rescript',
            'css',
            'lua',
            'xml',
            'php',
            'markdown',
          },
        },
      }, require('pynappo.keymaps').treesitter))
      -- vim.treesitter.language.register('markdown', 'mdx')
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.o.foldenable = false
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.mdx = {
        install_info = {
          url = '~/code/tree-sitter-mdx', -- local path or git repo
          files = { 'src/parser.c', 'src/scanner.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          -- optional entries:
          branch = 'main', -- default branch in case of git repo if different from master
          generate_requires_npm = true, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        -- filetype = 'zu', -- if filetype does not match the parser name
      }
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
