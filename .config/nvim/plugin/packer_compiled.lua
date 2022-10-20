-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "C:\\Users\\lehti\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?.lua;C:\\Users\\lehti\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\share\\lua\\5.1\\?\\init.lua;C:\\Users\\lehti\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?.lua;C:\\Users\\lehti\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\luarocks\\rocks-5.1\\?\\init.lua"
local install_cpath_pattern = "C:\\Users\\lehti\\AppData\\Local\\Temp\\nvim\\packer_hererocks\\2.1.0-beta3\\lib\\lua\\5.1\\?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "require('Comment').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  LuaSnip = {
    config = { "require('luasnip.loaders.from_vscode').lazy_load()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["alpha-nvim"] = {
    config = { "require('alpha').setup(require('alpha.themes.startify').config)" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\alpha-nvim",
    url = "https://github.com/goolord/alpha-nvim"
  },
  ["better-escape.nvim"] = {
    config = { "\27LJ\2\nd\0\0\3\0\5\0\r6\0\0\0009\0\1\0009\0\2\0)\2\0\0B\0\2\2:\0\2\0)\1\1\0\1\1\0\0X\0\2€'\0\3\0X\1\1€'\0\4\0L\0\2\0\n<esc>\v<esc>l\24nvim_win_get_cursor\bapi\bvimj\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\tkeys\0\fmapping\1\0\0\1\3\0\0\ajk\akj\nsetup\18better_escape\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\better-escape.nvim",
    url = "https://github.com/max397574/better-escape.nvim"
  },
  catppuccin = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\catppuccin",
    url = "https://github.com/catppuccin/nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-calc"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-calc",
    url = "https://github.com/hrsh7th/cmp-calc"
  },
  ["cmp-cmdline"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-cmdline-history"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-cmdline-history",
    url = "https://github.com/dmitmel/cmp-cmdline-history"
  },
  ["cmp-emoji"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-emoji",
    url = "https://github.com/hrsh7th/cmp-emoji"
  },
  ["cmp-git"] = {
    config = { 'require("cmp_git").setup()' },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-git",
    url = "https://github.com/petertriho/cmp-git"
  },
  ["cmp-look"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-look",
    url = "https://github.com/octaltree/cmp-look"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-spell"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp-spell",
    url = "https://github.com/f3fora/cmp-spell"
  },
  cmp_luasnip = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["copilot-cmp"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\copilot-cmp",
    url = "https://github.com/zbirenbaum/copilot-cmp"
  },
  ["copilot.lua"] = {
    config = { "require('copilot').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\copilot.lua",
    url = "https://github.com/zbirenbaum/copilot.lua"
  },
  ["crates.nvim"] = {
    after_files = { "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\crates.nvim\\after\\plugin\\cmp_crates.lua" },
    config = { "require('crates').setup()" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\crates.nvim",
    url = "https://github.com/saecki/crates.nvim"
  },
  ["dial.nvim"] = {
    config = { 'require("pynappo/plugins/dial")' },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\dial.nvim",
    url = "https://github.com/monaqa/dial.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dressing.nvim"] = {
    config = { "\27LJ\2\n#\0\1\2\0\2\0\5)\1ÿÿ=\1\0\0)\1\0\0=\1\1\0L\0\2\0\brow\bcol`\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0003\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\ninput\1\0\0\roverride\1\0\0\0\nsetup\rdressing\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  firenvim = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "require('pynappo/plugins/gitsigns')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["guess-indent.nvim"] = {
    config = { "require('guess-indent').setup{}" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\guess-indent.nvim",
    url = "https://github.com/nmac427/guess-indent.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["inc-rename.nvim"] = {
    config = { "\27LJ\2\n•\1\0\0\3\0\6\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\2\0'\2\5\0B\0\2\1K\0\1\0\23incremental_rename\20pynappo/keymaps\1\0\1\22input_buffer_type\rdressing\nsetup\15inc_rename\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\inc-rename.nvim",
    url = "https://github.com/smjonas/inc-rename.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\n¿\3\0\0\f\0\15\0\0314\0\0\0006\1\0\0005\3\1\0B\1\2\4H\4\16€'\6\2\0\18\a\4\0&\6\a\0066\a\3\0009\a\4\a9\a\5\a)\t\0\0\18\n\6\0005\v\6\0=\5\a\vB\a\4\0016\a\b\0009\a\t\a\18\t\0\0\18\n\6\0B\a\3\1F\4\3\3R\4î\1276\1\n\0'\3\v\0B\1\2\0029\1\f\0015\3\r\0=\0\14\3B\1\2\1K\0\1\0\24char_highlight_list\1\0\6\31show_current_context_start\2#show_trailing_blankline_indent\1\25space_char_blankline\6 \19use_treesitter\2\25use_treesitter_scope\2\25show_current_context\2\nsetup\21indent_blankline\frequire\vinsert\ntable\afg\1\0\0\16nvim_set_hl\bapi\bvim\26IndentBlanklineIndent\1\a\0\0\f#662121\f#767621\f#216631\f#325a5e\f#324b7b\f#562155\npairs\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["leap.nvim"] = {
    config = { "require('leap').set_default_keymaps()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\leap.nvim",
    url = "https://github.com/ggandor/leap.nvim"
  },
  ["lspkind.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lspkind.nvim",
    url = "https://github.com/onsails/lspkind.nvim"
  },
  ["lualine-lsp-progress.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lualine-lsp-progress.nvim",
    url = "https://github.com/WhoIsSethDaniel/lualine-lsp-progress.nvim"
  },
  ["lualine.nvim"] = {
    after = { "tabby.nvim" },
    config = { "require('pynappo/plugins/lualine')" },
    loaded = true,
    only_config = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["mini.nvim"] = {
    config = { "require('pynappo/plugins/mini')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\mini.nvim",
    url = "https://github.com/echasnovski/mini.nvim"
  },
  ["neo-tree.nvim"] = {
    config = { "\27LJ\2\n`\0\0\3\0\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\1K\0\1\0\29pynappo/plugins/neo-tree\nsetup\18window-picker\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neo-tree.nvim",
    url = "https://github.com/nvim-neo-tree/neo-tree.nvim"
  },
  ["neodev.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neodev.nvim",
    url = "https://github.com/folke/neodev.nvim"
  },
  neogit = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  neorg = {
    config = { "require('neorg').setup {['core.defaults'] = {}}" },
    load_after = {},
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\neorg",
    url = "https://github.com/nvim-neorg/neorg"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\nª\1\0\0\5\0\a\0\0166\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0006\2\0\0'\4\6\0B\2\2\0029\2\1\2B\0\2\1K\0\1\0\20pynappo/keymaps\17set_mappings\21neoscroll.config\1\0\1\20easing_function\14quadratic\nsetup\14neoscroll\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  neotest = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-rust"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neotest-rust",
    url = "https://github.com/rouge8/neotest-rust"
  },
  ["neovim-ayu"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\neovim-ayu",
    url = "https://github.com/Shatur/neovim-ayu"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["numb.nvim"] = {
    config = { "require('numb').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\numb.nvim",
    url = "https://github.com/nacro90/numb.nvim"
  },
  ["nvim-autopairs"] = {
    config = { "require('pynappo/plugins/autopairs')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-autopairs",
    url = "https://github.com/windwp/nvim-autopairs"
  },
  ["nvim-cmp"] = {
    config = { "require('pynappo/plugins/cmp')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "require('colorizer').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-colorizer.lua",
    url = "https://github.com/Akianonymus/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    config = { 'require("dapui").setup()' },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    config = { 'require("nvim-dap-virtual-text").setup()' },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-hlslens"] = {
    config = { "require('pynappo/keymaps').setup('hlslens')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-hlslens",
    url = "https://github.com/kevinhwang91/nvim-hlslens"
  },
  ["nvim-lightbulb"] = {
    config = { "\27LJ\2\n—\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\17virtual_text\1\0\3\fenabled\2\fhl_mode\freplace\ttext\tðŸ’¡\tsign\1\0\0\1\0\1\fenabled\1\nsetup\19nvim-lightbulb\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-lightbulb",
    url = "https://github.com/kosayoda/nvim-lightbulb"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\nS\0\0\3\0\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\1K\0\1\0\24pynappo/plugins/lsp\nsetup\nmason\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-navic"] = {
    config = { "require('pynappo/plugins/navic')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-navic",
    url = "https://github.com/SmiteshP/nvim-navic"
  },
  ["nvim-neoclip.lua"] = {
    config = { "require('neoclip').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-neoclip.lua",
    url = "https://github.com/AckslD/nvim-neoclip.lua"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\nm\0\0\4\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\4\0006\1\0\0'\3\1\0B\1\2\2=\1\1\0K\0\1\0\bvim\1\0\1\22background_colour\f#000000\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-surround"] = {
    config = { "require('nvim-surround').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-treesitter"] = {
    after = { "neorg" },
    config = { "require('pynappo/plugins/treesitter')" },
    loaded = true,
    only_config = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-ts-rainbow",
    url = "https://github.com/p00f/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nvim-window-picker"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\nvim-window-picker",
    url = "https://github.com/s1n7ax/nvim-window-picker"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["peek.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\peek.nvim",
    url = "https://github.com/toppair/peek.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["rust-tools.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
  },
  ["symbols-outline.nvim"] = {
    config = { "require('symbols-outline').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\symbols-outline.nvim",
    url = "https://github.com/simrat39/symbols-outline.nvim"
  },
  ["tabby.nvim"] = {
    config = { "require('pynappo/plugins/tabby')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\tabby.nvim",
    url = "https://github.com/nanozuki/tabby.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope-ui-select.nvim",
    url = "https://github.com/nvim-telescope/telescope-ui-select.nvim"
  },
  ["telescope.nvim"] = {
    after = { "telescope-frecency.nvim" },
    config = { "require('pynappo/plugins/telescope')" },
    loaded = true,
    only_config = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["tint.nvim"] = {
    config = { "require('tint').setup()" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\tint.nvim",
    url = "https://github.com/levouh/tint.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "require('todo-comments').setup{highlight = {keyword = \"fg\"}}" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["toggleterm.nvim"] = {
    config = { "require('pynappo/plugins/toggleterm')" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\toggleterm.nvim",
    url = "https://github.com/akinsho/toggleterm.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "Trouble", "TroubleEnter" },
    config = { "require('trouble').setup{}" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-gutentags"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-gutentags",
    url = "https://github.com/ludovicchabant/vim-gutentags"
  },
  ["vim-matchup"] = {
    config = { "\27LJ\2\n«\2\0\0\3\0\f\0\0276\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0006\0\b\0'\2\t\0B\0\2\0029\0\n\0'\2\v\0B\0\2\1K\0\1\0\fmatchup\nsetup\20pynappo/keymaps\frequire\1\0\1\vmethod\npopup!matchup_matchparen_offscreen matchup_matchparen_deferred\30matchup_transmute_enabled\29matchup_surround_enabled\20matchup_enabled\6g\bvim\0" },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    config = { "vim.g.startuptime_tries = 3" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\opt\\vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  },
  ["which-key.nvim"] = {
    config = { "require('which-key').setup {} " },
    loaded = true,
    path = "C:\\Users\\lehti\\AppData\\Local\\nvim-data\\site\\pack\\packer\\start\\which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\nS\0\0\3\0\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\1K\0\1\0\24pynappo/plugins/lsp\nsetup\nmason\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: inc-rename.nvim
time([[Config for inc-rename.nvim]], true)
try_loadstring("\27LJ\2\n•\1\0\0\3\0\6\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\2\0'\2\5\0B\0\2\1K\0\1\0\23incremental_rename\20pynappo/keymaps\1\0\1\22input_buffer_type\rdressing\nsetup\15inc_rename\frequire\0", "config", "inc-rename.nvim")
time([[Config for inc-rename.nvim]], false)
-- Config for: nvim-hlslens
time([[Config for nvim-hlslens]], true)
require('pynappo/keymaps').setup('hlslens')
time([[Config for nvim-hlslens]], false)
-- Config for: guess-indent.nvim
time([[Config for guess-indent.nvim]], true)
require('guess-indent').setup{}
time([[Config for guess-indent.nvim]], false)
-- Config for: nvim-dap-ui
time([[Config for nvim-dap-ui]], true)
require("dapui").setup()
time([[Config for nvim-dap-ui]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
require('pynappo/plugins/gitsigns')
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-navic
time([[Config for nvim-navic]], true)
require('pynappo/plugins/navic')
time([[Config for nvim-navic]], false)
-- Config for: better-escape.nvim
time([[Config for better-escape.nvim]], true)
try_loadstring("\27LJ\2\nd\0\0\3\0\5\0\r6\0\0\0009\0\1\0009\0\2\0)\2\0\0B\0\2\2:\0\2\0)\1\1\0\1\1\0\0X\0\2€'\0\3\0X\1\1€'\0\4\0L\0\2\0\n<esc>\v<esc>l\24nvim_win_get_cursor\bapi\bvimj\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\tkeys\0\fmapping\1\0\0\1\3\0\0\ajk\akj\nsetup\18better_escape\frequire\0", "config", "better-escape.nvim")
time([[Config for better-escape.nvim]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
require('colorizer').setup()
time([[Config for nvim-colorizer.lua]], false)
-- Config for: alpha-nvim
time([[Config for alpha-nvim]], true)
require('alpha').setup(require('alpha.themes.startify').config)
time([[Config for alpha-nvim]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require('pynappo/plugins/cmp')
time([[Config for nvim-cmp]], false)
-- Config for: dressing.nvim
time([[Config for dressing.nvim]], true)
try_loadstring("\27LJ\2\n#\0\1\2\0\2\0\5)\1ÿÿ=\1\0\0)\1\0\0=\1\1\0L\0\2\0\brow\bcol`\1\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\6\0005\3\4\0003\4\3\0=\4\5\3=\3\a\2B\0\2\1K\0\1\0\ninput\1\0\0\roverride\1\0\0\0\nsetup\rdressing\frequire\0", "config", "dressing.nvim")
time([[Config for dressing.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
require('luasnip.loaders.from_vscode').lazy_load()
time([[Config for LuaSnip]], false)
-- Config for: nvim-lightbulb
time([[Config for nvim-lightbulb]], true)
try_loadstring("\27LJ\2\n—\1\0\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0025\3\6\0=\3\a\2B\0\2\1K\0\1\0\17virtual_text\1\0\3\fenabled\2\fhl_mode\freplace\ttext\tðŸ’¡\tsign\1\0\0\1\0\1\fenabled\1\nsetup\19nvim-lightbulb\frequire\0", "config", "nvim-lightbulb")
time([[Config for nvim-lightbulb]], false)
-- Config for: dial.nvim
time([[Config for dial.nvim]], true)
require("pynappo/plugins/dial")
time([[Config for dial.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require('pynappo/plugins/treesitter')
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-autopairs
time([[Config for nvim-autopairs]], true)
require('pynappo/plugins/autopairs')
time([[Config for nvim-autopairs]], false)
-- Config for: copilot.lua
time([[Config for copilot.lua]], true)
require('copilot').setup()
time([[Config for copilot.lua]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require('pynappo/plugins/telescope')
time([[Config for telescope.nvim]], false)
-- Config for: mini.nvim
time([[Config for mini.nvim]], true)
require('pynappo/plugins/mini')
time([[Config for mini.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
require('pynappo/plugins/lualine')
time([[Config for lualine.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
require('which-key').setup {} 
time([[Config for which-key.nvim]], false)
-- Config for: cmp-git
time([[Config for cmp-git]], true)
require("cmp_git").setup()
time([[Config for cmp-git]], false)
-- Config for: nvim-neoclip.lua
time([[Config for nvim-neoclip.lua]], true)
require('neoclip').setup()
time([[Config for nvim-neoclip.lua]], false)
-- Config for: nvim-surround
time([[Config for nvim-surround]], true)
require('nvim-surround').setup()
time([[Config for nvim-surround]], false)
-- Config for: neoscroll.nvim
time([[Config for neoscroll.nvim]], true)
try_loadstring("\27LJ\2\nª\1\0\0\5\0\a\0\0166\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\0\0'\2\4\0B\0\2\0029\0\5\0006\2\0\0'\4\6\0B\2\2\0029\2\1\2B\0\2\1K\0\1\0\20pynappo/keymaps\17set_mappings\21neoscroll.config\1\0\1\20easing_function\14quadratic\nsetup\14neoscroll\frequire\0", "config", "neoscroll.nvim")
time([[Config for neoscroll.nvim]], false)
-- Config for: neo-tree.nvim
time([[Config for neo-tree.nvim]], true)
try_loadstring("\27LJ\2\n`\0\0\3\0\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\1K\0\1\0\29pynappo/plugins/neo-tree\nsetup\18window-picker\frequire\0", "config", "neo-tree.nvim")
time([[Config for neo-tree.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
require('Comment').setup()
time([[Config for Comment.nvim]], false)
-- Config for: nvim-dap-virtual-text
time([[Config for nvim-dap-virtual-text]], true)
require("nvim-dap-virtual-text").setup()
time([[Config for nvim-dap-virtual-text]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\nm\0\0\4\0\5\0\f6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\0016\0\4\0006\1\0\0'\3\1\0B\1\2\2=\1\1\0K\0\1\0\bvim\1\0\1\22background_colour\f#000000\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: vim-matchup
time([[Config for vim-matchup]], true)
try_loadstring("\27LJ\2\n«\2\0\0\3\0\f\0\0276\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0006\0\0\0009\0\1\0005\1\a\0=\1\6\0006\0\b\0'\2\t\0B\0\2\0029\0\n\0'\2\v\0B\0\2\1K\0\1\0\fmatchup\nsetup\20pynappo/keymaps\frequire\1\0\1\vmethod\npopup!matchup_matchparen_offscreen matchup_matchparen_deferred\30matchup_transmute_enabled\29matchup_surround_enabled\20matchup_enabled\6g\bvim\0", "config", "vim-matchup")
time([[Config for vim-matchup]], false)
-- Config for: tint.nvim
time([[Config for tint.nvim]], true)
require('tint').setup()
time([[Config for tint.nvim]], false)
-- Config for: leap.nvim
time([[Config for leap.nvim]], true)
require('leap').set_default_keymaps()
time([[Config for leap.nvim]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
require('numb').setup()
time([[Config for numb.nvim]], false)
-- Config for: symbols-outline.nvim
time([[Config for symbols-outline.nvim]], true)
require('symbols-outline').setup()
time([[Config for symbols-outline.nvim]], false)
-- Config for: toggleterm.nvim
time([[Config for toggleterm.nvim]], true)
require('pynappo/plugins/toggleterm')
time([[Config for toggleterm.nvim]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
require('todo-comments').setup{highlight = {keyword = "fg"}}
time([[Config for todo-comments.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd telescope-frecency.nvim ]]
vim.cmd [[ packadd tabby.nvim ]]

-- Config for: tabby.nvim
require('pynappo/plugins/tabby')

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Trouble lua require("packer.load")({'trouble.nvim'}, { cmd = "Trouble", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TroubleEnter lua require("packer.load")({'trouble.nvim'}, { cmd = "TroubleEnter", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file StartupTime lua require("packer.load")({'vim-startuptime'}, { cmd = "StartupTime", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType norg ++once lua require("packer.load")({'neorg'}, { ft = "norg" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufRead Cargo.toml ++once lua require("packer.load")({'crates.nvim'}, { event = "BufRead Cargo.toml" }, _G.packer_plugins)]]
vim.cmd [[au BufEnter * ++once lua require("packer.load")({'indent-blankline.nvim'}, { event = "BufEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: C:\Users\lehti\AppData\Local\nvim-data\site\pack\packer\opt\neorg\ftdetect\norg.vim]], true)
vim.cmd [[source C:\Users\lehti\AppData\Local\nvim-data\site\pack\packer\opt\neorg\ftdetect\norg.vim]]
time([[Sourcing ftdetect script at: C:\Users\lehti\AppData\Local\nvim-data\site\pack\packer\opt\neorg\ftdetect\norg.vim]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
