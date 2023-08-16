return {
  {
    'pynappo/nvim-fzf',
    dependencies = {
      'vijaymarupudi/nvim-fzf-commands'
    },
    config = function()
      local fzf = require("fzf")

      vim.keymap.set(
        'n',
        '<leader>kk',
        function()
          coroutine.wrap(function()
            local result = fzf.fzf({"choice 1", "choice 2"}, "--ansi")
            -- result is a list of lines that fzf returns, if the user has chosen
            if result then
              print(result[1])
            end
          end)()
        end
      )
      vim.keymap.set(
        'n',
        '<leader>kj',
        function()
          coroutine.wrap(function()
            local result = fzf.fzf("rg --files")
            -- result is a list of lines that fzf returns, if the user has chosen
            if result then
              print(result[1])
            end
          end)()
        end
      )
    end
  },

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
