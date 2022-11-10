return {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    for _, map in pairs(require('pynappo/keymaps').lsp.on_attach) do
      vim.api.nvim_buf_set_keymap(bufnr, map[1], map[2], map[3], {silent = true})
    end
    require('nvim-navic').attach(client, bufnr)
  end,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  flags = {debounce_text_changes = 200}
}

