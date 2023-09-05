local theme = {}

local transparent_highlights = {
  'Normal',
  'NormalNC',
  'LineNr',
  'Folded',
  'NonText',
  'SpecialKey',
  'VertSplit',
  'SignColumn',
  'EndOfBuffer',
  'TablineFill',
}

local OverrideTable = {
  vim_highlights = {},
  nvim_highlights = {},
  links = {},
  functions = {}
}
function OverrideTable:new()
  local object = {
    vim_highlights = setmetatable({}, {
      __newindex = function (t, k, v)
        vim.cmd.highlight(k .. ' ' .. v)
        rawset(t,k,v)
      end
    }),
    nvim_highlights = setmetatable({}, {
      __newindex = function (t, k, v)
        vim.api.nvim_set_hl(0, k, v)
        rawset(t,k,v)
      end
    }),
    links = setmetatable({}, {
      __newindex = function (t, k, v)
        vim.cmd('highlight! link ' .. k .. ' ' .. v)
        rawset(t,k,v)
      end
    }),
    functions = setmetatable({}, {
      __newindex = function (t, k, v)
        v()
        rawset(t,k,v)
      end
    })
  }

  setmetatable(object, self)
  self.__index = self
  return object
end

function OverrideTable.apply(self)
  for _, table in pairs(self) do
    if type(table) == 'table' then
      local newindex_func = getmetatable(table).__newindex
      for key, value in pairs(table) do newindex_func(table, key, value) end
    end
  end
end

theme.overrides = {
  all_themes = OverrideTable:new()
}
setmetatable(theme.overrides, {
  __index = function (t, k)
    rawset(t, k, OverrideTable:new())
    return t[k]
  end
})

local g = vim.g
if not require('pynappo.utils').is_gui then
  for _, hl in ipairs(transparent_highlights) do theme.overrides.all_themes.vim_highlights[hl] = 'guibg=NONE ctermbg=NONE' end
end

function theme.set_rainbow_colors(prefix, colors)
  local hl_names = {}
  for _, color in ipairs(colors) do
    local name = color[1]
    local hex = color[2]
    local hl_name = prefix .. name
    table.insert(hl_names, hl_name)
    vim.api.nvim_set_hl(0, hl_name, {fg = hex})
    theme.overrides.all_themes.nvim_highlights[hl_name] = { fg = hex, nocombine = true }
  end
  return hl_names
end

return theme
