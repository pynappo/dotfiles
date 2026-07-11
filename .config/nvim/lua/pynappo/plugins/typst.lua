local github = require('pynappo.utils').repourl.github

vim.pack.add({
    github'chomosuke/typst-preview.nvim',
})
    require('typst-preview').setup({})
