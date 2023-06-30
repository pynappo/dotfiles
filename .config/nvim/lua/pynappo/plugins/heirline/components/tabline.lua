local utils = require('heirline.utils')
local tabline = {
  bufnr = {
    provider = function(self) return tostring(self.bufnr) .. '. ' end,
    hl = function(self) return { fg = 'comment', bold = self.is_visible } end,
  },
  filename = {
    init = function(self)
      self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
      if self.lfilename == '' then self.lfilename = '[No Name]' end
    end,
    hl = vim.bo.modified and { italic = true, force = true } or nil,
    provider = function(self) return vim.fn.pathshorten(self.lfilename) end,
  },
  file_flags = {
    {
      condition = function(self) return vim.bo[self.bufnr].modified end,
      provider = ' [+]',
      hl = { fg = 'string' },
    },
    {
      condition = function(self) return not vim.bo[self.bufnr].modifiable or vim.bo[self.bufnr].filetype == 'help' end,
      provider = function(self) return vim.bo[self.bufnr].filetype == 'terminal' and '  ' or '' end,
      hl = { fg = 'orange' },
    },
  },
  close_button = {
    condition = function(self) return not vim.bo[self.bufnr].modified end,
    {
      provider = ' 󰅖',
      hl = { fg = 'gray' },
      on_click = {
        callback = function(_, minwid) vim.api.nvim_buf_delete(minwid, { force = false }) end,
        minwid = function(self) return self.bufnr end,
        name = 'heirline_tabline_close_buffer_callback',
      },
    },
  },
  picker = {
    condition = function(self)
      return self._show_picker
    end,
    init = function(self)
      local bufname = vim.api.nvim_buf_get_name(self.bufnr)
      bufname = vim.fn.fnamemodify(bufname, ":t")
      local label = bufname:sub(1, 1)
      local i = 2
      while self._picker_labels[label] do
        if i > #bufname then
          break
        end
        label = bufname:sub(i, i)
        i = i + 1
      end
      self._picker_labels[label] = self.bufnr
      self.label = label
    end,
    provider = function(self)
      return self.label
    end,
    hl = { fg = 'diag_warn', bold = true },
  },
  tabpage = {
    init = function(self) self.name = vim.t[self.tabnr].name end,
    provider = function(self) return '%' .. self.tabnr .. 'T ' .. self.tabnr .. (self.name and ' ' .. self.name or '') .. ' %T' end,
    hl = function(self) return self.is_active and 'TabLineSel' or 'TabLine' end,
  }
}

local file_icon = require('pynappo/plugins/heirline/components/base').file_icon

tabline.filename_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(
      self.filename,
      self.extension,
      { default = true }
    )
  end,
  hl = function(self) return self.is_active and 'TabLineSel' or 'TabLine' end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == 'm' then
        vim.api.nvim_buf_delete(minwid, { force = false })
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self) return self.bufnr end,
    name = 'heirline_tabline_buffer_callback',
  },
  tabline.bufnr,
  file_icon,
  tabline.filename,
  tabline.file_flags,
}

tabline.tabline_buffer_block = utils.surround(
  { '', '' },
  function(self) return self.is_active and 'tabline_sel' or 'tabline' end,
  {
    tabline.picker,
    tabline.filename_block,
    tabline.close_button,
  }
)

tabline.offset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == 'neo-tree' then
      self.title = 'Neo-Tree'
      return true
    end
  end,
  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - string.len(title)) / 2)
    return string.rep(' ', pad) .. title .. string.rep(' ', pad)
  end,
  hl = function(self) return vim.api.nvim_get_current_win() == self.winid and 'TablineSel' or 'Tabline' end,
}
tabline.bufferline = utils.make_buflist(
  tabline.tabline_buffer_block,
  { provider = '', hl = { fg = 'gray' } },
  { provider = '', hl = { fg = 'gray' } }
)
tabline.tabpages = {
  {
    condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
    utils.make_tablist(tabline.tabpage),
    {
      provider = '%999X 󰅖 %X',
      hl = 'TabLine',
    },
  },
  update = { 'TabEnter', 'TabLeave', 'TabNew', 'TabNewEntered', 'TabClosed', 'User' }
}
return tabline
