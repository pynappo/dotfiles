local localhost = '127.0.0.1'
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
      {
        'leoluz/nvim-dap-go',
        config = function() require('dap-go').setup() end,
      },
    },
    config = function()
      local keymaps = require('pynappo.keymaps')
      keymaps.setup.dap()
      keymaps.setup.dapui()
      local dapui = require('dapui')
      dapui.setup({})
      local dap = require('dap')
      dap.adapters.godot = {
        type = 'server',
        host = localhost,
        port = 6006,
      }

      dap.configurations.gdscript = {
        {
          type = 'godot',
          request = 'launch',
          name = 'Launch scene',
          project = '${workspaceFolder}',
          launch_scene = true,
        },
      }
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
    end,
  },
}
