return {
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      { 'mfussenegger/nvim-dap' },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function() require('nvim-dap-virtual-text').setup({ commented = true }) end,
      },
    },
    config = function()
      local keymaps = require('pynappo.keymaps')
      keymaps.setup.dap()
      keymaps.setup.dapui()
      require('dapui').setup({})
    end,
  },
}
