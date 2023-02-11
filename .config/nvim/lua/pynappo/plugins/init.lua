local keymaps = require('pynappo.keymaps')
return {
  { import = 'pynappo.plugins.heirline' },
  -- Misc plugins
  {
    'goolord/alpha-nvim',
    config = function() require('alpha').setup(require('alpha.themes.startify').config) end,
  },
  { 'simrat39/symbols-outline.nvim', config = function() require('symbols-outline').setup() end },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        open_mapping = keymaps.toggleterm.open_mapping,
        winbar = {
          enabled = true,
          name_formatter = function(term) return term.name end,
        },
        highlights = { StatusLine = { guibg = 'StatusLine' } }, -- Hack for global heirline to work
      })
    end,
  },
  {
    'nvim-neorg/neorg',
    ft = 'norg',
    cmd = 'Neorg',
    priority = 30,
    config = function() require('neorg').setup({ load = { ['core.defaults'] = {} } }) end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rouge8/neotest-rust',
    },
    lazy = true
  },
  { 'ellisonleao/glow.nvim', config = true },
  -- { 'glacambre/firenvim', build = function() vim.fn['firenvim#install'](0) end },
  { 'AckslD/nvim-FeMaco.lua', config = function() require('femaco').setup() end },
  {
    'xeluxee/competitest.nvim',
    cmd = {
      'CompetiTestAdd',
      'CompetiTestRun',
      'CompetiTestEdit',
      'CompetiTestDelete',
      'CompetiTestReceive',
      'CompetiTestRunNE',
      'CompetiTestRunNC',
      'CompetiTestConvert',
    },
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function() require('competitest').setup({ runner_ui = { interface = 'popup' } }) end,
  },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = function() vim.g.startuptime_tries = 3 end },
}
