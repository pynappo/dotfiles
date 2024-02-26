return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = {
        add = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
      },
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
    },
    'pwntester/octo.nvim',
  },
}
