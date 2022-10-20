require('mini.cursorword').setup()
local map = require('mini.map')
map.setup({
  integrations = {
    map.gen_integration.diagnostic({
      error = 'DiagnosticFloatingError',
      warn  = 'DiagnosticFloatingWarn',
      info  = 'DiagnosticFloatingInfo',
      hint  = 'DiagnosticFloatingHint',
    }),
    map.gen_integration.gitsigns(),
    map.gen_integration.builtin_search()
  }
})
require('mini.jump').setup()
require('pynappo/keymaps').setup_mini()
