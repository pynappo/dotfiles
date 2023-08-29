return {
  {
    "linrongbin16/fzfx.nvim",
    dependencies = {
      { "junegunn/fzf", build = ":call fzf#install()" },
    },
    config = function()
      require("fzfx").setup()
    end
  },
}
