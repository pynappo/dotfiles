local luasnip = require("luasnip")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
local lspkind = require("lspkind")


-- put this to setup function and press <a-e> to use fast_wrap
require("nvim-autopairs").setup({
  enable_check_bracket_line = false,
  check_ts = true,
  ignored_next_char = "[%w%.]",
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", "\"", "'" },
    pattern = [=[[%"%"%)%>%]%)%}%,]]=],
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey = "Comment"
  },
})
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
    ["<C-Space>"] = cmp.mapping.complete({
      reason = cmp.ContextReason.Auto,
    }),
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
    { name = "nvim_lsp_signature_help" },
    { name = "crates" },
    { name = "path"}
  },
  view = { entries = { name = "custom", selection_order = "near_cursor" } },
}

cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources(
    {{ name = 'git' }},
    {{ name = 'buffer' }}
  )
})
require("cmp_git").setup()
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
