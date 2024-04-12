---@diagnostic disable: missing-fields
return {
  {
    'hrsh7th/nvim-cmp',
    version = false,
    dependencies = {
      'onsails/lspkind.nvim',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'octaltree/cmp-look',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'davidsierradz/cmp-conventionalcommits',
      'chrisgrieser/cmp-nerdfont',
      'https://git.sr.ht/~p00f/clangd_extensions.nvim/',
      {
        'L3MON4D3/LuaSnip',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        dependencies = {
          'rafamadriz/friendly-snippets',
          'saadparwaiz1/cmp_luasnip',
        },
      },
      {
        'roobert/tailwindcss-colorizer-cmp.nvim',
        -- optionally, override the default options:
        config = function()
          require('tailwindcss-colorizer-cmp').setup({
            color_square_width = 1,
          })
        end,
      },
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      lspkind.init({
        symbol_map = {
          Copilot = '',
        },
      })
      vim.api.nvim_set_hl(0, 'CmpItemKindCopilot', { fg = '#6CC644' })
      local cmp_format = lspkind.cmp_format
      local tailwind_format = require('tailwindcss-colorizer-cmp').formatter

      local compare = require('cmp.config.compare')
      local cmp_keymaps = require('pynappo.keymaps').cmp

      local kind_icons = {
        default = {
          -- if you change or add symbol here
          -- replace corresponding line in readme
          Text = '󰉿',
          Method = '󰆧',
          Function = '󰊕',
          Constructor = '',
          Field = '󰜢',
          Variable = '󰀫',
          Class = '󰠱',
          Interface = '',
          Module = '',
          Property = '󰜢',
          Unit = '󰑭',
          Value = '󰎠',
          Enum = '',
          Keyword = '󰌋',
          Snippet = '',
          Color = '󰏘',
          File = '󰈙',
          Reference = '󰈇',
          Folder = '󰉋',
          EnumMember = '',
          Constant = '󰏿',
          Struct = '󰙅',
          Event = '',
          Operator = '󰆕',
          TypeParameter = '',
        },
        codicons = {
          Text = '',
          Method = '',
          Function = '',
          Constructor = '',
          Field = '',
          Variable = '',
          Class = '',
          Interface = '',
          Module = '',
          Property = '',
          Unit = '',
          Value = '',
          Enum = '',
          Keyword = '',
          Snippet = '',
          Color = '',
          File = '',
          Reference = '',
          Folder = '',
          EnumMember = '',
          Constant = '',
          Struct = '',
          Event = '',
          Operator = '',
          TypeParameter = '',
        },
      }

      cmp.setup({
        enabled = function()
          local disabled = false
          disabled = disabled or (vim.bo[0].buftype == 'prompt')
          disabled = disabled or (vim.fn.reg_recording() ~= '')
          disabled = disabled or (vim.fn.reg_executing() ~= '')
          disabled = disabled or vim.g.cmp_disable
          return not disabled
        end,
        performance = {
          max_view_entries = 15,
          async_budget = 2,
        },
        window = {
          completion = {
            autocomplete = false,
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -3,
            side_padding = 0,
          },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = cmp_format({
              mode = 'symbol',
              preset = 'codicons',
              menu = {
                luasnip = '[Snip]',
                nvim_lsp = '[LSP]',
                nvim_lsp_signature_help = '[Sign]',
                nvim_lsp_document_symbol = '[Sym]',
                emoji = '[Emoji]',
                buffer = '[Buf]',
                crates = '[Crate]',
                path = '[Path]',
                cmdline = '[Cmd]',
                cmdline_history = '[Hist]',
                git = '[Git]',
                conventionalcommits = '[Conv]',
                calc = '[Calc]',
              },
            })(entry, vim_item)
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            tailwind_format(entry, vim_item)
            kind.kind = ' ' .. (strings[1] or '') .. ' '
            return kind
          end,
        },
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        completion = { completeopt = vim.o.completeopt },
        mapping = cmp_keymaps.insert(),
        preselect = cmp.PreselectMode.None,
        sources = {
          -- Copilot Source
          { name = 'copilot', group_index = 2 },
          -- Other Sources
          { name = 'nvim_lsp', group_index = 2 },
          { name = 'path', group_index = 2 },
          { name = 'luasnip', group_index = 2 },
          { name = 'emoji', group_index = 2 },
          { name = 'path', group_index = 2 },
          { name = 'crates', group_index = 2 },
          { name = 'calc', group_index = 2 },
          { name = 'nvim_lua', group_index = 2 },
          { name = 'luasnip', group_index = 2 },
          { name = 'nerdfont', group_index = 1 },
          -- {
          --   name = 'buffer',
          --   group_index = 1,
          --   option = {
          --     get_bufnrs = function()
          --       local bufs = {}
          --       for _, win in ipairs(vim.api.nvim_list_wins()) do
          --         bufs[vim.api.nvim_win_get_buf(win)] = true
          --       end
          --       return vim.tbl_keys(bufs)
          --     end,
          --   },
          -- },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.offset,
            compare.exact,
            compare.scopes,
            compare.score,
            compare.locality,
            require('clangd_extensions.cmp_scores'),
            -- function(...) return require('cmp_buffer'):compare_locality(...) end,
            compare.recently_used,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        view = { entries = { name = 'custom', selection_order = 'near_cursor' } },
        experimental = { ghost_text = true },
      })

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'buffer' },
          { name = 'conventionalcommits' },
          { name = 'luasnip' },
        }),
      })
      cmp.setup.cmdline(':', {
        mapping = cmp_keymaps.cmdline(),
        confirmation = { completeopt = 'menu,menuone,noinsert' },
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline' },
        }, {
          { name = 'cmdline_history' },
        }),
      })
      cmp.setup.cmdline('/', {
        mapping = cmp_keymaps.cmdline(),
        sources = cmp.config.sources({ { name = 'nvim_lsp_document_symbol' } }, { { name = 'buffer' } }),
      })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      {
        'zbirenbaum/copilot.lua',
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
        },
      },
    },
    config = function() require('copilot_cmp').setup() end,
  },
  {
    'petertriho/cmp-git',
    ft = { 'gitcommit', 'gitrebase', 'octo' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('cmp_git').setup() end,
  },
  {
    'saecki/crates.nvim',
    event = 'BufRead Cargo.toml',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('crates').setup() end,
  },
}
