local github = require('pynappo.utils').repourl.github

vim.pack.add({
  -- {
  --   'vijaymarupudi/nvim-fzf',
  --   enabled = false,
  --   event = 'VeryLazy',
  --   config = function() local fzf = require('fzf') end,
  -- },
  github('ibhagwan/fzf-lua'),
})
require('fzf-lua').setup({
  grep = {
    rg_glob = true,
  },
  actions = {
    files = {
      true,
      ['ctrl-q'] = { fn = FzfLua.actions.file_sel_to_qf, prefix = 'select-all' },
    },
  },
})
require('pynappo.keymaps').setup.fzf()
