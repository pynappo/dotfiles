---@type vim.lsp.Config
return {
  cmd = require('pynappo.utils').is_windows and { 'ncat', '127.0.0.1', '6005' }
    or vim.lsp.rpc.connect('127.0.0.1', 6005),
}
