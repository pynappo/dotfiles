return {
  {
    'yochem/typst-preview.nvim',
    branch = 'ftplugin',
    enabled = not require('pynappo.utils').is_windows,
    config = function() require('typst-preview').setup() end,
  },
}
