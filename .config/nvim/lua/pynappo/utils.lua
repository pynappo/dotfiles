local utils = {}
local g = vim.g
utils.is_windows = vim.fn.has('win32') == 1
utils.is_termux = vim.env.TERMUX_VERSION
utils.is_gui = g.started_by_firenvim or g.neovim or g.gonvim_running
utils.config_home = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")
-- considers empty string and 0 falsy
function utils.truthy(object)
  local conditions = {object, {
    __index = function(table, key)
      return object
    end
  }}
  conditions.string = function(s) return #s ~= 0 end
  conditions.number = function(n) return n ~= 0 end
  return conditions[type(object)](object) and object
end

function utils.color_num_to_hex(num) return ("#%06x"):format(num) end
function utils.nvim_get_hl_hex(ns_id, opts)
  local hl = vim.api.nvim_get_hl(ns_id, opts)
  for _, key in ipairs({'fg', 'bg', 'sp'}) do
    hl[key] = hl[key] and utils.color_num_to_hex(hl[key])
  end
  return hl
end

local open_handlers = {
  -- deal with 
  function(path)

  end,
  vim.ui.open,
}

-- A custom version of vim.ui.open
function utils.open(path)
  for _, handler in open_handlers do
    local res, err = handler(path)
    if err then break end
    if res then return res end
  end
  return nil, vim.print("custom ui.open: no handler worked")
end

return utils
