return {
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        cpp = { 'cpplint' },
        c = { 'cpplint' },
        -- astro = { 'eslint_d' },
        -- javascript = { 'eslint_d' },
        -- typescript = { 'eslint_d' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function() require('lint').try_lint() end,
      })
    end,
  },
}
