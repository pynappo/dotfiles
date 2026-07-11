local keymaps = require('pynappo.keymaps')
local github = require('pynappo.utils').repourl.github
vim.g.helpful = 1
vim.g.matchup_surround_enabled = 1
vim.g.matchup_transmute = 1
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_offscreen = {}
vim.pack.add({
  github('nacro90/numb.nvim'),
  -- { 'winston0410/range-highlight.nvim', dependencies = { 'winston0410/cmd-parser.nvim' }, config = true },
  github('max397574/better-escape.nvim'),
  github('mrjones2014/smart-splits.nvim'),
  github('tiagovla/scope.nvim'),
  github('karb94/neoscroll.nvim'),
  github('tpope/vim-repeat'),
  github('nmac427/guess-indent.nvim'),
  github('andymass/vim-matchup'),
  github('pynappo/sudow.nvim'),
  github('jinh0/eyeliner.nvim'),
  github('tweekmonster/helpful.vim'),
  github('nanotee/zoxide.vim'),
  github('HakonHarnes/img-clip.nvim'),
})
require('numb').setup()
require('better_escape').setup({
  mappings = {
    i = {
      j = {
        k = '<Esc>',
        j = false,
      },
      k = {
        j = '<Esc>',
      },
    },
    c = {
      j = {
        k = '<Esc>',
        j = false,
      },
      k = {
        j = '<Esc>',
      },
    },
    t = {
      j = {
        k = '<Esc>',
        j = false,
      },
      k = {
        j = '<Esc>',
      },
    },
    s = {
      j = {
        k = '<Esc>',
        j = false,
      },
      k = {
        j = '<Esc>',
      },
    },
    v = {
      j = {
        k = false,
        j = false,
      },
      k = {
        j = false,
      },
    },
  },
})
keymaps.setup.smart_splits()
require('scope').setup({})

require('img-clip').setup({})
require('eyeliner').setup({
  highlight_on_key = true, -- show highlights only after keypress dim = false, -- dim all other characters if set to true (recommended!)
})
require('guess-indent').setup({})
require('neoscroll').setup({ easing_function = 'quadratic' })
