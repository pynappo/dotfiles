local function unique(table)
  local unique = {}
  local count = 0
  for k, v in ipairs(table) do
    if not unique[v] then
      unique[v] = true
      count = count + 1
    end
  end
  return unique, count
end
local function diff_entries(t1, t2)
  local u1, u2 = (unique(t1)), (unique(t2))
  local diff = {}
  for k, _ in pairs(u1) do
    if not u2[k] then diff[k] = 1 end
  end
  for k, _ in pairs(u2) do
    if not u1[k] then diff[k] = 2 end
  end
  return diff
end

local library = vim.deepcopy(vim.lsp.get_clients()[1].config.settings.Lua.workspace.library)
local rtp_lua = vim.api.nvim_get_runtime_file('lua', true)
local rtp = vim.api.nvim_get_runtime_file('', true)
local rtp_filter = vim.tbl_filter(function(str) return str:find('block') end, vim.api.nvim_get_runtime_file('', true))

vim.print(diff_entries(neodev, library))
