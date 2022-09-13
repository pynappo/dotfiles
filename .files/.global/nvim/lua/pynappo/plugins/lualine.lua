local navic = require("nvim-navic")
local lualine = require("lualine")
lualine.setup {
  options = {
    component_separators = { left = "|", right = "|" },
    section_separators = { left = '', right = '' },
    global_statusline = true,
    disabled_filetypes = {
      winbar = {'neo-tree'}
    }
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch', 'diagnostics' },
    lualine_c = {{ navic.get_location, cond = navic.is_available }},
    lualine_x = { 'fileformat' },
    lualine_y = { 'filetype' },
    lualine_z = {
      { 'progress', separator = { right = '' }, left_padding = 1 },
    },
  },
  tabline = {},
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {'%f'},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {'%f', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {}
  },
  extensions = {'neo-tree', 'symbols-outline', 'quickfix'},
}
