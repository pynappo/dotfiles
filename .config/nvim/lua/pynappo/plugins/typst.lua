return {
  {
    'chomosuke/typst-preview.nvim',
    version = '0.1.*',
    build = function() require('typst-preview').update() end,
    opts = {
      debug = false,
    },
  },
}
