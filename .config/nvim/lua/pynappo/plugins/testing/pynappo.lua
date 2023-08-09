return {
  {
    'pynappo/tabnames.nvim',
    opts = {
      session_support = true,
      default_tab_name = function(tabnr)
        local p = require('tabnames').presets
        return p.special_buffers(tabnr) or p.special_tabs(tabnr) or p.short_tab_cwd(tabnr)
      end
    },
  },
}
