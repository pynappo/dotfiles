local status, npairs = pcall(require, "nvim-autopairs");
if not status then return end
-- put this to setup function and press <a-e> to use fast_wrap
npairs.setup({
  enable_check_bracket_line = false,
  check_ts = true,
  ignored_next_char = "[%w%.]",
  ts_config = {
    lua = { "string" }, -- it will not add a pair on that treesitter node
    javascript = { "template_string" },
    java = false, -- don"t check treesitter on java
  },
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
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
