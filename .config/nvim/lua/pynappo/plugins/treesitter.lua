return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    event = { 'BufNewFile', 'BufReadPost' },
    build = function()
      if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
    end,
    cmd = 'TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: param-type-mismatch
      require('nvim-treesitter').setup({
        auto_install = true,
        ensure_installed = {
          'stable',
          'core',
        },
      })
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(details)
          local bufnr = details.buf
          if not pcall(vim.treesitter.start, bufnr) then return end
          -- vim.wo.foldmethod = 'expr'
          -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
      -- vim.treesitter.language.register('markdown', 'mdx')
      require('nvim-treesitter.parsers').mdx = {
        install_info = {
          url = '~/code/tree-sitter-mdx', -- local path or git repo
          files = { 'src/parser.c', 'src/scanner.c' }, -- note that some parsers also require src/scanner.c or src/scanner.cc
          -- optional entries:
          branch = 'main', -- default branch in case of git repo if different from master
          generate_requires_npm = true, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
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
      {
        'windwp/nvim-ts-autotag',
        config = true,
      },
      -- 'RRethy/nvim-treesitter-textsubjects',
    },
  },
}
