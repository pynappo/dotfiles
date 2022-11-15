local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require("lspkind")
lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})

cmp.setup {
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
      border = nil,
      scrollbar = '║'
    },
    documentation = { -- no border; native-style scrollbar
      border = 'rounded',
      scrollbar = '',
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
          nvim_lua =  "[Lua]",
          buffer = "[Buf]",
          copilot = "[GHub]",
          crates = "[Crate]",
          path = "[Path]",
          cmdline = "[Cmd]",
          cmdline_history = "[Hist]",
          git = "[Git]",
        },
        symbol_map = { Copilot = "" }
      })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })
      kind.kind = " " .. strings[1] .. " "
      return kind
    end
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  confirmation = { completeopt = 'menu,menuone,noinsert' },
  mapping = require("pynappo/keymaps").cmp.insert(),
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua"},
    { name = "copilot" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
    { name = "crates" },
    { name = "path"},
    {name = 'emoji'}

  },
  view = { entries = { name = "custom", selection_order = "near_cursor" } },
}

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources(
    {{ name = 'git' }},
    {{ name = 'buffer' }},
    {{ name = 'conventionalcommits' }},
    {{ name = 'luasnip' }}
  )
})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup.cmdline(':', {
  confirmation = { completeopt = 'menu,menuone,noinsert' },
  sources = {
    { name = 'cmdline' },
    { name = 'cmdline_history' },
    { name = 'path'}
  }
})
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  },
})
