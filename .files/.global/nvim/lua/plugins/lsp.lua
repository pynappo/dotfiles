local lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
lsp.sumneko_lua.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
            completion = { enable = true, callSnippet = "Both" },
            diagnostics = {
                enable = true,
                globals = { 'vim', 'describe' },
                disable = { "lowercase-global" }
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    [vim.fn.expand('/usr/share/awesome/lib')] = true
                },
                maxPreload = 2000,
                preloadFileSize = 1000
            }
        }
    },
    on_attach = on_attach_common
})
