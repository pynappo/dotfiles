
local ts = require('telescope')
local ts_actions = require('telescope.actions')
ts.setup {
  defaults = {
    path_display = {"smart"}
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    },
    file_browser = {
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<esc>"] = ts_actions.close,
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    }
  }
}
ts.load_extension("fzf")
ts.load_extension("ui-select")
ts.load_extension("file_browser")
