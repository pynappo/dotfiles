local autocmd = vim.api.nvim_create_autocmd

autocmd('BufEnter', {
    group = num_au,
    pattern = '*.txt',
    callback = function()
        if vim.bo.buftype == 'help' then
            A.nvim_command('wincmd L')
            A.nvim_buf_set_keymap(0, 'n', 'q', '<CMD>q<CR>', { noremap = true })
        end
    end,
})
