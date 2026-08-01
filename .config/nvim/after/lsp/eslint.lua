---@type vim.lsp.Config
return {
  settings = {
    -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
    workingDirectories = { mode = 'auto' },
  },
}
