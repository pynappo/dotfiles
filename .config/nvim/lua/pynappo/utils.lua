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

utils.repourl = {
  github = function(repo) return 'https://github.com/' .. repo end,
  gitlab = function(repo) return 'https://gitlab.com/' .. repo end,
  codeberg = function(repo) return 'https://codeberg.com/' .. repo end,
}

local devdir = vim.fn.expand('~/Projects/code/nvim')
---vim.pack.add but prefers local development versions of plugins found under the directory configured above.
---@param specs (string|vim.pack.Spec)[]
---@param opts vim.pack.keyset.add?
function utils.packadddev(specs, opts)
  local specs_from_remotes = {}
  for _, spec in ipairs(specs) do
    if type(spec) == 'string' then spec = { src = spec } end
    local name = spec.name or spec.src:match('([^/]+)$')
    assert(name, 'could not determine name for ' .. spec.src)
    local devpath = vim.fs.joinpath(devdir, name)
    if vim.uv.fs_stat(devpath) then
      vim.opt.runtimepath:prepend(devpath)
    else
      specs_from_remotes[#specs_from_remotes + 1] = spec
    end
  end
  vim.pack.add(specs_from_remotes, opts)
end

return utils
