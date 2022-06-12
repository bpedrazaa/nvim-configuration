" PLUGINS
call plug#begin('~/.vim/plugged')
  Plug 'morhetz/gruvbox'                            "Theme
  Plug 'nvim-telescope/telescope.nvim'              "Fuzzy Finder
  Plug 'tpope/vim-fugitive'                         "Git management
  Plug 'preservim/nerdtree'                         "File explorer
  Plug 'Xuyuanp/nerdtree-git-plugin'                "NerdTree Git Plugin
  Plug 'ryanoasis/vim-devicons'                     "Icons
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'    "NerdTree Syntax Highlight
  Plug 'neoclide/coc.nvim', {'branch': 'release'}   "Autocompletion
  Plug 'vim-airline/vim-airline'                    "Status/Tabline
  Plug 'preservim/nerdcommenter'                    "Comments
  Plug 'airblade/vim-gitgutter'											"Git Gutter (Shows git diff in side column)
  "Plug 'honza/vim-snippets'                         "Vim Snippets
  "Plug 'sheerun/vim-polyglot'                       "Language packs
call plug#end()


colorscheme gruvbox
highlight Normal guibg=none ctermbg=none
highlight NonText guibg=none ctermbg=none
set termguicolors

" ====== CONFIGURATIONS ======
"View
set relativenumber                                  "Enable rel numbers
set number                                          "Show number of row
syntax on                                           "Syntax Highlighting
set nowrap                                          "Do not wrap lines
set ruler                                           "Display cursor position in file
set nocompatible
set smartindent

"Tools
set tabstop=2                                       "Number of columns occupied by a tab
set shiftwidth=2                                    "Width for autoindent
set expandtab																				"Convert tabs to white space
set softtabstop=2                                   "See multiple spaces as tabstops
set autoindent                                      "Enable autoindentation
set scrolloff=10

filetype on                                         "Enable file type detection
filetype plugin on                                  "Enable/Load plugin for detected file type
filetype indent on                                  "Load indent file for detected file type

"Stop generation of files and alerts
set noerrorbells                                    "Disable beeping
set belloff=all                                     "Disable all bells
set nobackup                                        "Do not create a backup file
set nowritebackup                                   "Do not create a backup file during a write procedure
set noswapfile                                      "Do not create a swap file
set noundofile                                      "Do not create a undo file

"Search
set incsearch                                       "Incrementally highlight matching characters
set hlsearch                                        "Use highlighting when doing the search
set showmatch                                       "Show matching words during a search

"Others
set exrc
set hidden
set scrolloff=10
set completeopt=menuone,noinsert,noselect

set cmdheight=2
set updatetime=50
set shortmess+=c

let mapleader = " "

" ============ UTILITIES ============

" ==== NERDTree ====

" Show hidden Files in NerdTree
let NERDTreeShowHidden=1

" Toggle NERDTree
nmap <C-n> :NERDTreeToggle<CR>

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Sync open file with NERDTree, Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()


" ==== Git NERDtree plugin ====
let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ 'Modified'  :'',
  \ 'Staged'    :'✚',
  \ 'Untracked' :'✭',
  \ 'Renamed'   :'➜',
  \ 'Unmerged'  :'═',
  \ 'Deleted'   :'✖',
  \ 'Dirty'     :'✗',
  \ 'Ignored'   :'☒',
  \ 'Clean'     :'✔︎',
  \ 'Unknown'   :'?',
\ }

" ==== Nerd Commenter ====
nmap z/ <plug>NERDCommenterToggle
vmap z/ <plug>NERDCommenterToggle


" ==== Coc Prettier ====
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
noremap <C-f> :Prettier<CR>

" ===== FUNCTIONS =====
" Eliminate whitespaces
fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup boris
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END
