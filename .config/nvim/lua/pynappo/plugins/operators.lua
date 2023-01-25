return {

  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  {
    'ggandor/leap.nvim',
    dependencies = {
      { 'ggandor/leap-spooky.nvim', config = function() require('leap-spooky').setup() end },
      { 'ggandor/flit.nvim', config = function() require('flit').setup({ labeled_modes = 'v' }) end },
    },
    config = function() require('leap').add_default_mappings() end,
  },
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = "TSJToggle",
    config = function() require('treesj').setup({ use_default_keymaps = false }) end,
    keys = keymaps.setup.treesj({ lazy = true }),
  },
}
