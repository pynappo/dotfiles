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

if not vim.g.started_by_firenvim then
  for _, hl in ipairs(transparent_highlights) do theme.overrides.all_themes.vim_highlights[hl] = 'guibg=NONE ctermbg=NONE' end
end

function theme.set_rainbow_colors(prefix, suffix_colors)
  local hl_list = {}
  for suffix, color in pairs(suffix_colors) do hl_list[suffix] = { prefix .. suffix  , color} end
  for _, hl in pairs(hl_list) do theme.overrides.all_themes.nvim_highlights[hl[1]] = { fg = hl[2], nocombine = true } end
  return hl_list
end

return theme
