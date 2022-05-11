local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'Shatur/neovim-ayu'
  use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
  use 'ludovicchabant/vim-gutentags'
  use ({
    { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', config = function() require('telescope').load_extension('fzf') end }
  })
  use { 'nvim-lualine/lualine.nvim',
    config = function() require('lualine').setup {
      options = { theme = 'ayu',}
    }
    end
  }
  use { 'lukas-reineke/indent-blankline.nvim',
    event = "BufEnter",
    config = function() require('indent_blankline').setup {
      char = '┊',
      show_trailing_blankline_indent = false,
    }
    end
  }
  use { 'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      }
    }
    end
  }
  use ({
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
    {'nvim-treesitter/nvim-treesitter-textobjects'},
    {'p00f/nvim-ts-rainbow'}
  })
  use ({
    "williamboman/nvim-lsp-installer",
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("nvim-lsp-installer").setup {}
        local lspconfig = require("lspconfig")
        lspconfig.sumneko_lua.setup {}
      end
    }
  })
  use ({
    {'hrsh7th/nvim-cmp', config = function() require('plugins/cmp') end},
    {'hrsh7th/cmp-nvim-lsp'},
    {'saadparwaiz1/cmp_luasnip' }
  })
  use 'L3MON4D3/LuaSnip'
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
  use 'kyazdani42/nvim-web-devicons'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {'kyazdani42/nvim-web-devicons'},
    config = function() require('nvim-tree').setup{} end
  }
  use { "folke/which-key.nvim", config = function() require('which-key').setup {} end }
  use { 'goolord/alpha-nvim', config = function () require'alpha'.setup(require'alpha.themes.dashboard'.config) end }
  use 'lewis6991/impatient.nvim'
  use 'dstein64/vim-startuptime'
  use 'andymass/vim-matchup'
  use 'dstein64/nvim-scrollview'
  if packer_bootstrap then
    require('packer').sync()
  end
end)


require('ayu').setup({
  mirage = true,
  overrides = {
    Comment = {fg='#666666', italic=true, bg="none"},
    Normal = {bg='none'},
    NonText = {bg='none'},
    SpecialKey = {bg='none'},
    VertSplit = {bg='none'},
    SignColumn = {bg='none'},
    EndOfBuffer = {bg='none'},
    Folded = {bg='none'},
  }
})

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = nil
    },
  },
}



require('scrollview').setup({
  excluded_filetypes = {'nerdtree', 'NvimTree'},
  current_only = true,
  winblend = 75,
  base = 'right'
})
