local keymaps = require('pynappo.keymaps')
return {
  { 'nacro90/numb.nvim', config = function() require('numb').setup() end, event = 'CmdlineEnter' },
  -- { 'winston0410/range-highlight.nvim', dependencies = { 'winston0410/cmd-parser.nvim' }, config = true },
  {
    'max397574/better-escape.nvim',
    config = function()
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
    end,
  },
  {
    'mrjones2014/smart-splits.nvim',
    init = keymaps.setup.smart_splits,
    config = true,
  },
  { 'tiagovla/scope.nvim', opts = {} },
  {
    'karb94/neoscroll.nvim',
    config = function() require('neoscroll').setup({ easing_function = 'quadratic' }) end,
  },
  'tpope/vim-repeat',
  {
    'nmac427/guess-indent.nvim',
    event = 'VeryLazy',
    config = function() require('guess-indent').setup({}) end,
  },
  {
    'andymass/vim-matchup',
    enabled = true,
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
    enabled = false,
    config = function()
      require('eyeliner').setup({
        highlight_on_key = true, -- show highlights only after keypress dim = false, -- dim all other characters if set to true (recommended!)
      })
    end,
  },
  { 'tweekmonster/helpful.vim', init = function() vim.g.helpful = 1 end },
  { 'nanotee/zoxide.vim' },
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      -- add options here
      -- or leave it empty to use the default settings
    },
    keys = {
      { '<leader><C-p>', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    },
  },
}
