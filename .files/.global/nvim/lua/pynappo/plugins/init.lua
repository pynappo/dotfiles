local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  Packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

require('packer').startup({ function(use)
  use 'wbthomason/packer.nvim'
  use { 'tpope/vim-fugitive' }
  use { 'Shatur/neovim-ayu', config = [[require('pynappo/theme')]] }
  use { 'numToStr/Comment.nvim', config = [[require('Comment').setup()]] }
  use({
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-ui-select.nvim' }
      },
      config = [[require('pynappo/plugins/telescope')]]
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    },
  })
  use { 'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    config = function()
      local hl_list = {}
      for i, color in pairs({ '#662121', '#767621', '#216631', '#325a5e', '#324b7b', '#562155' }) do
        local name = 'IndentBlanklineIndent' .. i
        vim.api.nvim_set_hl(0, name, { fg = color })
        table.insert(hl_list, name);
      end
      require('indent_blankline').setup {
        show_trailing_blankline_indent = false,
        space_char_blankline = ' ',
        char_highlight_list = hl_list
      }
    end
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '▎' },
          topdelete = { text = '契' },
          changedelete = { text = '▎' },
        },
      }
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'nvim-telescope/telescope-file-browser.nvim' },
      { 'p00f/nvim-ts-rainbow' },
      { 'windwp/nvim-ts-autotag' }, 
    },
    config = [[require('pynappo/plugins/treesitter')]]
  }
  use({
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'onsails/lspkind.nvim',
        'dmitmel/cmp-cmdline-history'
      },
      config = [[require('pynappo/plugins/cmp')]]
    },
    {
      'L3MON4D3/LuaSnip',
      config = [[require('luasnip.loaders.from_vscode').lazy_load()]],
      requires = { 'rafamadriz/friendly-snippets' }
    }
  })
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    config = [[vim.g.neo_tree_remove_legacy_commands = 1]]
  }
  use { 'folke/which-key.nvim', config = [[require('which-key').setup {} ]] }
  use { 'goolord/alpha-nvim', config = [[require('alpha').setup(require('alpha.themes.startify').config)]] }
  use 'lewis6991/impatient.nvim'
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 3]] }
  use 'andymass/vim-matchup'
  use {
    'nmac427/guess-indent.nvim',
    config = [[require('guess-indent').setup{}]],
  }
  use {
    'wfxr/minimap.vim',
    config = function()
      vim.g.minimap_width = 10
      vim.g.minimap_highlight_range = 1
      vim.g.minimap_git_colors = 1
      vim.g.minimap_block_filetypes = { 'fugitive', 'neotree', 'tagbar', 'fzf', 'vista' }
      vim.g.minimap_highlight_search = 1
    end,
    cmd = 'MinimapToggle'
  }
  use {
    'ggandor/leap.nvim', config = [[require('leap').set_default_keymaps()]]
  }
  use 'tpope/vim-repeat'
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('trouble').setup{}]],
    cmd = 'TroubleToggle'
  }
  -- use {
  --   'RRethy/vim-hexokinase',
  --   config = function() vim.g.Hexokinase_highlighters = 'foreground' end,
  --   run = 'cd '.. fn.stdpath('data') .. [[\site\pack\packer\start\vim-hexokinase\ && make hexokinase]]
  -- }
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  }
  use 'andweeb/presence.nvim'
  use 'Djancyp/cheat-sheet'
  use { 'lukas-reineke/headlines.nvim', config = [[require('headlines').setup()]] }
  use { 'karb94/neoscroll.nvim', config = [[require('pynappo/plugins/neoscroll')]] }
  use 'stevearc/dressing.nvim'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'nacro90/numb.nvim', config = [[require('numb').setup()]] }
  use {
    'windwp/nvim-autopairs',
    requires = 'hrsh7th/nvim-cmp',
    config = [[require('pynappo/plugins/autopairs')]]
  }
  use 'antoinemadec/FixCursorHold.nvim'
  use { 'kylechui/nvim-surround', config = [[require('nvim-surround').setup()]] }
  use { 'glacambre/firenvim', run = [[vim.fn['firenvim#install'](0)]] }
  use {
    'zbirenbaum/copilot.lua',
    event = { 'VimEnter' },
    config = function()
      vim.defer_fn(function() require('copilot').setup() end, 100)
    end,
  }
  use {
    'zbirenbaum/copilot-cmp',
    module = 'copilot_cmp',
  }
  use {
    'akinsho/bufferline.nvim',
    tag = 'v2.*',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('pynappo/plugins/bufferline')]]
  }
  use { 'max397574/better-escape.nvim', config = [[require('better_escape').setup()]] }
  use { 'kevinhwang91/nvim-hlslens', config = [[require('pynappo/plugins/hlslens')]] }
  use {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({
        background_color = '#000000',
      })
      vim.notify = require('notify')
    end
  }
  use {
    'SmiteshP/nvim-navic',
    requires = 'neovim/nvim-lspconfig'
  }
  use {
    'nvim-neorg/neorg',
    -- tag = 'latest',
    ft = 'norg',
    after = 'nvim-treesitter', -- You may want to specify Telescope here as well
    config = [[require('neorg').setup {['core.defaults'] = {}}]]
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = [[require('pynappo/plugins/lualine')]]
  }
  use {
    'AckslD/nvim-neoclip.lua',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = [[require('neoclip').setup()]]
  }
  use {
    'jose-elias-alvarez/null-ls.nvim',
  }
  -- Doesn't work with transparent bg
  -- use {
  --   'folke/twilight.nvim',
  --   config = [[require('twilight').setup({})]]
  -- }
  -- use {
  --   'sunjon/shade.nvim',
  --   config = function()
  --     require('shade').setup({
  --       overlay_opacity = 50,
  --       opacity_step = 1,
  --       keys = {
  --         brightness_up    = '<C-Up>',
  --         brightness_down  = '<C-Down>',
  --         toggle           = '<Leader>t',
  --       }
  --     })
  --   end
  -- }
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('pynappo/plugins/lsp')
      require('mason').setup()
      require('mason-lspconfig').setup({
        automatic_installation = true;
      })
    end

  }
end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})
if Packer_bootstrap then
  require('packer').sync()
end