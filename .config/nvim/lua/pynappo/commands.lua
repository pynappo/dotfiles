local command = vim.api.nvim_create_user_command
-- cd to current file
command("CDhere", "cd %:p:h", {})
