return {
  {
    'notomo/gesture.nvim',
    enabled = false,
    config = function()
      local gesture = require('gesture')
      gesture.register({
        name = 'scroll to bottom',
        inputs = { gesture.up(), gesture.down() },
        action = 'normal! G',
      })
      gesture.register({
        name = 'next tab',
        inputs = { gesture.right() },
        action = function() vim.cmd.tabnext() end,
      })
      gesture.register({
        name = 'previous tab',
        inputs = { gesture.left() },
        action = function(_) vim.cmd.tabprevious() end,
      })
      gesture.register({
        name = 'go back',
        inputs = { gesture.right(), gesture.left() },
        -- map to `<C-o>` keycode
        action = function() vim.api.nvim_input('<C-o>') end,
      })
      gesture.register({
        name = 'close gesture traced windows',
        match = function(ctx)
          local last_input = ctx.inputs[#ctx.inputs]
          return last_input and last_input.direction == 'UP'
        end,
        can_match = function(ctx)
          local first_input = ctx.inputs[1]
          return first_input and first_input.direction == 'RIGHT'
        end,
        action = function(ctx)
          table.sort(ctx.window_ids, function(a, b) return a > b end)
          for _, window_id in ipairs(vim.fn.uniq(ctx.window_ids)) do
            vim.api.nvim_win_close(window_id, false)
          end
        end,
      })
    end,
    init = require('pynappo.keymaps').setup.gesture,
  },
}
