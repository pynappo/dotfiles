local keymaps = require("pynappo/keymaps")
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
  {
    'monaqa/dial.nvim',
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.hexcolor.new({ case = 'lower' }),
          augend.constant.alias.bool,
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
          augend.constant.alias.bool,
        },
      })
    end,
    keys = keymaps.setup.dial({lazy=true})
  },
}