local keymaps = require('pynappo.keymaps')
return {
  {
    'xeluxee/competitest.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function() require('competitest').setup({ runner_ui = { interface = 'popup' } }) end,
  },
  {
    'rgroli/other.nvim',
    config = function()
      require('other-nvim').setup({
        mappings = {
          'c',
          {
            -- context = "C header",
            pattern = '(.*).cpp$',
            target = '%1.h',
          },
          {
            -- context = "C header",
            pattern = '(.*).h$',
            target = '%1.cpp',
          },
        },
      })
    end,
  },
  {
    'reachingforthejack/cursortab.nvim',
    dev = true,
  },
}
