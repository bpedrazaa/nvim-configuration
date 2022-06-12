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
  Plug 'honza/vim-snippets'                         "Vim Snippets
  Plug 'vim-airline/vim-airline-themes'
  "Plug 'sheerun/vim-polyglot'                       "Language packs
call plug#end()

let g:airline_theme='dark'

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
let g:NERDTreeWinSize=20

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

" ==== COC Configuration ====
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
