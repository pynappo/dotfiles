require('pynappo/keymaps').setup_telescope()
local ts = require('telescope')
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
    }
  }
}
ts.load_extension("fzf")
ts.load_extension("ui-select")
ts.load_extension("file_browser")
ts.load_extension("notify")
