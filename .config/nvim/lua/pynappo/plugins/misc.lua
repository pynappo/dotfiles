local keymaps = require('pynappo.keymaps')
return {
  {
    'xeluxee/competitest.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function() require('competitest').setup({ runner_ui = { interface = 'popup' } }) end,
  },
}
