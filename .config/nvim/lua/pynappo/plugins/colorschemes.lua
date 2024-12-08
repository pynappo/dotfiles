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
            -- WinSeparator = { link = 'VertSplit' },
            FloatBorder = { fg = colors.comment, bg = colors.bg },
            TelescopePromptBorder = { fg = colors.accent, bg = colors.bg },
            ['@lsp.mod.strong'] = { bold = true },
            ['@lsp.mod.emph'] = { italic = true },
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

  -- {
  --   'tadaa/vimade',
  --   -- default opts (you can partially set these or configure them however you like)
  --   opts = {
  --     -- Recipe can be any of 'default', 'minimalist', 'duo', and 'ripple'
  --     -- Set animate = true to enable animations on any recipe.
  --     -- See the docs for other config options.
  --     recipe = { 'ripple', { animate = false } },
  --     tint = { bg = { rgb = { 0, 0, 0 }, intensity = 0.1 } },
  --     -- recipe = { 'default', { animate = false } },
  --     -- ncmode = 'buffers', -- use 'windows' to fade inactive windows
  --     -- fadelevel = 0.4, -- any value between 0 and 1. 0 is hidden and 1 is opaque.
  --     -- tint = {
  --     --   -- bg = {rgb={0,0,0}, intensity=0.3}, -- adds 30% black to background
  --     --   -- fg = {rgb={0,0,255}, intensity=0.3}, -- adds 30% blue to foreground
  --     --   -- fg = {rgb={120,120,120}, intensity=1}, -- all text will be gray
  --     --   -- sp = {rgb={255,0,0}, intensity=0.5}, -- adds 50% red to special characters
  --     --   -- you can also use functions for tint or any value part in the tint object
  --     --   -- to create window-specific configurations
  --     --   -- see the `Tinting` section of the README for more details.
  --     -- },
  --
  --     -- Changes the real or theoretical background color. basebg can be used to give
  --     -- transparent terminals accurating dimming.  See the 'Preparing a transparent terminal'
  --     -- section in the README.md for more info.
  --     -- basebg = [23,23,23],
  --     basebg = '',
  --
  --     -- prevent a window or buffer from being styled. You
  --     blocklist = {
  --       default = {
  --         buf_opts = { buftype = { 'prompt', 'terminal' } },
  --         win_config = { relative = true },
  --         -- buf_name = {'name1','name2', name3'},
  --         -- buf_vars = { variable = {'match1', 'match2'} },
  --         -- win_opts = { option = {'match1', 'match2' } },
  --         -- win_vars = { variable = {'match1', 'match2'} },
  --       },
  --       -- any_rule_name1 = {
  --       --   buf_opts = {}
  --       -- },
  --       -- only_behind_float_windows = {
  --       --   buf_opts = function(win, current)
  --       --     if (win.win_config.relative == '')
  --       --       and (current and current.win_config.relative ~= '') then
  --       --         return false
  --       --     end
  --       --     return true
  --       --   end
  --       -- },
  --     },
  --     -- Link connects windows so that they style or unstyle together.
  --     -- Properties are matched against the active window. Same format as blocklist above
  --     link = {},
  --     groupdiff = true, -- links diffs so that they style together
  --     groupscrollbind = true, -- link scrollbound windows so that they style together.
  --
  --     -- enable to bind to FocusGained and FocusLost events. This allows fading inactive
  --     -- tmux panes.
  --     enablefocusfading = false,
  --
  --     -- when nohlcheck is disabled the highlight tree will always be recomputed. You may
  --     -- want to disable this if you have a plugin that creates dynamic highlights in
  --     -- inactive windows. 99% of the time you shouldn't need to change this value.
  --     nohlcheck = true,
  --   },
  --   config = function(_, opts) require('vimade').setup(opts) end,
  -- },
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
    config = function(_, opts) require('tint').setup(opts) end,
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
