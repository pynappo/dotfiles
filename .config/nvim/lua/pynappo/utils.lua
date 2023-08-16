local utils = {}
utils.is_windows = vim.fn.has('win32') == 1
utils.is_termux = vim.env.TERMUX_VERSION
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
return utils
