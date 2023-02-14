return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    require('mini.pairs').setup()
    require('mini.ai').setup()
    require('mini.move').setup()
    require('mini.bufremove').setup()
    require('mini.sessions').setup()
    local indentscope = require('mini.indentscope')
    indentscope.setup({
      draw = {
        animation = indentscope.gen_animation.quadratic({easing = 'out', duration = 12, unit = 'step'})
      },
      options = { try_as_border = true }
    })
    local trailspace = require('mini.trailspace')
    trailspace.setup()
    vim.api.nvim_create_user_command('Trim', function()
      trailspace.trim()
      trailspace.trim_last_lines()
    end, {})
    require('pynappo/keymaps').setup.mini()
    local function set_mini_highlights()
        vim.cmd.highlight('MiniIndentscopeSymbol guifg=#888888 gui=nocombine')
        vim.cmd.highlight('MiniTrailspace guifg=#444444 gui=undercurl,nocombine')
    end
    set_mini_highlights()
    require('pynappo/autocmds').create('ColorScheme', { callback = set_mini_highlights })
  end,
}
