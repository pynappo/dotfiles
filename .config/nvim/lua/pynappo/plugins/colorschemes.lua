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
        overrides = function()
          return {
            WildMenu = { bg = colors.bg, fg = colors.markup },
            Comment = { fg = colors.fg_idle, italic = true },
            Search = { underline = true },
            NormalNC = { link = 'Normal' },
            WinBar = { bg = colors.panel_shadow },
            WinBarNC = { bg = colors.panel_shadow },
          }
        end,
      })
    end
  },
  {
    'catppuccin/nvim',
    enabled = false
  },
  {
    'levouh/tint.nvim',
    priority = 1000,
    enabled = true,
    opts = {
      saturation = 0.8,
      tint = -20,
      tint_background_colors = false,
      highlight_ignore_patterns = {
        "WinSeparator",
        "Status.*",
        "Normal.*",
        "CursorLine",
        "Dropbar",
        "Color",
        "WinBar"
      },
      window_ignore_function = function(winid)
        local buftype = vim.api.nvim_get_option_value('buftype', {buf = vim.api.nvim_win_get_buf(winid)})
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
        return vim.tbl_contains({"terminal", "nofile"}, buftype) or floating
      end
    },
    config = function(_, opts)
      require('tint').setup(opts)
      require('pynappo.autocmds').setup_overrides()
    end
  },
  {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = true
  },
  {
    'uga-rosa/ccc.nvim',
  }
}
