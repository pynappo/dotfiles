require("neoscroll").setup({
  easing_function = "quadratic"
})

local t    = {}
t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200", [["sine"]] } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200", [["sine"]] } }
t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "200", [["circular"]] } }
t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "200", [["circular"]] } }
t["<C-y>"] = { "scroll", { "-0.10", "false", "200", nil } }
t["<C-e>"] = { "scroll", { "0.10", "false", "200", nil } }
t["zt"]    = { "zt", { "200" } }
t["zz"]    = { "zz", { "200" } }
t["zb"]    = { "zb", { "200" } }

require("neoscroll.config").set_mappings(t)
