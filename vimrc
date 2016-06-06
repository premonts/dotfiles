"""""""""""""""""""""""""""
" Pathogen 
"""""""""""""""""""""""""""
execute pathogen#infect()

"""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""
" Enable filetype plugin
filetype plugin on
filetype indent on
set omnifunc=syntaxcomplete#Complete

if has("win32")
    let g:fugitive_git_executable = "\"c:\\Program Files\\Git\\bin\\git.exe\""
endif

let mapleader = ","
let g:mapleader = ","

nmap <leader>w :w!<cr>
nmap <leader>wq :wq!<cr>
nmap <leader>q :q!<cr>

nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

nnoremap <leader>cd :cd %:p:h<CR>

inoremap jk <esc>
set nocompatible


"""""""""""""""""""""""""""
" VIM user interface
"""""""""""""""""""""""""""
" set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Always show current position
set ruler

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Show line number
set number

" Use relative line number (the current line is 0 and decrement
" going up and increment going down the file
set relativenumber


"""""""""""""""""""""""""""
" Colors and fonts
"""""""""""""""""""""""""""
syntax enable

colorscheme desert
set background=dark

if has("win32")
    set encoding=latin1
    set ffs=dos,unix,mac
else
    set encoding=utf8
    set ffs=unix,dos,mac
endif


"""""""""""""""""""""""""""
" Files, backups and undo
"""""""""""""""""""""""""""
set nobackup
set nowb
set noswapfile



"""""""""""""""""""""""""""
" Text, tab and indent related
"""""""""""""""""""""""""""
" User spaces instead of tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

set ai "Auto indent
set si "Smart indent

"""""""""""""""""""""""""""
" Visual mode related
"""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>


"""""""""""""""""""""""""""
" Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""
map j gj
map k gk

map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>te :tabe<space>
map <leader>tm :tabmove

map <leader>n :bn<cr>
map <leader>b :bp<cr>
map <leader>d :bw<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>


"""""""""""""""""""""""""""
" Status line
"""""""""""""""""""""""""""

set laststatus=2
set statusline=\ %{HasPaste()}
set statusline+=%F%m%r%h\ %w
set statusline+=\ \ 
set statusline+=CWD:\ %r%{getcwd()}%h
set statusline+=\ \ 
set statusline+=FileType:\ %y
set statusline+=\ \  
set statusline+=Line:\ %l
""""""""""""""""""""""""""
" Editing mappings
""""""""""""""""""""""""""
" Move a line of text using ALT+[jk] Comamnd+[jk] on mac
nmap <A-j> mz:m+<cr>`z
nmap <A-k> mz:m-2<cr>`z
vmap <A-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <A-k> :m'<-2<cr>`>my`<mzgv`yo`z

"""""""""""""""""""""""""""
" vim-repeat
"""""""""""""""""""""""""""
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

set diffexpr=MyDiff()
function! MyDiff()
   let opt = '-a --binary '
   if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
   if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
   let arg1 = v:fname_in
   if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
   let arg2 = v:fname_new
   if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
   let arg3 = v:fname_out
   if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
   if $VIMRUNTIME =~ ' '
     if &sh =~ '\<cmd'
       if empty(&shellxquote)
         let l:shxq_sav = ''
         set shellxquote&
       endif
       let cmd = '"' . $VIMRUNTIME . '\diff"'
     else
       let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
     endif
   else
     let cmd = $VIMRUNTIME . '\diff'
   endif
   silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
   if exists('l:shxq_sav')
     let &shellxquote=l:shxq_sav
   endif
 endfunction

