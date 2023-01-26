return {
  {
    'Shatur/neovim-ayu',
    priority = 100,
    config = function()
      local colors = require('ayu.colors')
      local mirage = true
      colors.generate(mirage)
      require('ayu').setup({
        mirage = mirage,
        overrides = {
          Wildmenu = { bg = colors.bg, fg = colors.markup },
          Comment = { fg = colors.fg_idle, italic = true },
          Search = { bg = '', underline = true },
          LineNr = { fg = colors.fg_idle },
        },
      })
    end,
  },
}
