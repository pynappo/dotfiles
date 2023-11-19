-- install lazy.nvim, a plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                'git',
                'clone',
                '--filter=blob:none',
                'https://github.com/folke/lazy.nvim.git',
                '--branch=stable', -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

-- some settings
vim.cmd.colorscheme('habamax')
local o = vim.o
local opt = vim.opt
o.smartcase = true
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true
o.timeoutlen = 2000
o.list = true
opt.listchars = {
        lead = '.',
        eol = '󱞣'
}

-- setup plugins
vim.keymap.set('n', '<leader>h', function() vim.print('hi') end)
require('lazy').setup({
        {
                'neovim/nvim-lspconfig',
                dependencies = {
                        {
                                'williamboman/mason-lspconfig.nvim',
                                dependencies = { 'williamboman/mason.nvim' },
                        },
                },
                config = function()
                        require('mason-lspconfig').setup({
                                ensure_installed = {
                                        'lua_ls',
                                },
                                handlers = {
                                        function(ls) require('lspconfig')[ls].setup({}) end,
                                },
                        })
                end,
        },
        {
                'williamboman/mason.nvim',
                opts = { ui = { border = 'single' } },
        },
        {
                "stevearc/conform.nvim",
                dependencies = {
                        { "neovim/nvim-lspconfig" },
                        { "nvim-lua/plenary.nvim" },
                        { "williamboman/mason.nvim" },
                },
                event = { "BufWritePre" },
                cmd = { "ConformInfo" },
                config = function()
                        vim.api.nvim_create_user_command("FormatDisable", function(args)
                                if args.bang then
                                        -- FormatDisable! will disable formatting just for this buffer
                                        vim.b.disable_autoformat = true
                                else
                                        vim.g.disable_autoformat = true
                                end
                        end, {
                                desc = "Disable autoformat-on-save",
                                bang = true,
                        })

                        vim.api.nvim_create_user_command("FormatEnable", function()
                                vim.b.disable_autoformat = false
                                vim.g.disable_autoformat = false
                        end, {
                                desc = "Re-enable autoformat-on-save",
                        })

                        require("conform").setup {
                                format_on_save = function(bufnr)
                                        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                                                return
                                        end
                                        return { timeout_ms = 3000, lsp_fallback = true }
                                end,
                                formatters_by_ft = {
                                        bash = { "shfmt" },
                                        sh = { "shfmt" },
                                        fish = { "fish_indent" },
                                        lua = { "stylua" },
                                        go = { "goimports", "gofumpt", "goimports-reviser" },
                                        javascript = { { "prettierd", "prettier" } },
                                        typescript = { { "prettierd", "prettier" } },
                                        javascriptreact = { { "prettierd", "prettier" } },
                                        typescriptreact = { { "prettierd", "prettier" } },
                                        vue = { { "prettierd", "prettier" } },
                                        css = { { "prettierd", "prettier" } },
                                        scss = { { "prettierd", "prettier" } },
                                        less = { { "prettierd", "prettier" } },
                                        html = { { "prettierd", "prettier" } },
                                        json = { { "prettierd", "prettier" } },
                                        jsonc = { { "prettierd", "prettier" } },
                                        yaml = { { "prettierd", "prettier" } },
                                        markdown = { { "prettierd", "prettier" } },
                                        ["markdown.mdx"] = { { "prettierd", "prettier" } },
                                        graphql = { { "prettierd", "prettier" } },
                                        handlebars = { { "prettierd", "prettier" } },
                                },
                        }
                end,
        }
})
