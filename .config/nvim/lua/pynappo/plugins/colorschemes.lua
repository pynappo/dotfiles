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
            WildMenu = { bg = colors.ui, fg = colors.fg },
            Comment = { fg = colors.fg_idle, italic = true },
            LspInlayHint = { fg = colors.fg_idle, bg = colors.panel_bg },
            LineNr = { fg = colors.comment },
            Search = { underline = true },
            NormalNC = { link = 'Normal' },
            WinBar = { bg = colors.bg },
            WinBarNC = { bg = colors.bg },
            MsgArea = { link = 'NormalFloat' },
            HlSearchLens = { fg = colors.accent, bg = colors.guide_normal },
            HlSearchLensNear = { fg = colors.string, bg = colors.guide_active },
            WinSeparator = { link = 'VertSplit' },
            FloatBorder = { fg = colors.comment, bg = colors.bg },
            TelescopePromptBorder = { fg = colors.accent, bg = colors.bg },
          }
        end,
      })
    end,
  },
  {
    'catppuccin/nvim',
    enabled = true,
    name = 'catppuccin',
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
        'WinSeparator',
        'Status.*',
        'Normal.*',
        'CursorLine',
        'Dropbar',
        'Color',
        'WinBar',
      },
      window_ignore_function = function(winid)
        local buftype = vim.api.nvim_get_option_value('buftype', { buf = vim.api.nvim_win_get_buf(winid) })
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ''
        return vim.tbl_contains({ 'terminal', 'nofile' }, buftype) or floating
      end,
    },
    config = function(_, opts)
      require('tint').setup(opts)
      require('pynappo.autocmds').setup_overrides()
    end,
  },
  {
    'uga-rosa/ccc.nvim',
    event = 'VeryLazy',
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
        mode = 'fg',
      },
    },
  },
}
