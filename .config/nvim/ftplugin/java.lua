local mason_packages_path = vim.fn.stdpath('data') .. '/mason/packages'
local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'})
local workspace_dir = vim.fn.expand('~/code/jdtls_workspaces/') .. vim.fn.fnamemodify(root_dir, ':p:h:t')
local is_win = vim.fn.has('win32') == 1

local lsp_config = require('pynappo/plugins/lsp').get_config('jdtls')
local bundles = { vim.fn.glob(mason_packages_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'), }
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages_path .. '/java-test/extension/server/com.microsoft.java.test.plugin-*.jar'), "\n"))
-- print(vim.inspect(bundles))
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', vim.fn.glob(mason_packages_path .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration', mason_packages_path .. '/jdtls/config_' .. (is_win and 'win' or 'linux'),
    '-data', workspace_dir,
  },
  on_attach = function(client, bufnr)
    lsp_config.on_attach(client, bufnr)
    require('pynappo/keymaps').setup.jdtls(bufnr)
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  end,

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles
  },
}
-- print(table.concat(config.cmd, ' '))
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
require('jdtls.setup').add_commands()
