return {
  'nvim-treesitter/nvim-treesitter',
  event = 'BufReadPost',
  config = function() 
    require('nvim-treesitter.configs').setup {
      auto_install = vim.env.GIT_WORK_TREE == nil, -- otherwise auto-install fails on git commit -a
      ensure_installed = { "lua", "markdown", "help", "java", "markdown_inline", "regex" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = {'nim'},
      },
      textsubjects = {
        enable = true,
        keymaps = {
          ['.'] = 'textsubjects-smart',
          ['a.'] = 'textsubjects-container-outer',
          ['i.'] = 'textsubjects-container-inner',
        },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']m'] = '@function.outer',
            [']]'] = '@class.outer',
          },
          goto_next_end = {
            [']M'] = '@function.outer',
            [']['] = '@class.outer',
          },
          goto_previous_start = {
            ['[m'] = '@function.outer',
            ['[['] = '@class.outer',
          },
          goto_previous_end = {
            ['[M'] = '@function.outer',
            ['[]'] = '@class.outer',
          },
        },
      },
      matchup = {
        enable = true
      },
      rainbow = {
        enable = false,
        extended_mode = false,
        max_file_lines = nil
      },
      autotag = {
        enable = true,
      },
    }

    -- Better folds
    -- local o = vim.o
    -- o.foldexpr = 'nvim_treesitter#foldexpr()'
    -- o.foldmethod = 'expr'
    -- o.foldlevel = 99
    -- function _G.custom_fold_text()
    --   local line = vim.fn.getline(vim.v.foldstart)
    --   local line_count = vim.v.foldend - vim.v.foldstart + 1
    --   return '+' .. line .. ': ' .. line_count .. ' lines'
    -- end
    -- 
    -- o.foldtext = 'v:lua.custom_fold_text()'

  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag',
    {
      'nvim-treesitter/nvim-treesitter-context',
      config = function() require('treesitter-context').setup({ min_window_height = 30 }) end,
    },
    'nvim-treesitter/playground',
    'RRethy/nvim-treesitter-textsubjects',
  },
}
