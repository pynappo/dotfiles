local keymaps = require('pynappo/keymaps')
return {
  { 'nacro90/numb.nvim', config = function() require('numb').setup() end, event = 'CmdlineEnter' },
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup({
        mapping = { 'jk', 'kj' },
        keys = function() return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>' end,
      })
    end,
  },
  {
    'mrjones2014/smart-splits.nvim',
    init = function() keymaps.setup.smart_splits() end,
    config = true,
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    init = keymaps.setup.yanky,
    config = function()
      require("yanky").setup({
        picker = {
          select = {
            action = nil, -- nil to use default put action
          },
          telescope = {
            mappings = nil, -- nil to use default mappings
          },
        },
      })
    end
  },
  { 'tiagovla/scope.nvim' },
  {
    'chentoast/marks.nvim',
    config = function() require('marks').setup({default_mappings = false}) end,
    keys = keymaps.setup.marks({lazy=true})
  },
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({ easing_function = 'quadratic' })
      require('neoscroll.config').set_mappings(keymaps.neoscroll)
    end,
  },
  'tpope/vim-repeat',
  { 'nmac427/guess-indent.nvim', config = function() require('guess-indent').setup({}) end },
  {
    'andymass/vim-matchup',
    event = 'BufRead',
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
}
