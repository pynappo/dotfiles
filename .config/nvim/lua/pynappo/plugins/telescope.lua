return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'debugloop/telescope-undo.nvim',
  },
  config = function()
    local ts = require('telescope')

    ts.setup({
      defaults = {
        path_display = { 'smart' },
        layout_strategy = 'flex',
        layout_config = {
          prompt_position = 'top',
        },
        file_ignore_patterns = { 'vendor/*' },
        mappings = {
          n = {
            ['dd'] = 'delete_buffer',
          },
        },
      },
      pickers = {},
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown({}),
        },
        file_browser = {
          hijack_netrw = false,
        },
      },
    })
    local extensions = {
      'fzf',
      'notify',
      'undo',
      'yank_history',
    }
    for _, e in pairs(extensions) do
      ts.load_extension(e)
    end
  end,
  keys = require('pynappo.keymaps').setup.telescope({ lazy = true }),
}
