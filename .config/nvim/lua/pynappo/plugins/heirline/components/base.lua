local conditions = require('heirline.conditions')
local u = require('pynappo.plugins.heirline.components.utils')
local M = {
  vi_mode = {
    init = function(self)
      self.mode = vim.fn.mode()
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
        n = '',
        no = '?',
        nov = '?',
        noV = '?',
        ['no\22'] = '?',
        niI = 'i',
        niR = 'r',
        niV = 'v',
        nt = 't',
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
    provider = function(self) return '%(' .. self.mode_names[self.mode] .. '%)' end,
    hl = { bold = true },
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
        local trail = self.cwd:sub(-1) == '/' and '' or (require('pynappo.utils').is_windows and '\\' or '/')
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
    update = { 'BufEnter', 'BufWritePost' },
  },
  diagnostics = {
    {
      condition = conditions.has_diagnostics,
      init = function(self)
        local buffer_diagnostics = vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.INFO } })
        local diagnostic_counts = { 0, 0, 0, 0 }
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
        for i = 1, #children - 1, 1 do
          table.insert(children[i], { provider = ' ' })
        end
        self.child = self:new(children, 1)
      end,
      static = {
        icons = {
          '',
          '',
          '',
          '󰌵',
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
    update = { 'DiagnosticChanged', 'BufEnter' },
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
    provider = '%02c,%l',
  },
  lsp_icons = {
    update = { 'LspAttach', 'LspDetach', 'LspProgress', 'WinEnter' },
    condition = function(self)
      self.clients = vim.lsp.get_clients()
      return not vim.tbl_isempty(self.clients)
    end,
    init = function(self)
      local children = {}
      for i, client in ipairs(self.clients) do
        ---@diagnostic disable-next-line: undefined-field
        local icon = self.ls_icons[client.name]
        if not icon and client.config.filetypes then
          icon = require('mini.icons').get('filetype', client.config.filetypes[1])
        end
        local child = {
          { provider = icon or '?', hl = { bold = client.attached_buffers[vim.api.nvim_get_current_buf()] } },
          -- {
          --   condition = function() return not self.ignore_messages[client.name] end,
          --   provider = function()
          --     local progress = client.progress:peek()
          --     if progress and progress.value then
          --       local values = vim.tbl_map(function(field) return progress.value[field] end, {'title', 'percentage', 'message'})
          --       return table.concat(values, ' ')
          --     end
          --   end,
          -- }
        }
        if i < #self.clients then table.insert(child, u.space) end
        table.insert(children, child)
      end
      self.child = self:new(children, 1)
    end,
    on_click = {
      callback = function() vim.cmd('LspInfo') end,
      name = 'heirline_LSP',
    },
    static = {
      ls_icons = {
        astro = '󰑣',
        copilot = '',
        emmet_language_server = '',
        ['null-ls'] = '󰟢',
        tailwindcss = '󱏿',
        jdtls = '',
      },
      ignore_messages = {
        ['null-ls'] = true,
      },
    },
    provider = function(self) return self.child:eval() end,
  },
  file_flags = {
    update = { 'BufWritePost', 'BufEnter', 'InsertEnter', 'TextChanged' },
    {
      condition = function() return vim.bo.modified end,
      provider = ' [+]',
      hl = 'String',
    },
    {
      condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
      provider = ' ',
      hl = 'Constant',
    },
  },
  filename = {
    init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
      if self.lfilename == '' then self.lfilename = '[No Name]' end
    end,
    hl = vim.bo.modified and { italic = true, force = true } or nil,
    flexible = 2,
    { provider = function(self) return self.winbar and vim.fn.pathshorten(self.lfilename) or self.lfilename end },
    { provider = function(self) return vim.fn.pathshorten(self.lfilename) end },
  },
  file_icon = {
    init = function(self)
      local ft = vim.bo[0].filetype or 'text'
      self.icon, self.icon_color = require('mini.icons').get('filetype', ft)
    end,
    provider = function(self) return self.icon and (self.icon .. ' ') end,
    hl = function(self) return self.icon_color end,
    update = { 'FileType', 'BufEnter' },
  },
  filetype = {
    provider = function() return (vim.bo.filetype):upper() end,
    hl = { fg = 'type', bold = true },
    update = { 'FileType' },
  },
}

M.file_info = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.extension = vim.fn.expand('%:e')
  end,
  M.file_icon,
  M.filename,
  M.file_flags,
}
return M
