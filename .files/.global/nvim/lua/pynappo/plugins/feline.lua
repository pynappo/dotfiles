local feline = require("feline")
local navic = require("nvim-navic")
feline.setup()

local components = {
  active = {},
  inactive = {}
}
table.insert(components.active, {})
table.insert(components.active[1], {
  provider = function()
    return navic.get_location()
  end,
  enabled = function()
    return navic.is_available()
  end
})
if vim.g.started_by_firenvim then feline.winbar.setup({components = components}) end
