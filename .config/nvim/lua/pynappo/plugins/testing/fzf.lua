return {
  {
    'pynappo/fzf-lua',
    enabled = false,
    config = function()
      vim.keymap.set("n", "<c-P>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
      vim.keymap.set({ "i" }, "<C-x><C-f>",
        function()
          require("fzf-lua").complete_file({
            cmd = "rg --files",
            winopts = { preview = { hidden = "nohidden" } }
          })
        end, { silent = true, desc = "Fuzzy complete file" })
      vim.keymap.set({'n'}, "gp" , function()
        require'fzf-lua'.fzf_exec("rg --files", { actions = require'fzf-lua'.defaults.actions.files })
      end)
    end
  },
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
            local result = fzf.fzf({ "choice 2"}, "--ansi")
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
            local result = fzf.fzf("fd")
            -- result is a list of lines that fzf returns, if the user has chosen
            if result then
              print(result[1])
            end
          end)()
        end
      )
      vim.cmd('command! Rg lua require("fzf-commands").rg()')
    end
}
}
