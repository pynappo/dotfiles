return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- require('mini.pairs').setup()
    require('mini.ai').setup()
    require('mini.move').setup()
    require('mini.bufremove').setup()
    require('mini.sessions').setup()
    require('mini.align').setup({
      mappings = {
        start = '<leader>a',
        start_with_preview = '<leader>A'
      }
    })
    require('mini.surround').setup({
      custom_surroundings = nil,
      highlight_duration = 500,
      mappings = require('pynappo.keymaps').mini.surround,
      n_lines = 20,
      respect_selection_type = true,
      search_method = 'cover',

      -- Whether to disable showing non-error feedback
      silent = false,
    })
    require('mini.files').setup({
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = nil,
        -- In which order to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = 'L',
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
      },
    })

    vim.keymap.del('x', require('pynappo.keymaps').mini.surround.add)
    local indentscope = require('mini.indentscope')
    indentscope.setup({
      draw = {
        animation = indentscope.gen_animation.quadratic({easing = 'out', duration = 10, unit = 'step'})
      },
      options = { try_as_border = true },
      symbol = '󰇙'
    })
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if vim.tbl_contains({'nofile', 'help'}, vim.bo[args.buf].buftype) then vim.b[args.buf].miniindentscope_disable = true end
      end
    })
    local trailspace = require('mini.trailspace')
    trailspace.setup()
    vim.api.nvim_create_user_command('Trim', function()
      trailspace.trim()
      trailspace.trim_last_lines()
    end, {})
    require('pynappo/keymaps').setup.mini()
    local function set_mini_highlights()
      vim.cmd.highlight('MiniIndentscopeSymbol guifg=#777777 gui=nocombine')
      vim.cmd.highlight('MiniTrailspace guifg=#444444 gui=undercurl,nocombine')
    end
    set_mini_highlights()
    require('pynappo/autocmds').create('ColorScheme', { callback = set_mini_highlights })
    require('pynappo.theme').overrides.all_themes.vim_highlights.MiniIndentscopeSymbol = 'guifg=#666666 gui=nocombine'
    require('pynappo.theme').overrides.all_themes.vim_highlights.MiniTrailSpace = 'guifg=#555555 gui=undercurl,nocombine'
  end,
}
