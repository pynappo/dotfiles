return {
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        enable_check_bracket_line = false,
        fast_wrap = {}
      })
    end
  }
}
