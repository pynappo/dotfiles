vim.env.LAZY_STDPATH = '.repro'
load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()

require('lazy.minit').repro({
  spec = {
    'neovim/nvim-lspconfig',
  },
})

vim.lsp.config('lua_ls', {})
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      hint = { enable = true },
    },
  },
})

vim.lsp.enable('lua_ls')

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function() vim.lsp.inlay_hint.enable() end,
})

---@param b string
local a = function(b) -- this will show an inlay hint
end
