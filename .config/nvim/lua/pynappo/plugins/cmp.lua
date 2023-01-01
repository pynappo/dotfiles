local luasnip = require("luasnip")
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
      border = nil,
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
          nvim_lua =  "[Lua]",
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
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  completion = { completeopt = 'menu,menuone,noinsert,noselect' },
  mapping = require("pynappo/keymaps").cmp.insert(),
  sources = cmp.config.sources(
    {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "crates" },
      { name = 'emoji' },
      { name = 'calc'},
    },
    {
      { name = 'copilot' },
      { name = "nvim_lua" },
      { name = "path"},
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
  sources = cmp.config.sources( {
    { name = 'git' },
    { name = 'buffer' },
    { name = 'conventionalcommits' },
    { name = 'luasnip' },
  })
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done())
cmp.setup.cmdline(':', {
  confirmation = { completeopt = 'menu,menuone,noinsert' },
  sources = cmp.config.sources( {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path' },
  })
})
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  },
})
















