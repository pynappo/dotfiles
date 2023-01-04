local conditions = require('heirline.conditions')
local utils = require('heirline.utils')

local space = { provider = ' ' }
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
    update = { 'ModeChanged' },
  },
  cwd = {
    init = function(self)
      self.icon = (vim.fn.haslocaldir(0) == 1 and '(Local)' or '') .. ' ' .. ' '
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
  navic = {
    flexible = 3,
    {
      condition = function()
        return require('nvim-navic').is_available()
      end,
      static = {
        -- create a type highlight map
        type_hl = {
          File = 'Directory',
          Module = '@include',
          Namespace = '@namespace',
          Package = '@include',
          Class = '@structure',
          Method = '@method',
          Property = '@property',
          Field = '@field',
          Constructor = '@constructor',
          Enum = '@field',
          Interface = '@type',
          Function = '@function',
          Variable = '@variable',
          Constant = '@constant',
          String = '@string',
          Number = '@number',
          Boolean = '@boolean',
          Array = '@field',
          Object = '@type',
          Key = '@keyword',
          Null = '@comment',
          EnumMember = '@field',
          Struct = '@structure',
          Event = '@keyword',
          Operator = '@operator',
          TypeParameter = '@type',
        },
        -- bit operation dark magic, see below...
        enc = function(line, col, winnr) return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr) end,
        -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
        dec = function(c)
          local line = bit.rshift(c, 16)
          local col = bit.band(bit.rshift(c, 6), 1023)
          local winnr = bit.band(c, 63)
          return line, col, winnr
        end,
      },
      init = function(self)
        local data = require('nvim-navic').get_data() or {}
        local children = {}
        -- create a child for each level
        for i, d in ipairs(data) do
          -- encode line and column numbers into a single integer
          local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
          local child = {
            { provider = d.icon, hl = self.type_hl[d.type] },
            {
              provider = d.name:gsub('%%', '%%%%'):gsub('%s*->%s*', ''),
              on_click = {
                -- pass the encoded position through minwid
                minwid = pos,
                callback = function(_, minwid)
                  local line, col, winnr = self.dec(minwid)
                  vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), { line, col })
                end,
                name = 'heirline_navic',
              },
            },
          }
          if #data > 1 and i < #data then table.insert(child, { provider = ' > ', hl = { fg = 'normal' } }) end
          table.insert(children, child)
        end
        -- instantiate the new child, overwriting the previous one
        self.child = self:new(children, 1)
      end,
      -- evaluate the children containing navic components
      provider = function(self)
        return self.child:eval()
      end,
      hl = { fg = 'normal' },
    },
    { provider = '' },
    update = 'CursorHold'
  },
  diagnostics = {
    {
      condition = conditions.has_diagnostics,
      init = function(self)
        local diag = vim.diagnostic
        local diagnostics_count = {
          error = #diag.get(0, { severity = diag.severity.ERROR }),
          warning = #diag.get(0, { severity = diag.severity.WARN }),
          hint = #diag.get(0, { severity = diag.severity.HINT }),
          info = #diag.get(0, { severity = diag.severity.INFO }),
        }
        local children = {}
        for diag, count in pairs(diagnostics_count) do
          if count > 0 then
            table.insert(children, {
              provider = string.format('%s%s', self.icons[diag], count),
              hl = self.highlights[diag],
            })
          end
        end
        for i = 1, #children - 1, 1 do table.insert(children[i], { provider = ' ' }) end
        self.child = self:new(children, 1)
      end,
      static = {
        icons = {
          error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
          warning = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
          info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
          hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
        },
        highlights = {
          error = 'DiagnosticError',
          warning = 'DiagnosticWarn',
          info = 'DiagnosticInfo',
          hint = 'DiagnosticHint',
        },
      },
      on_click = {
        callback = function() require('trouble').toggle({ mode = 'document_diagnostics' }) end,
        name = 'heirline_diagnostics',
      },
      provider = function(self) return self.child:eval() end,
    },
    update = 'DiagnosticChanged'
  },
  dap = {
    {
      condition = function() return require('dap').session() ~= nil end,
      provider = function() return ' ' .. require('dap').status() .. ' ' end,
      hl = 'Debug',
      {
        provider = '',
        on_click = {
          callback = function() require('dap').step_into() end,
          name = 'heirline_dap_step_into',
        },
      },
      { provider = ' ' },
      {
        provider = '',
        on_click = {
          callback = function() require('dap').step_out() end,
          name = 'heirline_dap_step_out',
        },
      },
      { provider = ' ' },
      {
        provider = ' ',
        on_click = {
          callback = function() require('dap').step_over() end,
          name = 'heirline_dap_step_over',
        },
      },
      { provider = ' ' },
      {
        provider = 'ﰇ',
        on_click = {
          callback = function() require('dap').run_last() end,
          name = 'heirline_dap_run_last',
        },
      },
      { provider = ' ' },
      {
        provider = '',
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
  scrollbar = {
    static = { sbar = { '█', '▇', '▆', '▅', '▄', '▃', '▂', '▁' } },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      return string.rep(self.sbar[i], 2)
    end,
    update = 'CursorMoved',
    hl = { fg = 'func', bg = 'bright_bg' },
  },
  lsp = {
    update = { 'LspAttach', 'LspDetach' },
    init = function(self)
      self.servers = vim.lsp.get_active_clients()
      self.devicon_by_filetype = require('nvim-web-devicons').get_icon_by_filetype
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
        ['null-ls'] = 'ﳠ',
        jdtls = '',
      },
    },
    provider = function(self)
      local icons = {}
      if #self.servers == 0 then return 'N/A' end
      for _, s in ipairs(self.servers) do
        table.insert(icons, self.ls_icons[s.name] or self.devicon_by_filetype(s.config.filetypes[1]) or '')
      end
      return table.concat(icons, ' ')
    end,
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
    self.icon, self.icon_color =
    require('nvim-web-devicons').get_icon_color(self.filename, self.extension, { default = true })
  end,
  M.file_icon,
  M.filename,
  M.file_flags,
}
return M
