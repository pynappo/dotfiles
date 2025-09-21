return {
  {
    'yochem/typst-preview.nvim',
    branch = 'ftplugin',
    config = function() require('typst-preview').setup() end,
  },
}
