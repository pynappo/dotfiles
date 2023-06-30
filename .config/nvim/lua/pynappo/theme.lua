-- A file containing theme commands and various color utilities
local theme = {}
local highlights = {
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
function theme.transparent_override()
  for _, hl in ipairs(highlights) do vim.cmd.highlight(hl .. ' guibg=NONE ctermbg=NONE') end
  local ok, tint = pcall(require, 'tint')
  if not ok then return end
  tint.refresh()
end
function theme.set_rainbow_colors(prefix, suffix_colors, desc)
  local hl_list = {}
  for suffix, color in pairs(suffix_colors) do hl_list[suffix] = { prefix .. suffix  , color} end
  local function set_highlights()
    for _, hl in pairs(hl_list) do vim.api.nvim_set_hl(0, hl[1], { fg = hl[2], nocombine = true }) end
    vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg='#777777', bold = true, nocombine = true })
  end
  set_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', { callback = set_highlights, desc = desc })
  return hl_list
end
return theme
