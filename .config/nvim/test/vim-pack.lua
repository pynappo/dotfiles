vim.pack.add({
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3'),
  },
  -- dependencies
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  -- optional, but recommended
  'https://github.com/nvim-tree/nvim-web-devicons',
})
