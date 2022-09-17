require('toggleterm').setup {
  open_mapping = require("pynappo/keymaps").toggleterm.open_mapping,
  winbar = {
    enabled = true,
    name_formatter = function(term) --  term: Terminal
      return term.name
    end
  },
}
