local ts = require('telescope')
ts.setup {
  defaults = {
    path_display = {"smart"}
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown { }
    },
    file_browser = {
      hijack_netrw = true,
    }
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
  }
}
ts.load_extension("fzf")
ts.load_extension("file_browser")
ts.load_extension("notify")
ts.load_extension("undo")
ts.load_extension("ui-select")
