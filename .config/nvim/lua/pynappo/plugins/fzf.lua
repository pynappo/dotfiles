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
})
vim.api.nvim_create_user_command('PluginTab', function()
  local plugins = require('lazy').plugins()
  ---@type { [string]: LazyPlugin }
  local plugin_map = {}
  for _, p in ipairs(plugins) do
    plugin_map[p.name] = p
  end
  vim.ui.select(vim.tbl_keys(plugin_map), {
    prompt = 'Choose a plugin to browse',
  }, function(plugin_name)
    vim.cmd.tabnew()
    vim.cmd.tcd(plugin_map[plugin_name].dir)
  end)
end, {})
require('pynappo.keymaps').setup.fzf()
