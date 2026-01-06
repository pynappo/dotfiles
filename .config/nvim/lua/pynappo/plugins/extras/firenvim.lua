return {
  {
    'glacambre/firenvim',
    enabled = false,
    init = function()
      local g, o = vim.g, vim.o
      g.firenvim_config = {
        globalSettings = {
          alt = 'all',
        },
        localSettings = {
          ['.*'] = {
            cmdline = 'neovim',
            content = 'md',
            priority = 0,
            selector = 'textarea',
            takeover = 'never',
          },
        },
      }
      if g.started_by_firenvim then
        vim.cmd.startinsert()
        o.laststatus = 0
        o.cmdheight = 0
        o.showtabline = 0
        o.pumheight = 10
      end
      local once = false
      local ft_maps = {
        python3 = 'python',
      }
      vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = '*leetcode*.txt',
        callback = function(ctx)
          if not once then
            vim.ui.select({ 'python3', 'csharp', 'rust' }, {
              prompt = 'Select filetype for leetcode',
            }, function(choice) vim.bo.filetype = ft_maps[choice] or choice end)
          end
          once = true
        end,
      })
    end,
    build = function() vim.fn['firenvim#install'](0) end,
  },
}
