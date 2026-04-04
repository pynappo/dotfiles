return {
  {
    'chomosuke/typst-preview.nvim',
    enabled = not require('pynappo.utils').is_windows,
    config = function()
      require('typst-preview').setup({
        -- get_root = function(path)
        --   local dir = vim.fs.dirname(path)
        --   return vim.fs.root(path, { '.git', 'typst.toml' }) or dir
        -- end,
      })
    end,
  },
}
