set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
 " alternatively, pass a path where Vundle should install plugins
 " let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'
 " Declare the list of plugins.
 Plugin 'Nequo/vim-allomancer'
 Plugin 'vim-airline/vim-airline'
 Plugin 'preservim/nerdtree'
 Plugin 'tpope/vim-surround'
 Plugin 'tmhedberg/SimpylFold'
 Plugin 'vim-scripts/indentpython.vim'
 Plugin 'vim-syntastic/syntastic'
 Plugin 'nvie/vim-flake8'
 Plugin 'lervag/vimtex'
 Plugin 'Shougo/deoplete.nvim'
 if !has('nvim')
         Plugin 'roxma/nvim-yarp'
         Plugin 'roxma/vim-hug-neovim-rpc'
 endif
 Plugin 'Shougo/neosnippet.vim'
 Plugin 'Shougo/neosnippet-snippets'
 " List ends here. Plugins become visible to vim after this.
 call vundle#end()
