local config = require('nvim-surround.config')
require('nvim-surround').setup({
  surrounds = {
    ['c'] = {
      add = function()
        local prepend = config.get_input("String to prepend")
        local append = config.get_input("String to append")
        if append and prepend then return {prepend, append} end
      end
    }
  }
})

