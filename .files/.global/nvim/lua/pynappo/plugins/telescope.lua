require("telescope").setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    },
    file_browser = {
      theme = "ayu",
    }
  }
}
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
