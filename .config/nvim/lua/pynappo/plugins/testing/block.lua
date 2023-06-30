return {
  {
    "HampusHauffman/block.nvim",
    event = 'ColorScheme',
    config = function()
      require("block").setup({
        bg = ("#%06x"):format(vim.api.nvim_get_hl(0, {name = 'NormalFloat'}).bg)
      })
    end
  },
}
