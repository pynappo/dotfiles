return {
  'echasnovski/mini.nvim',
  config = function()
    local keymaps = require('pynappo.keymaps')
    -- require('mini.pairs').setup()
    require('mini.ai').setup()
    require('mini.move').setup()
    require('mini.bufremove').setup()
    require('mini.sessions').setup()
    require('mini.hipatterns').setup()
    require('mini.align').setup({
      mappings = {
        start = '<leader>a',
        start_with_preview = '<leader>A'
      }
    })
    require('mini.surround').setup({
      custom_surroundings = nil,
      highlight_duration = 500,
      mappings = keymaps.mini.surround,
      n_lines = 30,
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

    vim.keymap.del('x', keymaps.mini.surround.add)
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
    local command_map = {
      whitespace = trailspace.trim,
      last_lines = trailspace.trim_last_lines,
      all = function() 
        trailspace.trim()
        trailspace.trim_last_lines()
      end,
    }
    vim.api.nvim_create_user_command(
      'Trim',
      function(args) (command_map[args.args] or command_map.all)() end,
      { nargs = '?', complete = function() return vim.tbl_keys(command_map) end, }
    )
    keymaps.setup.mini()
    require('pynappo.theme').overrides.all_themes.vim_highlights.MiniIndentscopeSymbol = 'guifg=#666666 gui=nocombine'
    require('pynappo.theme').overrides.all_themes.vim_highlights.MiniTrailSpace = 'guifg=#555555 gui=undercurl,nocombine'
  end,
}
