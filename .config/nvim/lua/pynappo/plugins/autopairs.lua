local github = require('pynappo.utils').repourl.github

vim.pack.add({
  github('altermo/ultimate-autopair.nvim'),
})
require('ultimate-autopair').setup({
  { '$', '$', ft = { 'typst' } },
  extensions = {
    filetype = {
      p = 90,
      nft = { 'TelescopePrompt' },
      tree = true,
    },
  },
})
