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
    lualine_c = {
      {
        'lsp_progress',
        separators = {
          component = ' ',
          progress = ' | ',
          message = { pre = '(', post = ')' },
          percentage = { pre = '', post = '%% ' },
          title = { pre = '', post = ': ' },
          lsp_client_name = { pre = '[', post = ']' },
          spinner = { pre = '', post = '' },
        },
        display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
        timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
        spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
        message = { commenced = 'In Progress', completed = 'Completed' },
        max_message_length = 30,
      }
    },
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
    lualine_c = {{ navic.get_location, cond = navic.is_available }},
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
