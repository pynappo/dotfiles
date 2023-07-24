return {
  {
    'windwp/nvim-autopairs',
    event = 'VeryLazy',
    config = function()
      require('nvim-autopairs').setup({
        enable_check_bracket_line = false,
        fast_wrap = {}
      })
    end
  }
}
