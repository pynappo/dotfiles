local utils = require('heirline.utils')
local M = {
  tabline_bufnr = {
    provider = function(self) return tostring(self.bufnr) .. '. ' end,
    hl = 'Comment',
  },
  tabline_filename = {
    provider = function(self)
      -- self.filename will be defined later, just keep looking at the example!
      local filename = self.filename
      filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
      return filename
    end,
    hl = function(self) return { bold = self.is_active or self.is_visible } end,
  },
  tabline_file_flags = {
    {
      condition = function(self) return vim.bo[self.bufnr].modified end,
      provider = '[+]',
      hl = { fg = 'green' },
    },
    {
      condition = function(self) return not vim.bo[self.bufnr].modifiable or vim.bo[self.bufnr].filetype == 'help' end,
      provider = function(self) return vim.bo[self.bufnr].filetype == 'terminal' and '  ' or '' end,
      hl = { fg = 'orange' },
    },
  },
  tabline_close_button = {
    condition = function(self) return not vim.bo[self.bufnr].modified end,
    {
      provider = ' ',
      hl = { fg = 'gray' },
      on_click = {
        callback = function(_, minwid) vim.api.nvim_buf_delete(minwid, { force = false }) end,
        minwid = function(self) return self.bufnr end,
        name = 'heirline_tabline_close_buffer_callback',
      },
    },
  },
}

local file_icon = require('pynappo/plugins/heirline/components/base').file_icon
M.tabline_filename_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    self.icon, self.icon_color =
      require('nvim-web-devicons').get_icon_color(self.filename, self.extension, { default = true })
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
  M.tabline_bufnr,
  file_icon,
  M.tabline_filename,
  M.tabline_file_flags,
}
M.tabline_buffer_block = utils.surround(
  { '', '' },
  function(self) return self.is_active and utils.get_highlight('TabLineSel').bg or utils.get_highlight('TabLine').bg end,
  {
    M.tabline_filename_block,
    M.tabline_close_button,
  }
)

M.tabline_offset = {
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
M.bufferline = utils.make_buflist(
  M.tabline_buffer_block,
  { provider = '', hl = { fg = 'gray' } },
  { provider = '', hl = { fg = 'gray' } }
)
M.tabpages = {
  condition = function() return #vim.api.nvim_list_tabpages() >= 2 end,
  update = { 'TabNewEntered', 'TabNew', 'TabLeave', 'TabEnter', 'TabClosed' },
  utils.make_tablist({
    provider = function(self) return '%' .. self.tabnr .. 'T ' .. self.tabnr .. ' %T' end,
    hl = function(self) return self.is_active and 'TabLineSel' or 'TabLine' end,
  }),
  {
    provider = '%999X  %X',
    hl = 'TabLine',
  },
}
return M
