local keymaps = require('pynappo.keymaps')
return {
  { 'nacro90/numb.nvim', config = function() require('numb').setup() end, event = 'CmdlineEnter' },
  { 'winston0410/range-highlight.nvim', dependencies = { 'winston0410/cmd-parser.nvim' }, config = true },
  {
    'max397574/better-escape.nvim',
    opts = {
      mapping = { 'jk', 'kj' },
      keys = function() return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>' end,
    },
  },
  {
    'mrjones2014/smart-splits.nvim',
    init = keymaps.setup.smart_splits,
    config = true,
  },
  { 'tiagovla/scope.nvim', opts = {} },
  {
    'karb94/neoscroll.nvim',
    enabled = true,
    event = 'VeryLazy',
    config = function()
      require('neoscroll').setup({ easing_function = 'quadratic' })
      require('neoscroll.config').set_mappings(keymaps.neoscroll)
    end,
  },
  'tpope/vim-repeat',
  {
    'nmac427/guess-indent.nvim',
    event = 'VeryLazy',
    config = function() require('guess-indent').setup({}) end,
  },
  {
    'andymass/vim-matchup',
    enabled = false,
    event = { 'BufNewFile', 'BufRead' },
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  { 'Aasim-A/scrollEOF.nvim', config = false },
  { 'lambdalisue/suda.vim' },
  {
    'jinh0/eyeliner.nvim',
    opts = {
      highlight_on_key = true, -- show highlights only after keypress
      dim = false, -- dim all other characters if set to true (recommended!)
    },
  },
  { 'tweekmonster/helpful.vim', init = function() vim.g.helpful = 1 end },
}
