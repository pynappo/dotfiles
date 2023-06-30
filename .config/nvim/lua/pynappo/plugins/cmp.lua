return {
  {
    'hrsh7th/nvim-cmp',
    event = { 'VeryLazy' },
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
      {
        'L3MON4D3/LuaSnip',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        dependencies = {
          'rafamadriz/friendly-snippets',
          'saadparwaiz1/cmp_luasnip',
        },
      },
    },
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      lspkind.init({
        symbol_map = {
          Copilot = "",
        },
      })

      local compare = require('cmp.config.compare')
      cmp.setup {
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
            scrollbar = '║'
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function (entry, vim_item)
            local kind = lspkind.cmp_format({
              mode = "symbol_text",
              menu = {
                luasnip = "[Snip]",
                nvim_lsp = "[LSP]",
                nvim_lsp_signature_help = "[Sign]",
                emoji = "[Emoji]",
                buffer = "[Buf]",
                copilot = "[GHub]",
                crates = "[Crate]",
                path = "[Path]",
                cmdline = "[Cmd]",
                cmdline_history = "[Hist]",
                git = "[Git]",
                conventionalcommits = "[Conv]",
                calc = "[Calc]"
              },
            })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. strings[1] .. " "
            return kind
          end
        },
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        completion = { completeopt = vim.o.completeopt },
        mapping = require("pynappo/keymaps").cmp.insert(),
        preselect = cmp.PreselectMode.None,
        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "crates" },
            { name = 'emoji' },
            { name = 'calc'},
            { name = 'copilot' },
            { name = "path"},
            { name = "nvim_lua" },
          },
          {
            {
              name = 'buffer',
              option = {
                get_bufnrs = function()
                  local bufs = {}
                  for _, win in ipairs(vim.api.nvim_list_wins()) do bufs[vim.api.nvim_win_get_buf(win)] = true end
                  return vim.tbl_keys(bufs)
                end
              }
            }
          }
        ),
        sorting = {
          comparators = {
            function (...) return require("cmp_buffer"):compare_locality(...) end,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        view = { entries = { name = "custom", selection_order = "near_cursor" } },
        experimental = { ghost_text = true },
      }

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
          { name = 'buffer' },
          { name = 'conventionalcommits' },
          { name = 'luasnip' },
        })
      })
      cmp.setup.cmdline(':', {
        mapping = require('pynappo.keymaps').cmp.insert(),
        confirmation = { completeopt = 'menu,menuone,noinsert' },
        sources = cmp.config.sources( {
          { name = 'cmdline_history' },
          { name = 'path' },
          { name = 'cmdline' },
        })
      })
      cmp.setup.cmdline('/', {
        mapping = require('pynappo.keymaps').cmp.insert(),
        sources = cmp.config.sources(
          { { name = 'nvim_lsp_document_symbol' } },
          { { name = 'buffer' } }
        )
      })
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      { 'zbirenbaum/copilot.lua', config = function() require('copilot').setup() end },
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
