local M = {}
local mode_tables = {}

local KeymapTable = {
  keymaps = {},
}
function KeymapTable:new(obj, keymaps)
  local object = obj or {}
  setmetatable(object, self)
  self.__index = self
  self.__tostring = function() return (vim.inspect(self:get_keymaps(true)):gsub([[\n]], '\n')) end
  self.keymaps = keymaps or {}
  return object
end

function KeymapTable:insert(modes, lhs, rhs, opts, function_code)
  local mode_table = type(modes) == 'table' and modes or { modes }
  table.sort(mode_table)
  local mode_string = table.concat(mode_table, '')
  mode_tables[mode_string] = mode_tables[mode_string] or mode_table
  local m = mode_tables[mode_string]
  if not self.keymaps[m] then self.keymaps[m] = {} end
  table.insert(self.keymaps[m], { lhs, rhs, opts, function_code })
end

function KeymapTable:get_keymaps(function_code)
  if not function_code then return self.keymaps end
  local new_keymaps = vim.deepcopy(self.keymaps)
  for modes, mappings in pairs(new_keymaps) do
    new_keymaps[modes] = vim.tbl_map(function(mapping) return { mapping[1], mapping[4], mapping[3] } end, mappings)
  end
  return new_keymaps
end

-- converts vim.keymap.set calls to my keymap format
function M.convert_from_api(from_register, to_register)
  local register_text = vim.fn.getreg(from_register or '+')
  local keymap_table = KeymapTable:new()
  ---@diagnostic disable-next-line: param-type-mismatch
  for args_string in (register_text):gmatch('set(%b())') do
    local args_table = assert(loadstring('return {' .. args_string:sub(2, -2) .. '}'))()
    if type(args_table[3]) == 'function' then args_table[3] = args_string:match('.-,.-,(.-),') end
    keymap_table:insert(unpack(args_table))
  end
  return keymap_table:get_keymaps()
end

-- converts lazy plugin spec to my keymap format
function M.convert_from_lazy(lazy_keys, from_register, to_register)
  local functions, register_text
  if not lazy_keys then
    functions = {}
    for func in register_text:gmatch('(function.-end,)') do
      table.insert(functions, func)
    end
  end
  lazy_keys = lazy_keys or assert(loadstring('return ' .. register_text))()
  local keymap_table = KeymapTable:new()
  for i, keymap in ipairs(lazy_keys) do
    local key = keymap[1]
    local rhs = keymap[2]
    local mode = keymap.mode
    local opts = keymap
    opts[1], opts[2], opts.mode = nil, nil, nil
    keymap_table:insert(mode, key, rhs, opts, (type(rhs) == 'function' and functions[i] or ('function_' .. i)))
  end
  return keymap_table:get_keymaps(true)
end

return M
