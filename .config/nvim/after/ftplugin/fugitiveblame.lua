vim.wo[0][0].cursorbind = true
vim.schedule(function()
  vim.cmd.wincmd('p')
  vim.wo[0][0].cursorbind = true
end)
