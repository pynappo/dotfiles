require('mason-lspconfig').setup({
  ensure_installed = { "sumneko_lua", "html", "jdtls", "jsonls", "ltex", "powershell_es", "pylsp", "theme_check", "zls", "csharp_ls", "rust_analyzer" },
})
local navic = require("nvim-navic")
local lspconfig = require('lspconfig')
local map = vim.api.nvim_set_keymap
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
map("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
map("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local bufmap = vim.api.nvim_buf_set_keymap
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  bufmap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  bufmap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  bufmap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  bufmap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  bufmap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  bufmap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  bufmap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  bufmap(bufnr, "n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  bufmap(bufnr, "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  bufmap(bufnr, "n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  bufmap(bufnr, "n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  bufmap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  bufmap(bufnr, "n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  navic.attach(client, bufnr)
end
local flags = {
  allow_incremental_sync = false,
  debounce_text_changes = 300
}

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches

for _, dir in pairs({ "html", "jdtls", "jsonls", "ltex", "powershell_es", "pylsp", "theme_check", "zls", "csharp_ls", "rust_analyzer" }) do
  lspconfig[dir].setup ({
    on_attach = on_attach,
    flags = flags
  })
end

local luadev = require("lua-dev").setup({
  lspconfig = {
    on_attach = on_attach,
    flags = flags,
  },
})
lspconfig['sumneko_lua'].setup(luadev)
local nullls = require('null-ls')
nullls.setup({
  sources = {
    nullls.builtins.formatting.stylua,
    nullls.builtins.diagnostics.eslint,
    nullls.builtins.completion.spell,
  },
})