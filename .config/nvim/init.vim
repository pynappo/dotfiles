set nomodeline
set modelines=0
imap ;; <Esc>

" more natural windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" save as root trick
cmap w!! w !sudo tee > /dev/null %
