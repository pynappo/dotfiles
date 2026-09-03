local api = vim.api

local buf_get_lines = api.nvim_buf_get_lines
local get_buf = api.nvim_get_current_buf

local function get_line(bufnr, lnum) return buf_get_lines(bufnr, lnum - 1, lnum, false)[1] end

--- Extracts flattened, non-overlapping highlighted segments for a line
---@param bufnr integer 1-based line number
---@param line_num integer 1-based line number
---@return table chunks List of { text, highlight } tuples
local function get_highlighted_line_chunks(bufnr, line_num)
  local line_text = get_line(bufnr, line_num)
  local row = line_num - 1 -- 0-based row index for API
  local line_len = #line_text

  if line_len == 0 then return { { '', 'Folded' } } end

  -- Array mapping each byte index (0 to line_len - 1) to its resolved highlight group
  local col_hls = {}
  for col = 0, line_len - 1 do
    col_hls[col] = 'Folded'
  end

  -- Safely inspect pos using vim.inspect_pos or Tree-sitter captures
  local parser = vim.treesitter.get_parser(bufnr)
  if parser then
    local tree = parser:parse()[1]
    if tree then
      local query = vim.treesitter.query.get(parser:lang(), 'highlights')
      if query then
        -- Process captures; outer/broader nodes appear first,
        -- finer child nodes appear later and overwrite parent highlights
        for id, node, _ in query:iter_captures(tree:root(), bufnr, row, row + 1) do
          local srow, scol, erow, ecol = node:range()

          if srow <= row and erow >= row then
            local c_start = (srow < row) and 0 or scol
            local c_end = (erow > row) and line_len or ecol

            local capture_name = query.captures[id]
            local hl_group = '@' .. capture_name

            -- Overwrite byte range with higher specificity capture
            for col = c_start, math.min(c_end, line_len) - 1 do
              col_hls[col] = hl_group
            end
          end
        end
      end
    end
  end

  -- Group adjacent bytes with the identical highlight group into contiguous chunks
  local chunks = {}
  local curr_text = line_text:sub(1, 1)
  local curr_hl = col_hls[0]

  for col = 1, line_len - 1 do
    local hl = col_hls[col]
    if hl == curr_hl then
      curr_text = curr_text .. line_text:sub(col + 1, col + 1)
    else
      table.insert(chunks, { curr_text, curr_hl })
      curr_text = line_text:sub(col + 1, col + 1)
      curr_hl = hl
    end
  end
  table.insert(chunks, { curr_text, curr_hl })

  return chunks
end
return function()
  local bufnr = get_buf()
  local foldstart = vim.v.foldstart
  local foldend = vim.v.foldend
  local chunks = {}
  local start_chunks = get_highlighted_line_chunks(bufnr, foldstart)
  vim.list_extend(chunks, start_chunks)
  if foldstart < foldend then
    vim.list_extend(chunks, { { (' ... %s lines ... '):format(foldend - foldstart), 'LspInlayHint' } })
    local end_chunks = get_highlighted_line_chunks(bufnr, foldend)
    if end_chunks[1] then end_chunks[1][1] = vim.trim(end_chunks[1][1]) end
    vim.list_extend(chunks, end_chunks)
  end
  local len = 0
  for _, chunk in ipairs(chunks) do
    len = len + #chunk[1]
  end
  local arrow = '<' .. vim.v.folddashes
  vim.list_extend(chunks, { { arrow, 'LspInlayHint' } })
  return chunks
end
