local mason_packages_path = vim.fn.stdpath('data') .. '/mason/packages'
local root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' })
local workspace_dir = vim.fn.expand('~/code/jdtls_workspaces/') .. vim.fn.fnamemodify(root_dir, ':p:h:t')

local bundles =
  { vim.fn.glob(mason_packages_path .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar') }

vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(mason_packages_path .. '/java-test/extension/server/com.microsoft.java.test.plugin-*.jar'),
    '\n'
  )
)

local ok, jdtls_helper = pcall(require, 'pynappo.private.jdtls')

local workspace_dirs = nil
if ok then workspace_dirs = jdtls_helper.find_workspace_dirs() end

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
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    vim.fn.glob(mason_packages_path .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    mason_packages_path .. '/jdtls/config_' .. (vim.fn.has('win32') == 1 and 'win' or 'linux'),
    '-data',
    workspace_dir,
  },
  -- on_attach = jdtls_config.on_attach
  --
  root_dir = root_dir,

  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  -- settings = {}

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles,
    workspaceFolders = workspace_dirs,
  },
}
config = vim.tbl_extend('force', config, require('pynappo/lsp/configs').jdtls)
require('jdtls').start_or_attach(config)
