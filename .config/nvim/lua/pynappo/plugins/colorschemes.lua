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
            LineNr = { fg = "#555555"},
            Search = { underline = true },
            NormalNC = { link = 'Normal' },
            WinBar = { bg = colors.bg },
            WinBarNC = { bg = colors.bg },
            MsgArea = { link = 'NormalFloat' }
          }
        end,
      })
    end
  },
  {
    'catppuccin/nvim',
    enabled = true,
    as = "catppuccin"
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
    'uga-rosa/ccc.nvim',
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        mode = "fg"
      }
    }
  },
}
