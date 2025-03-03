local utils = {}
local g = vim.g
utils.is_windows = vim.fn.has('win32') == 1
utils.is_termux = vim.env.TERMUX_VERSION or false
utils.is_firenvim = g.started_by_firenvim or false
utils.is_goneovim = g.gonvim_running or false
utils.is_gui = utils.is_firenvim or utils.is_goneovim
utils.config_home = vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. '/.config')
-- considers empty string and 0 falsy
local conditions = {}
---@type fun(s: string): boolean
conditions.string = function(s)
  local not_whitespace_only = s:find('[^%s%c]')
  return not_whitespace_only ~= nil
end
conditions.number = function(n) return n ~= 0 end
function utils.truthy(object)
  if object == nil then return nil end
  return conditions[type(object)](object) and object
end

function utils.color_num_to_hex(num) return ('#%06x'):format(num) end
function utils.nvim_get_hl_hex(ns_id, opts)
  local hl = vim.api.nvim_get_hl(ns_id, opts)
  for _, key in ipairs({ 'fg', 'bg', 'sp' }) do
    hl[key] = hl[key] and utils.color_num_to_hex(hl[key])
  end
  return hl
end

local open_handlers = {
  function(path) end,
  vim.ui.open,
}

-- A custom version of vim.ui.open
function utils.open(path)
  for _, handler in open_handlers do
    local res, err = handler(path)
    if err then break end
    if res then return res end
  end
  return nil, vim.print('custom ui.open: no handler worked')
end

utils.lazy = {
  --- Require on index.
  ---
  --- Will only require the module after the first index of a module.
  --- Only works for modules that export a table.
  require_on_index = function(require_path)
    return setmetatable({}, {
      __index = function(_, key) return require(require_path)[key] end,

      __newindex = function(_, key, value) require(require_path)[key] = value end,
    })
  end,

  --- Requires only when you call the _module_ itself.
  ---
  --- If you want to require an exported value from the module,
  --- see instead |lazy.require_on_exported_call()|
  require_on_module_call = function(require_path)
    return setmetatable({}, {
      __call = function(_, ...) return require(require_path)(...) end,
    })
  end,

  --- Require when an exported method is called.
  ---
  --- Creates a new function. Cannot be used to compare functions,
  --- set new values, etc. Only useful for waiting to do the require until you actually
  --- call the code.
  ---
  --- <pre>
  --- -- This is not loaded yet
  --- local lazy_mod = lazy.require_on_exported_call('my_module')
  --- local lazy_func = lazy_mod.exported_func
  ---
  --- -- ... some time later
  --- lazy_func(42)  -- <- Only loads the module now
  ---
  --- </pre>
  require_on_exported_call = function(require_path)
    return setmetatable({}, {
      __index = function(_, k)
        return function(...) return require(require_path)[k](...) end
      end,
    })
  end,
}

return utils
