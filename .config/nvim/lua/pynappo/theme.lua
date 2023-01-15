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
end
return theme
