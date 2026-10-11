-- Convert HTML into Typst. Runs pandoc first, then applies local revisions:
--   * unwraps redundant #block[ ... ] containers
--   * rewrites #strong[..] to **..**
--   * renders ordered lists as an enum block numbered a. b. c.
local M = {}

-- ------------------------------- pandoc ----------------------------------

local function shell_quote(s)
  return "'" .. s:gsub("'", "'\\''") .. "'"
end

-- pandoc reads the HTML from a temp file because jobstart has no stdin.
local function pandoc_typst(html, extra)
  local tmp = os.tmpname()
  local f = assert(io.open(tmp, "w"))
  f:write(html)
  f:close()

  local cmd = "pandoc -f html -t typst --wrap=none"
    .. " -o /dev/stdout " .. shell_quote(tmp)
  for _, arg in ipairs(extra or {}) do
    cmd = cmd .. " " .. shell_quote(arg)
  end

  local id, err = maki.fn.jobstart(cmd)
  if not id then
    os.remove(tmp)
    return nil, "could not start pandoc: " .. (err or "unknown error")
  end

  local res, werr = maki.fn.jobwait(id, 30000)
  os.remove(tmp)
  if not res then
    return nil, "pandoc failed: " .. (werr or "timeout")
  end
  if res.exit_code ~= 0 then
    return nil, "pandoc exited " .. res.exit_code .. ": " .. (res.stderr or "")
  end
  return res.stdout or "", nil
end

-- --------------------------- revision passes -----------------------------

local function split_lines(s)
  local lines = {}
  for line in (s .. "\n"):gmatch("(.-)\n") do
    lines[#lines + 1] = line
  end
  return lines
end

-- A closer is a line whose first non-space char is "]", possibly with
-- trailing text (pandoc puts the following label on the same line).
local function close_prefix(line)
  local lead, rest = line:match("^(%s*)%](.*)$")
  if not lead then
    return nil
  end
  return lead, rest
end

-- Unwrap "#block[\n ... \n]": drop the opener and the matching closer,
-- repeating until no block wrapper is left.
local function unwrap_once(lines)
  local out = {}
  local i = 1
  local changed = false
  while i <= #lines do
    local stripped = lines[i]:match("^%s*(.-)%s*$")
    if stripped == "#block[" then
      local depth = 1
      local j = i + 1
      while j <= #lines and depth > 0 do
        local opens = select(2, lines[j]:gsub("#block%[", ""))
        depth = depth + opens
        if close_prefix(lines[j]) then
          depth = depth - 1
          if depth == 0 then break end
        end
        j = j + 1
      end
      local lead, tail = close_prefix(lines[j] or "")
      if depth == 0 and lead then
        for k = i + 1, j - 1 do
          out[#out + 1] = lines[k]
        end
        -- trim blank line left before the closer
        if #out > 0 and out[#out]:match("^%s*$") then
          out[#out] = nil
        end
        -- keep anything pandoc put after the closer on the same line
        if tail:match("%S") then
          out[#out + 1] = lead .. tail
        end
        i = j + 1
        changed = true
      else
        out[#out + 1] = lines[i]
        i = i + 1
      end
    else
      out[#out + 1] = lines[i]
      i = i + 1
    end
  end
  return out, changed
end

local function unwrap_blocks(lines)
  local changed = true
  while changed do
    lines, changed = unwrap_once(lines)
  end
  return lines
end

-- Rewrite innermost-first so nested #strong[..[..]..] still convert.
local function rewrite_wrapper(line, name, open, close)
  local pattern = "#" .. name .. "%[([^%[%]]*)%]"
  local replaced = true
  while replaced do
    line, replaced = line:gsub(pattern, open .. "%1" .. close)
    replaced = replaced ~= 0
  end
  return line
end

local function rewrite_strong(lines)
  for i, line in ipairs(lines) do
    lines[i] = rewrite_wrapper(line, "strong", "**", "**")
  end
  return lines
end

local function rewrite_emph(lines)
  for i, line in ipairs(lines) do
    lines[i] = rewrite_wrapper(line, "emph", "_", "_")
  end
  return lines
end

-- Rewrite a plain "+ a / + b / ..." list into an enum block numbered a.
local function rewrite_ordered(lines)
  local out = {}
  local i = 1
  while i <= #lines do
    if lines[i]:match("^%s*%+%s+%S") then
      local indent = lines[i]:match("^(%s*)")
      local items = {}
      local j = i
      while j <= #lines and lines[j]:match("^%s*%+%s+") do
        items[#items + 1] = lines[j]:match("^%s*%+%s+(.*)$")
        j = j + 1
      end
      out[#out + 1] = indent .. "#{"
      out[#out + 1] = indent .. "  set enum(numbering: \"a.\")"
      out[#out + 1] = indent .. "  ["
      for _, item in ipairs(items) do
        out[#out + 1] = indent .. "    + " .. item
      end
      out[#out + 1] = indent .. "  ]"
      out[#out + 1] = indent .. "}"
      i = j
    else
      out[#out + 1] = lines[i]
      i = i + 1
    end
  end
  return out
end

-- Pandoc escapes a leading "." or ")" (e.g. "\1.") so Typst will not read
-- it as a list marker; those escapes are never needed inside our output.
-- Note: an anchor must sit outside any capture in a Lua pattern.
local function strip_list_escapes(lines)
  for i, line in ipairs(lines) do
    local lead, body = line:match("^(%s*%*%*)(.*)$")
    if lead then
      lines[i] = lead .. body:gsub("^\\(%d+[%.%)])", "%1")
    else
      lead, body = line:match("^(%s*)(.*)$")
      lines[i] = lead .. body:gsub("^\\(%d+[%.%)])", "%1")
    end
  end
  return lines
end

--- Apply the local revisions to pandoc's Typst output.
function M.revise(typst)
  local lines = split_lines(typst)
  lines = unwrap_blocks(lines)
  lines = rewrite_strong(lines)
  lines = rewrite_emph(lines)
  lines = rewrite_ordered(lines)
  lines = strip_list_escapes(lines)
  return table.concat(lines, "\n")
end

-- ------------------------------- tool ------------------------------------

maki.api.register_tool({
  name = "html_to_typst",
  description = [[Convert HTML into Typst markup.

Runs `pandoc -f html -t typst` first, then applies these revisions:
- removes redundant `#block[...]` wrappers,
- rewrites `#strong[..]` to `**..**` and `#emph[..]` to `_.._`,
- renders ordered lists as an enum block that numbers items a, b, c.

Use this whenever you need Typst from an HTML snippet or file.]],
  parameters = {
    type = "object",
    properties = {
      input = { type = "string", description = "HTML string to convert." },
      path = { type = "string", description = "Path to an .html file to read instead of `input`." },
      raw = { type = "boolean", description = "Return pandoc output without the revisions." },
    },
  },
  handler = function(args)
    local html = args.input
    if not html and args.path then
      local read_err
      html, read_err = maki.fs.read(args.path)
      if not html then
        return { llm_output = "error: " .. read_err, is_error = true }
      end
    end
    if not html then
      return { llm_output = "error: provide `input` or `path`", is_error = true }
    end

    if args.raw then
      local raw, err = pandoc_typst(html)
      if not raw then
        return { llm_output = "error: " .. err, is_error = true }
      end
      return { llm_output = raw }
    end

    local typst, err = pandoc_typst(html)
    if not typst then
      return { llm_output = "error: " .. err, is_error = true }
    end
    return { llm_output = M.revise(typst) }
  end,
})

return M
