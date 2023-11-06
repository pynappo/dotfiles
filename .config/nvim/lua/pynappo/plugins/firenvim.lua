return {
  {
    'glacambre/firenvim',
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
    end,
    build = function() vim.fn['firenvim#install'](0) end,
  },
}
