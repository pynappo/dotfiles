local modules = { 'plugins', 'keymaps' }

for _, module in ipairs(modules) do
   local ok, err = pcall(require, module)
   if not ok then
    error("Error loading " .. module .. "\n\n" .. err)
   end
end

-- Make line numbers default
vim.wo.relativenumber = true
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Tabs
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Misc
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
vim.opt.whichwrap:append "<>[]hl"
vim.o.completeopt = 'menuone,noselect'
vim.o.breakindent = true
vim.opt.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Colors
vim.o.termguicolors = true
require('ayu').colorscheme()

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
