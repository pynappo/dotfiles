vim.keymap.set('n', '<CR>', function()
  print('hi')
  if not pcall(vim.cmd.normal, 'gf') then vim.cmd.normal('<CR>') end
end)
