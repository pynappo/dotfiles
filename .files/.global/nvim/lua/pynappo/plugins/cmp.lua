local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup {
  window = {
    completion = {
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
      border = 'rounded',
      scrollbar = '║'
    },
    documentation = { -- no border; native-style scrollbar
      border = nil,
      scrollbar = '',
    },
  },
  formatting = {
    format = lspkind.cmp_format({ 
      mode = "symbol_text", 
      menu = ({
        buffer = "[Buf]",
        nvim_lsp = "[LSP]",
        nvim_lua =  "[Lua]",
        luasnip = "[Snip]",
        copilot = "[GHub]"
      })
    })
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  confirmation = { completeopt = 'menu,menuone,noinsert' },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s", 'c' }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s", 'c' }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "copilot" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" }
  },
  view = { entries = { name = "custom", selection_order = "near_cursor" } },
}

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
cmp.setup.cmdline(':', {
  confirmation = { completeopt = 'menu,menuone,noinsert' },
  sources = {
    { name = 'cmdline' },
    { name = 'cmdline_history' }
  }
})
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  },
})
