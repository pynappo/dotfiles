return {
  -- {
  --   'windwp/nvim-autopairs',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('nvim-autopairs').setup({
  --       enable_check_bracket_line = false,
  --       fast_wrap = {}
  --     })
  --   end
  -- },
  {
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    branch='v0.6', --recomended as each new version will have breaking changes
    opts = {

    }
  }
}
