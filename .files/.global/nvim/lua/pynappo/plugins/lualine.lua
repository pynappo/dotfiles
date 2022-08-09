local navic = require("nvim-navic")
local lualine = require("lualine")
lualine.setup {
  options = {
    theme = 'ayu',
    component_separators = '|',
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
    lualine_b = { 'filename', 'branch' },
    lualine_c = { 'fileformat' },
    lualine_x = {},
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {{ navic.get_location, cond = navic.is_available }},
    lualine_x = {'%f'},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {'%f'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {'neo-tree'},
}
