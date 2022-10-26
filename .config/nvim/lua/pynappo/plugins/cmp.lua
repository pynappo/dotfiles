local luasnip = require("luasnip")
local cmp = require("cmp")
local lspkind = require("lspkind")
lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
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
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto, }),
    ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s", 'c' }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s", 'c' }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lua"},
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
