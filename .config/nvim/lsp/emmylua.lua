---@type vim.lsp.Config
return {
  cmd = { 'emmylua-ls' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.emmyrc.json',
  },
}
