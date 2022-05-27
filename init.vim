set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set exrc
set relativenumber
set nu
set nohlsearch
set hidden
set noerrorbells
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=10
set noshowmode
set completeopt=menuone,noinsert,noselect
set termguicolors

set cmdheight=2
set updatetime=50
set shortmess+=c


call plug#begin('~/.vim/plugged')
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'morhetz/gruvbox'
call plug#end()

colorscheme gruvbox
highlight Normal guibg=none ctermbg=none
highlight NonText guibg=none ctermbg=none

let mapleader = " "

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup boris
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END
