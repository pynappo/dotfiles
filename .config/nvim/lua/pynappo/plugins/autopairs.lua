local github = require('pynappo.utils').repourl.github

vim.pack.add({
  github('windwp/nvim-autopairs'),
})
require('nvim-autopairs').setup()
-- require('ultimate-autopair').setup({
--   { '$', '$', ft = { 'typst' } },
--   extensions = {
--     filetype = {
--       p = 90,
--       nft = { 'TelescopePrompt' },
--       tree = true,
--     },
--   },
-- })
