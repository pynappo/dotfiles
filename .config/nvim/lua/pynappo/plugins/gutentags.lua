local g = vim.g
g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/ctags/')
vim.api.nvim_create_user_command('GutentagsClearCache', function() vim.fn.system('rm', g.gutentags_cache_dir .. '/*') end, {})
