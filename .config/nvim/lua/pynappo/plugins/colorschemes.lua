return {
  {
    'Shatur/neovim-ayu',
    priority = 1000,
    config = function()
      local colors = require('ayu.colors')
      local mirage = true
      colors.generate(mirage)
      require('ayu').setup({
        mirage = mirage,
        overrides = function()
          print('returning')
          return {
            WinBar = { link = 'TabLine' },
            Wildmenu = { bg = colors.bg, fg = colors.markup },
            Comment = { fg = colors.fg_idle, italic = true },
            Search = { underline = true },
            LineNr = { fg = colors.fg_idle },
            dropbar = { link = 'WinBar' },
            NormalNC = { link = 'Normal' }
          }
        end,
      })
    end
  },
  {
    'levouh/tint.nvim',
    opts = {
      saturation = 0.8,
      tint = -20,
      tint_background_colors = true,
      highlight_ignore_patterns = {
        "WinSeparator",
        "Status.*",
        "Normal.*",
        ".*CursorLine",
        "Dropbar.*",
        "Color.*",
        "WinBar"
      },
      window_ignore_function = function(winid)
        local buftype = vim.api.nvim_get_option_value('buftype', {buf = vim.api.nvim_win_get_buf(winid)})
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

        -- Do not tint `terminal` or floating windows, tint everything else
        return vim.tbl_contains({"terminal", "nofile"}, buftype) or floating
      end
    },
  },
  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
    end,
  }
}
