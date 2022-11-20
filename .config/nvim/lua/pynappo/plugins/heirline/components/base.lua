local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local space = { provider = " " }
local M = {
  vi_mode = {
    init = function(self)
      self.mode = vim.fn.mode(1) -- :h mode()
      -- execute this only once, this is required if you want the ViMode
      -- component to be updated on operator pending mode
      if not self.once then
        vim.api.nvim_create_autocmd("ModeChanged", {
          pattern = "*:*o",
          command = 'redrawstatus'
        })
        self.once = true
      end
    end,
    static = {
      mode_names = { -- change the strings if you like it vvvvverbose!
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
      mode_colors = {
        n = "diag_error" ,
        i = "string",
        v = "special",
        V =  "special",
        ["\22"] =  "special",
        c =  "constant",
        s =  "statement",
        S =  "statement",
        ["\19"] =  "statement",
        R =  "constant",
        r =  "constant",
        ["!"] =  "diag_error",
        t =  "diag_error",
      }
    },
    provider = function(self) return " %2("..self.mode_names[self.mode].."%)" end,
    hl = function(self)
      local mode = self.mode:sub(1, 1) -- get only the first mode character
      return { fg = self.mode_colors[mode], bold = true, }
    end,
    update = { "ModeChanged" },
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
    { provider = "[", },
    {
      provider = function(self) return self.errors > 0 and (self.getsign("DiagnosticSignError")[1].text .. self.errors) end,
      hl = { fg = "diag_error" },
    },
    {
      provider = function(self) return self.warnings > 0 and (self.getsign("DiagnosticSignWarn")[1].text .. self.warnings) end,
      hl = { fg = "diag_warn" },
    },
    {
      provider = function(self) return self.info > 0 and (self.getsign("DiagnosticSignInfo")[1].text .. self.info) end,
      hl = { fg = "diag_info" },
    },
    {
      provider = function(self) return self.hints > 0 and (self.getsign("DiagnosticSignHint")[1].text .. self.hints) end,
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
    hl = "Debug"
    -- see Click-it! section for clickable actions
  },
  termname = {
    -- we could add a condition to check that buftype == 'terminal'
    -- or we could do that later (see #conditional-statuslines below)
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
      return " " .. tname
    end,
    hl = { fg = "func", bold = true },
  },
  help_filename = {
    condition = function()
      return vim.bo.filetype == "help"
    end,
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)
      return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = 'function' },
  },
  -- I take no credits for this! :lion:
  ruler = { provide = "%7(%l/%3L%):%2c %P" },
  scrollbar = {
    static = { sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' } },
    provider = function(self)
      local curr_line = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
      return string.rep(self.sbar[i], 2)
    end,
    hl = { fg = "func", bg = "bright_bg" },
  },

  spell = {
    condition = function() return vim.wo.spell end,
    provider = 'SPELL',
    hl = { bold = true, fg = "constant"}
  },
  lsp = {
    condition = conditions.lsp_attached,
    update = {'LspAttach', 'LspDetach'},
    init = function(self)
      self.servers = vim.lsp.get_active_clients()
    end,
    static = {
      ls_icons = {
        copilot = '',
        ['null-ls'] = 'ﳠ'
      }
    },
    provider = function(self)
      local status = ''
      for _, s in ipairs(self.servers) do
        if self.ls_icons[s.name] then
          status = status .. ' ' .. self.ls_icons[s.name]
        else
          if s.config then
            local icon, _ = require('nvim-web-devicons').get_icon_by_filetype(s.config.filetypes[1])
            status = status .. ' ' .. icon
          end
        end
      end
      return status
    end,
    hl = { fg = "string", bold = true },
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
      hl = { fg = "constant" },
    },
  },
  filename = {
    {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then return "[No Name]" end
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    },
    hl = function()
      if vim.bo.modified then
        return { italic = true, bold = true, force=true }
      end
    end,
  },
  file_icon = {
    provider = function(self) return self.icon and (self.icon .. " ") end,
    hl = function(self) return { fg = self.icon_color } end
  },
  filetype = {
    provider = function() return string.upper(vim.bo.filetype) end,
    hl = { fg = utils.get_highlight("Type").fg, bold = true },
  },
}

M.file_info = {
  init = function(self)
    self.filename = vim.fn.expand("%:t")
    self.extension = vim.fn.expand("%:e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(self.filename, self.extension, { default = true })
  end,
  M.file_icon,
  M.filename,
  M.file_flags
}
return M
