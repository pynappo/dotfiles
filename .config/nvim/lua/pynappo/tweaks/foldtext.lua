local api, v = vim.api, vim.v

local buf_get_lines = api.nvim_buf_get_lines
local get_buf = api.nvim_get_current_buf

local function get_line(bufnr, lnum) return buf_get_lines(bufnr, lnum - 1, lnum, false)[1] end
return function()
  local bufnr = get_buf()
  local foldstart = v.foldstart
  local foldend = v.foldend
  if foldstart == foldend then return get_line(foldstart) end
  local start_line = get_line(bufnr, foldstart)
  local end_line = vim.trim(get_line(bufnr, foldend))
  return {
    { ('%s '):format(start_line), 'Folded' },
    { ('... %s lines ...'):format(foldend - foldstart), 'LspInlayHint' },
    { (' %s'):format(end_line), 'Folded' },
  }
end
