local keymaps = require('pynappo.keymaps')
return {
  {
    'rcarriga/nvim-notify',
    cond = true,
    opts = {
      background_colour = '#000000',
      render = 'wrapped-compact',
      timeout = require('pynappo.utils').is_termux and 2000 or 5000,
      minimum_width = 10,
    },
    config = function(_, opts)
      require('notify').setup(opts)
      local levels = {
        ERROR = 'Error',
        WARN = 'Warn',
        INFO = 'Info',
        DEBUG = 'Hint',
        TRACE = 'Ok',
      }
      local sections = {
        Title = '',
        Border = '',
        Icon = 'Sign',
      }
      for notify_level, diagnostic_level in pairs(levels) do
        for notify_section, diagnostic_section in pairs(sections) do
          require('pynappo.theme').overrides.all.links['Notify' .. notify_level .. notify_section] = 'Diagnostic'
            .. diagnostic_section
            .. diagnostic_level
        end
      end
    end,
  },
}
