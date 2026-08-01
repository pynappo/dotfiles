---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Both',
      },
      globals = {
        'stacktrace',
      },
      hint = {
        enable = true,
        arrayIndex = 'Disable',
      },
      telemetry = {
        enable = true,
      },
    },
  },
}
