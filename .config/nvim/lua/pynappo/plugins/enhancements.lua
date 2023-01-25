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
  { 'RRethy/vim-illuminate', event = 'BufRead' },
  {
    'kevinhwang91/nvim-hlslens',
    config = function() require('hlslens').setup() end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = keymaps.setup.hlslens({ lazy = true }),
  },
  {
    'mrjones2014/smart-splits.nvim',
    init = function() keymaps.setup.smart_splits() end,
    config = function() require('smart-splits').setup({}) end,
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
