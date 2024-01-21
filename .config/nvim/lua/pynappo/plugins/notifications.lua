local keymaps = require('pynappo.keymaps')
return {
  {
    'rcarriga/nvim-notify',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('notify').setup({ background_colour = '#000000' })
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
  {
    'folke/noice.nvim',
    opts = {
      cmdline = {
        enabled = false,
        view = 'cmdline',
      },
      messages = { enabled = true },
      lsp = {
        progress = {
          enabled = true,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      views = {
        hover = {
          border = { style = 'rounded' },
          position = { row = 2 },
        },
        mini = {
          position = { row = -1 - vim.o.cmdheight }, -- better default
        },
      },
      routes = {
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
            cond = function(message)
              local client = vim.tbl_get(message.opts, 'progress', 'client')
              return client == 'null-ls'
            end,
          },
          opts = { skip = true },
        },
        {
          filter = { find = 'No information available' },
          opts = { stop = true },
        },
        {
          filter = { find = 'bytes$' },
          opts = { skip = true },
        },
      },
      presets = {
        inc_rename = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      {
        'smjonas/inc-rename.nvim',
        dependencies = {
          {
            'stevearc/dressing.nvim',
            opts = {
              input = {
                override = function(conf)
                  conf.col = -1
                  conf.row = 0
                  return conf
                end,
              },
            },
          },
        },
        init = keymaps.setup.incremental_rename,
        config = true,
      },
    },
  },
}
