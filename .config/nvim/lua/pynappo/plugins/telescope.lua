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
      playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
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
