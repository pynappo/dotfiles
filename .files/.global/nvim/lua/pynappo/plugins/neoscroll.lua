require("neoscroll").setup({
  easing_function = "quadratic"
})

local t    = {
  ["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "200", [["sine"]] } },
  ["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "200", [["sine"]] } },
  ["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "200", [["circular"]] } },
  ["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "200", [["circular"]] } },
  ["<C-y>"] = { "scroll", { "-0.10", "false", "200", nil } },
  ["<C-e>"] = { "scroll", { "0.10", "false", "200", nil } },
  ["zt"]    = { "zt", { "200" } },
  ["zz"]    = { "zz", { "200" } },
  ["zb"]    = { "zb", { "200" } }
}

require("neoscroll.config").set_mappings(t)
