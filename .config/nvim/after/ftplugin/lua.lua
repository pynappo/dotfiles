local bufname = vim.api.nvim_buf_get_name(0)
if bufname:find('nvim') then
  vim.opt_local.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]
  vim.opt_local.includeexpr = "tr(v:fname,'.','/')"
  for _, path in pairs(vim.api.nvim_get_runtime_file('lua', true)) do
    vim.opt_local.path:append(path)
  end

  vim.opt_local.suffixesadd:prepend('.lua')
end
