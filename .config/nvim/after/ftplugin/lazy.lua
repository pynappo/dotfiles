vim.b.miniindentscope_disable = true
vim.opt.path:append({ require('lazy.core.config').options.root, vim.fn.stdpath('config') .. '/lua' })
vim.opt_local.includeexpr = "tr(v:fname,'.','/')"
vim.opt_local.suffixesadd:prepend('.lua')
