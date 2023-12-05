return {
  conform = {
    condition = function(self)
      local ok, conform = pcall(require, 'conform')
      self.conform = conform
      return ok
    end,
    update = { 'BufEnter', 'BufNewFile' },
    provider = function(self)
      local ft_formatters = self.conform.list_formatters(0)
      return ft_formatters and
          table.concat(vim.tbl_map(function(f) return f.name end, ft_formatters), ' ') or 'N/A'
    end,
  },
  lazy = {
    condition = function()
      local ok, lazy_status = pcall(require, 'lazy.status')
      return ok and lazy_status.has_updates()
    end,
    provider = function() return require('lazy.status').updates() end,
    on_click = {
      callback = function() require('lazy').check() end,
      name = 'heirline_plugin_updates',
    },
  },
  dap = {
    {
      condition = function()
        local ok, dap = pcall(require, 'dap')
        return ok and dap.session()
      end,
      provider = function() return ' ' .. require('dap').status() .. ' ' end,
      hl = 'Debug',
      {
        provider = '󰆹',
        on_click = {
          callback = function() require('dap').step_into() end,
          name = 'heirline_dap_step_into',
        },
      },
      { provider = ' ' },
      {
        provider = '󰆸',
        on_click = {
          callback = function() require('dap').step_out() end,
          name = 'heirline_dap_step_out',
        },
      },
      { provider = ' ' },
      {
        provider = '󰆷',
        on_click = {
          callback = function() require('dap').step_over() end,
          name = 'heirline_dap_step_over',
        },
      },
      { provider = ' ' },
      {
        provider = '󰜉',
        on_click = {
          callback = function() require('dap').run_last() end,
          name = 'heirline_dap_run_last',
        },
      },
      { provider = ' ' },
      {
        provider = '󰅖',
        on_click = {
          callback = function()
            require('dap').terminate()
            require('dapui').close({})
          end,
          name = 'heirline_dap_close',
        },
      },
    },
    update = { 'CursorHold' },
  },
}
