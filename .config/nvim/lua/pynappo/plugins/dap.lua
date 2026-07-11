local keymaps = require('pynappo.keymaps')
local github = require('pynappo.utils').repourl.github

local localhost = '127.0.0.1'
vim.pack.add({
  github'rcarriga/nvim-dap-ui',
  github'nvim-neotest/nvim-nio',
  github'mfussenegger/nvim-dap',
  github'theHamsta/nvim-dap-virtual-text',
  github'leoluz/nvim-dap-go',
})
require('nvim-dap-virtual-text').setup({ commented = true })
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
require('dap-go').setup()
