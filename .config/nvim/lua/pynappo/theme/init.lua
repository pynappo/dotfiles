local theme = {}

---@class pynappo.theme.Overrides
local Overrides = {}

function Overrides:new()
  ---@class pynappo.theme.Overrides
  local object = {
    ---@type table<string, string>
    vim_highlights = {},
    ---@type table<string, vim.api.keyset.highlight>
    nvim_highlights = {},
    ---@type table<string, string>
    links = {},
    ---@type table<string, function>
    functions = {},
  }

  setmetatable(object, self)
  setmetatable(object.vim_highlights, {
    __newindex = function(t, k, v)
      vim.cmd.highlight(k .. ' ' .. v)
      rawset(t, k, v)
    end,
  })
  setmetatable(object.nvim_highlights, {
    __newindex = function(t, k, v)
      vim.api.nvim_set_hl(0, k, v)
      rawset(t, k, v)
    end,
  })
  setmetatable(object.links, {
    __newindex = function(t, k, v)
      vim.cmd('highlight! link ' .. k .. ' ' .. v)
      rawset(t, k, v)
    end,
  })
  setmetatable(object.functions, {
    __newindex = function(t, k, v)
      v()
      rawset(t, k, v)
    end,
  })
  self.__index = self
  return object
end

function Overrides.apply(self)
  for _, table in pairs(self) do
    if type(table) == 'table' then
      local newindex_func = getmetatable(table).__newindex
      for key, value in pairs(table) do
        newindex_func(table, key, value)
      end
    end
  end
end

theme.overrides = {
  all = Overrides:new(),
}
setmetatable(theme.overrides, {
  __index = function(t, k)
    rawset(t, k, Overrides:new())
    return t[k]
  end,
})

local transparent_highlights = {
  'Normal',
  'NormalNC',
  'LineNr',
  'Folded',
  'NonText',
  'SpecialKey',
  'VertSplit',
  'SignColumn',
  'FoldColumn',
  'EndOfBuffer',
  'TablineFill',
}

local utils = require('pynappo.utils')
if not utils.is_gui and not utils.is_termux then
  for _, hl in ipairs(transparent_highlights) do
    theme.overrides.all.vim_highlights[hl] = 'guibg=NONE ctermbg=NONE'
  end
end
theme.overrides.all.nvim_highlights.DiagnosticUnnecessary = {}
function theme.set_rainbow_colors(prefix, colors)
  local hl_names = {}
  for _, color in ipairs(colors) do
    local name = color[1]
    local hex = color[2]
    local hl_name = prefix .. name
    table.insert(hl_names, hl_name)
    vim.api.nvim_set_hl(0, hl_name, { fg = hex })
    theme.overrides.all.nvim_highlights[hl_name] = { fg = hex, nocombine = true }
  end
  return hl_names
end

return theme
