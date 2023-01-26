local keymaps = require('pynappo/keymaps')
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      local hl_list = {}
      local colors = { '#4b2121', '#464421', '#21492a', '#284043', '#223b4b', '#463145' }
      for i, color in pairs(colors) do
        local name = 'IndentBlanklineIndent' .. i
        vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
        table.insert(hl_list, name)
      end
      vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg='#777777', bold = true, nocombine = true })
      require('pynappo/autocmds').create('ColorScheme', {
        callback = function()
          for i, color in pairs(colors) do
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent' .. i, { fg = color, nocombine = true })
          end
          vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg='#777777', bold = true, nocombine = true })
        end,
        desc = 'Persist rainbow indent lines across colorschemes'
      })
      require('indent_blankline').setup({
        filetype_exclude = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
        show_trailing_blankline_indent = true,
        space_char_blankline = ' ',
        char_highlight_list = hl_list,
        use_treesitter = true,
        use_treesitter_scope = true,
      })
    end,
  },
  { 'folke/which-key.nvim', config = function() require('which-key').setup({ window = { border = 'single' } }) end },
  { 'folke/trouble.nvim', config = function() require('trouble').setup({}) end },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('todo-comments').setup({ highlight = { keyword = 'fg' } }) end,
  },
  {
    'folke/noice.nvim',
    cond = false,
    config = function()
      require('noice').setup({
        cmdline = { enabled = false },
        messages = { enabled = false },
        lsp = {
          progress = {
            enabled = false,
          },
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        views = {
          hover = {
            border = { style = 'rounded' },
            position = { row = 2 },
          },
        },
        presets = {
          inc_rename = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      { 'rcarriga/nvim-notify', config = function() require('notify').setup({ background_colour = '#000000' }) end },
      {
        'smjonas/inc-rename.nvim',
        dependencies = {
          {
            'stevearc/dressing.nvim',
            config = function()
              require('dressing').setup({
                input = {
                  override = function(conf)
                    conf.col = -1
                    conf.row = 0
                    return conf
                  end,
                },
              })
            end,
          },
        },
        config = function()
          require('inc_rename').setup({ input_buffer_type = 'dressing' })
          keymaps.setup.incremental_rename()
        end,
      },
    },
  },
  { 'RRethy/vim-illuminate', event = 'BufRead' },
  {
    'kevinhwang91/nvim-hlslens',
    config = function() require('hlslens').setup() end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = keymaps.setup.hlslens({ lazy = true }),
  },
  {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'neo-tree' },
        winblend = 75,
        base = 'right',
      })
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = { enabled = true, text = '💡', hl_mode = 'replace' },
      })
    end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        user_default_options = {
          RGB = false, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          mode = 'foreground', -- Set the display mode.
          tailwind = true, -- Enable tailwind colors
        },
      })
    end,
  },
}
