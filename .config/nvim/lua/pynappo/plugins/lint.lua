local github = require('pynappo.utils').repourl.github
vim.pack.add({
  github('mfussenegger/nvim-lint'),
})
require('lint').linters_by_ft = {
  cpp = { 'cpplint' },
  c = { 'cpplint' },
}
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  callback = function() require('lint').try_lint() end,
})
