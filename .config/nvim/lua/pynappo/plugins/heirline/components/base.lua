local conditions = require('heirline.conditions')
local M = {
  vi_mode = {
    init = function(self)
      self.mode = vim.fn.mode(1)
      if not self.once then
        vim.api.nvim_create_autocmd('ModeChanged', {
          pattern = '*:*o',
          command = 'redrawstatus',
        })
        self.once = true
      end
    end,
    static = {
      mode_names = {
        n = 'N',
        no = 'N?',
        nov = 'N?',
        noV = 'N?',
        ['no\22'] = 'N?',
        niI = 'Ni',
        niR = 'Nr',
        niV = 'Nv',
        nt = 'Nt',
        v = 'V',
        vs = 'Vs',
        V = 'V_',
        Vs = 'Vs',
        ['\22'] = '^V',
        ['\22s'] = '^V',
        s = 'S',
        S = 'S_',
        ['\19'] = '^S',
        i = 'I',
        ic = 'Ic',
        ix = 'Ix',
        R = 'R',
        Rc = 'Rc',
        Rx = 'Rx',
        Rv = 'Rv',
        Rvc = 'Rv',
        Rvx = 'Rv',
        c = 'C',
        cv = 'Ex',
        r = '...',
        rm = 'M',
        ['r?'] = '?',
        ['!'] = '!',
        t = 'T',
      },
    },
    provider = function(self) return '%2(' .. self.mode_names[self.mode] .. '%)' end,
    hl = { bold = true },
    update = { 'ModeChanged', 'CmdlineEnter', 'CmdlineLeave' },
  },
  cwd = {
    init = function(self)
      self.icon = (vim.fn.haslocaldir(0) == 1 and '(Local)' or '') .. '  '
      self.cwd = vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')
    end,
    update = { 'DirChanged' },
    hl = { fg = 'directory' },
    on_click = {
      callback = function() vim.cmd('Neotree toggle left reveal_force_cwd') end,
      name = 'heirline_neotree',
    },
    flexible = 1,
    { -- evaluates to the full-lenth path
      provider = function(self)
        local trail = self.cwd:sub(-1) == '/' and '' or (vim.fn.has('win32') and '\\' or '/')
        return self.icon .. self.cwd .. trail .. ' '
      end,
    },
    { -- evaluates to the shortened path
      provider = function(self)
        local cwd = vim.fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == '/' and '' or '/'
        return self.icon .. cwd .. trail .. ' '
      end,
    },
    { -- evaluates to "", hiding the component
      provider = '',
    },
  },
  gitsigns = {
    {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      hl = { fg = 'constant' },
      { -- git branch name
        provider = function(self) return ' ' .. self.status_dict.head end,
        hl = { bold = true },
      },
      -- You could handle delimiters, icons and counts similar to Diagnostics
      {
        condition = function(self) return self.has_changes end,
        provider = '(',
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ('+' .. count)
        end,
        hl = { fg = 'git_add' },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ('-' .. count)
        end,
        hl = { fg = 'git_del' },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ('~' .. count)
        end,
        hl = { fg = 'git_change' },
      },
      {
        condition = function(self) return self.has_changes end,
        provider = ')',
      },
    },
    update = {'BufEnter', 'BufWritePost'}
  },
  dropbar = {
    condition = function() return not vim.tbl_isempty(dropbar) end,
    init = function(self)
      local data = dropbar.bars[vim.api.nvim_get_current_buf()][vim.api.nvim_get_current_win()]
      local components = data.components
      local children = {}
      for i, c in ipairs(components) do
        local child = {
          {
            provider = c.icon,
            hl = c.icon_hl
          },
          {
            provider = c.name,
            hl = c.name_hl,
            on_click = {
              callback = function(_, ...)
                c:on_click(...)
              end,
              name = "heirline_dropbar",
            },
          },
        }
        if #components > 1 and i < #components then
          local sep = data.separator
          table.insert(child, {
            provider = sep.icon,
            hl = sep.icon_hl,
            on_click = {
              callback = function(_, ...)
                c:on_click(...)
              end,
              name = "heirline_dropbar_separator",
            }
          })
        end
        table.insert(children, child)
      end
      self.child = self:new(children, 1)
    end,
    provider = function(self) return self.child:eval() end,
  },
  diagnostics = {
    {
      condition = conditions.has_diagnostics,
      init = function(self)
        local buffer_diagnostics = vim.diagnostic.get(0, {severity = {min = vim.diagnostic.severity.INFO}})
        local diagnostic_counts = {0,0,0,0}
        for _, d in ipairs(buffer_diagnostics) do
          diagnostic_counts[d.severity] = diagnostic_counts[d.severity] + 1
        end
        local children = {}
        for d, count in pairs(diagnostic_counts) do
          if count > 0 then
            table.insert(children, {
              provider = self.icons[d] .. count,
              hl = self.highlights[d],
            })
          end
        end
        for i = 1, #children - 1, 1 do table.insert(children[i], { provider = ' ' }) end
        self.child = self:new(children, 1)
      end,
      static = {
        icons = {
          vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
          vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
          vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
          vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
        },
        highlights = {
          'DiagnosticError',
          'DiagnosticWarn',
          'DiagnosticInfo',
          'DiagnosticHint',
        },
      },
      on_click = {
        callback = function() require('trouble').toggle({ mode = 'document_diagnostics' }) end,
        name = 'heirline_diagnostics',
      },
      provider = function(self) return self.child:eval() end,
    },
    update = { 'DiagnosticChanged', 'BufEnter' }
  },
  dap = {
    {
      condition = function() return require('dap').session() end,
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
    update = {'CursorHold'}
  },
  termname = {
    provider = function() return ' ' .. vim.api.nvim_buf_get_name(0):gsub('.*:', '') end,
    hl = { fg = 'func' },
  },
  help_filename = {
    {
      condition = function() return vim.bo.filetype == 'help' end,
      provider = function() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t') end,
      hl = { fg = 'func' },
    },
    update = 'BufEnter',
  },
  ruler = {
    provider = '%7(%l/%3L%):%2c - %P',
    update = { 'CursorMoved', 'ModeChanged' }
  },
  lsp_icons = {
    update = { 'LspAttach', 'LspDetach' },
    init = function(self)
      self.servers = vim.lsp.get_active_clients()
    end,
    on_click = {
      callback = function()
        vim.defer_fn(function() vim.cmd('LspInfo') end, 100)
      end,
      name = 'heirline_LSP',
    },
    static = {
      ls_icons = {
        copilot = '',
        ['null-ls'] = '󰟢',
        jdtls = '',
      },
      devicon_by_filetype = require('nvim-web-devicons').get_icon_by_filetype
    },
    provider = function(self)
      if #self.servers == 0 then return 'N/A' end
      local icons = vim.tbl_map(function(server)
        return self.ls_icons[server.name] or self.devicon_by_filetype(server.config.filetypes[1]) or ''
      end, self.servers)
      return table.concat(icons, ' ')
    end,
  },
  lazy = {
    condition = function()
      local ok, lazy_status = pcall(require, "lazy.status")
      return ok and lazy_status.has_updates()
    end,
    provider = function() return require("lazy.status").updates() end,
  },
  file_flags = {
    update = { 'BufWritePost', 'BufEnter', 'InsertEnter', 'TextChanged' },
    {
      condition = function() return vim.bo.modified end,
      provider = ' [+]',
      hl = { fg = 'string' },
    },
    {
      condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
      provider = ' ',
      hl = { fg = 'constant' },
    },
  },
  filename = {
    init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
      if self.lfilename == '' then self.lfilename = '[No Name]' end
    end,
    hl = vim.bo.modified and { italic = true, force = true } or nil,
    flexible = 2,
    update = { 'BufEnter', 'BufWritePost', 'WinResized', 'VimResized' },
    { provider = function(self) return self.lfilename end },
    { provider = function(self) return vim.fn.pathshorten(self.lfilename) end },
  },
  file_icon = {
    provider = function(self) return self.icon and (self.icon .. ' ') end,
    hl = function(self) return { fg = self.icon_color } end,
    update = { 'FileType', 'BufEnter' },
  },
  filetype = {
    provider = function() return string.upper(vim.bo.filetype) end,
    hl = { fg = 'type', bold = true },
    update = { 'FileType' },
  },
}

M.file_info = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.extension = vim.fn.expand('%:e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(self.filename, self.extension, { default = true })
  end,
  M.file_icon,
  M.filename,
  M.file_flags,
}
return M
