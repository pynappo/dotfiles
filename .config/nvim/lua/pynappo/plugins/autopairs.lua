local github = require('pynappo.utils').repourl.github

vim.pack.add({
  github('windwp/nvim-autopairs'),
})
local npairs = require('nvim-autopairs')
npairs.setup()
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.add_rules({
  Rule('$', '$', { 'tex', 'latex', 'typst' }):with_pair(cond.not_before_regex('\\')):with_cr(cond.none()),
})

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
