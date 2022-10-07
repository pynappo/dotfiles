require('mason-lspconfig').setup({
  ensure_installed = { "sumneko_lua", "html", "jdtls", "jsonls", "ltex", "powershell_es", "pylsp", "theme_check", "zls", "csharp_ls", "rust_analyzer", "gopls"},
  automatic_installation = true
})
local navic = require("nvim-navic")
local lspconfig = require('lspconfig')

require('pynappo/keymaps').setup('diagnostics')
local on_attach_keymaps = require('pynappo/keymaps').lsp.on_attach
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  for _, map in pairs(on_attach_keymaps) do
    vim.api.nvim_buf_set_keymap(bufnr, map[1], map[2], map[3], {silent = true})
  end
  navic.attach(client, bufnr)
end
local flags = {
  debounce_text_changes = 200
}

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
for _, dir in pairs({ "html", "jdtls", "jsonls", "ltex", "powershell_es", "pylsp", "theme_check", "zls", "csharp_ls", "rust_analyzer", "gopls" }) do
  lspconfig[dir].setup ({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = flags
  })
end

local luadev = require("lua-dev").setup({
  lspconfig = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = flags,
  },
})

lspconfig['sumneko_lua'].setup(luadev)
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.completion.spell.with({
      filetypes = { 'markdown', 'text' },
    }),
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.hover.dictionary,
    null_ls.builtins.hover.printenv,
    null_ls.builtins.formatting.codespell
  },
})
