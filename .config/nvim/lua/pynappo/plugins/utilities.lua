return {
  {
    'bennypowers/nvim-regexplainer',
    cmd = {
      'RegexplainerHide',
      'RegexplainerToggle',
      'RegexplainerDebug',
      'RegexplainerYank',
      'RegexplainerShowSplit',
      'RegexplainerShowPopup',
      'RegexplainerShow',
    },
    config = function() require('regexplainer').setup() end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    },
  },
  {
    'AckslD/muren.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'nvim-pack/nvim-spectre',
    dependencies = 'nvim-lua/plenary.nvim',
    event = 'VeryLazy',
  },
}
