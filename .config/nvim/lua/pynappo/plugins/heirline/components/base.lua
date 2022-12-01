local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local M = {
  vi_mode = {
    init = function(self)
      self.mode = vim.fn.mode(1)
      if not self.once then
        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = "*:*o",
          command = 'redrawstatus'
        })
        self.once = true
      end
    end,
    static = {
      mode_names = {
        n = "N",
        no = "N?",
        nov = "N?",
        noV = "N?",
        ["no\22"] = "N?",
        niI = "Ni",
        niR = "Nr",
        niV = "Nv",
        nt = "Nt",
        v = "V",
        vs = "Vs",
        V = "V_",
        Vs = "Vs",
        ["\22"] = "^V",
        ["\22s"] = "^V",
        s = "S",
        S = "S_",
        ["\19"] = "^S",
        i = "I",
        ic = "Ic",
        ix = "Ix",
        R = "R",
        Rc = "Rc",
        Rx = "Rx",
        Rv = "Rv",
        Rvc = "Rv",
        Rvx = "Rv",
        c = "C",
        cv = "Ex",
        r = "...",
        rm = "M",
        ["r?"] = "?",
        ["!"] = "!",
        t = "T",
      },
    },
    provider = function(self) return "%2("..self.mode_names[self.mode].."%)" end,
    hl = { bold = true },
    update = { "ModeChanged" },
  },
  cwd = {
    init = function(self)
      self.icon = (vim.fn.haslocaldir(0) == 1 and "(Local)" or "") .. " " .. " "
      self.cwd = vim.fn.fnamemodify(vim.fn.getcwd(0), ":~")
    end,
    update = { "DirChanged" },
    hl = { fg = "directory" },
    on_click = {
      callback = function() vim.cmd('Neotree toggle left reveal_force_cwd') end,
      name = "heirline_neotree"
    },
    flexible = 1,
    { -- evaluates to the full-lenth path
      provider = function(self)
        local trail = self.cwd:sub(-1) == "/" and "" or (vim.fn.has("win32") and "\\" or "/")
        return self.icon .. self.cwd .. trail .." "
      end,
    },
    { -- evaluates to the shortened path
      provider = function(self)
        local cwd = vim.fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"
        return self.icon .. cwd .. trail .. " "
      end,
    },
    { -- evaluates to "", hiding the component
      provider = "",
    }
  },
  gitsigns = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    hl = { fg = "constant" },
    {   -- git branch name
      provider = function(self)
        return " " .. self.status_dict.head
      end,
      hl = { bold = true }
    },
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
      condition = function(self) return self.has_changes end,
      provider = "("
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ("+" .. count)
      end,
      hl = { fg = "git_add" },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ("-" .. count)
      end,
      hl = { fg = "git_del" },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ("~" .. count)
      end,
      hl = { fg = "git_change" },
    },
    {
      condition = function(self) return self.has_changes end,
      provider = ")",
    },
  },
  navic = {
    condition = require("nvim-navic").is_available,
    static = {
      -- create a type highlight map
      type_hl = {
        File = "Directory",
        Module = "@include",
        Namespace = "@namespace",
        Package = "@include",
        Class = "@structure",
        Method = "@method",
        Property = "@property",
        Field = "@field",
        Constructor = "@constructor",
        Enum = "@field",
        Interface = "@type",
        Function = "@function",
        Variable = "@variable",
        Constant = "@constant",
        String = "@string",
        Number = "@number",
        Boolean = "@boolean",
        Array = "@field",
        Object = "@type",
        Key = "@keyword",
        Null = "@comment",
        EnumMember = "@field",
        Struct = "@structure",
        Event = "@keyword",
        Operator = "@operator",
        TypeParameter = "@type",
      },
      -- bit operation dark magic, see below...
      enc = function(line, col, winnr) return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr) end,
      -- line: 16 bit (65535); col: 10 bit (1023); winnr: 6 bit (63)
      dec = function(c)
        local line = bit.rshift(c, 16)
        local col = bit.band(bit.rshift(c, 6), 1023)
        local winnr = bit.band(c,  63)
        return line, col, winnr
      end
    },
    init = function(self)
      local data = require("nvim-navic").get_data() or {}
      local children = {}
      -- create a child for each level
      for i, d in ipairs(data) do
        -- encode line and column numbers into a single integer
        local pos = self.enc(d.scope.start.line, d.scope.start.character, self.winnr)
        local child = {
          { provider = d.icon, hl = self.type_hl[d.type], },
          {
            provider = d.name:gsub("%%", "%%%%"):gsub("%s*->%s*", ''),
            on_click = {
              -- pass the encoded position through minwid
              minwid = pos,
              callback = function(_, minwid)
                local line, col, winnr = self.dec(minwid)
                vim.api.nvim_win_set_cursor(vim.fn.win_getid(winnr), {line, col})
              end,
              name = "heirline_navic",
            },
          },
        }
        if #data > 1 and i < #data then
          table.insert(child, {
            provider = " > ",
            hl = { fg = 'normal' },
          })
        end
        table.insert(children, child)
      end
      -- instantiate the new child, overwriting the previous one
      self.child = self:new(children, 1)
    end,
    -- evaluate the children containing navic components
    provider = function(self) return self.child:eval() end,
    hl = { fg = "normal" },
    update = 'CursorHold'
  },
  diagnostics = {
    condition = conditions.has_diagnostics,
    init = function(self)
      self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      self.getsign = vim.fn.sign_getdefined
    end,
    update = { "DiagnosticChanged", "BufEnter" },
    on_click = {
      callback = function() require("trouble").toggle({ mode = "document_diagnostics" }) end,
      name = "heirline_diagnostics",
    },
    { provider = "[ ", },
    {
      provider = function(self) return self.errors > 0 and (self.errors .. self.getsign("DiagnosticSignError")[1].text) end,
      hl = { fg = "diag_error" },
    },
    {
      provider = function(self) return self.warnings > 0 and (self.warnings .. self.getsign("DiagnosticSignWarn")[1].text) end,
      hl = { fg = "diag_warn" },
    },
    {
      provider = function(self) return self.info > 0 and (self.info .. self.getsign("DiagnosticSignInfo")[1].text)end,
      hl = { fg = "diag_info" },
    },
    {
      provider = function(self) return self.hints > 0 and (self.hints .. self.getsign("DiagnosticSignHint")[1].text) end,
      hl = { fg = "diag_hint" },
    },
    { provider = "]", },
  },
  dap = {
    condition = function()
      local session = require("dap").session()
      return session ~= nil
    end,
    provider = function() return " " .. require("dap").status() end,
    hl = { fg = "debug" },
    -- see Click-it! section for clickable actions
  },
  termname = {
    -- we could add a condition to check that buftype == 'terminal'
    -- or we could do that later (see #conditional-statuslines below)
    provider = function() return " " .. vim.api.nvim_buf_get_name(0):gsub(".*:", "") end,
    hl = { fg = "func" },
  },
  help_filename = {
    condition = function() return vim.bo.filetype == "help" end,
    update = "BufEnter",
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = 'func' },
  },
  -- I take no credits for this! :lion:
  ruler = { provider = "%7(%l/%3L%):%2c - %P" },
  scrollbar = {
    static = { sbar = { '█','▇', '▆', '▅', '▄', '▃', '▂', '▁' } },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      return string.rep(self.sbar[i], 2)
    end,
    update = 'CursorMoved',
    hl = { fg = "func", bg = "bright_bg" },
  },
  lsp = {
    condition = conditions.lsp_attached,
    update = {'CursorMoved', 'LspAttach', 'LspDetach'},
    init = function(self)
      self.servers = vim.lsp.get_active_clients()
      self.devicon_by_filetype = require("nvim-web-devicons").get_icon_by_filetype
    end,
    on_click = {
      callback = function() vim.defer_fn(function() vim.cmd("LspInfo") end, 100) end,
      name = "heirline_LSP",
    },
    static = {
      ls_icons = {
        copilot = '',
        ['null-ls'] = 'ﳠ'
      }
    },
    provider = function(self)
      local icons = {}
      if #self.servers == 0 then return "N/A" end
      for _, s in ipairs(self.servers) do
        if self.ls_icons[s.name] then
          table.insert(icons, self.ls_icons[s.name])
        elseif s.config then
          table.insert(icons, self.devicon_by_filetype(s.config.filetypes[1]) or '')
        end
      end
      return table.concat(icons, ' ')
    end,
  },
  file_flags = {
    {
      condition = function() return vim.bo.modified end,
      provider = " [+]",
      hl = { fg = "string" },
    },
    {
      condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
      provider = " ",
      update = "BufEnter",
      hl = { fg = "constant" },
    },
  },
  filename = {
    init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
      if self.lfilename == "" then self.lfilename = "[No Name]" end
    end,
    hl = function()
      if vim.bo.modified then return { italic = true, force=true } end
    end,
    flexible = 2,
    update = 'BufEnter',
    { provider = function(self) return self.lfilename end },
    { provider = function(self) return vim.fn.pathshorten(self.lfilename) end },
  },
  file_icon = {
    provider = function(self) return self.icon and (self.icon .. " ") end,
    hl = function(self) return { fg = self.icon_color } end,
    update = { "FileType" },
  },
  filetype = {
    provider = function() return string.upper(vim.bo.filetype) end,
    hl = { fg = "type", bold = true },
    update = { "FileType" },
  },
}

M.file_info = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
    self.extension = vim.fn.expand("%:e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(self.filename, self.extension, { default = true })
  end,
  M.file_icon,
  M.filename,
  M.file_flags
}
return M
