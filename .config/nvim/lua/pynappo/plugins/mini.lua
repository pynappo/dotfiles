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
  end,
}
