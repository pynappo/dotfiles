return {
  {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({ background_colour = '#000000' })
      local levels = {
        ERROR = 'Error',
        WARN = 'Warn',
        INFO = 'Info',
        DEBUG = 'Hint',
        TRACE = 'Ok'
      }
      local sections = {
        Title = '',
        Border = '',
        Icon = 'Sign',
      }
      for notify_level, diagnostic_level in pairs(levels) do
        for notify_section, diagnostic_section in pairs(sections) do
          require('pynappo.theme').overrides.all_themes.links['Notify' .. notify_level .. notify_section] = 'Diagnostic' .. diagnostic_section .. diagnostic_level
        end
      end
    end,
  },
}
