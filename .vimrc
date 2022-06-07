colorscheme delek
au BufNewFile,BufRead *.cu set ft=cuda
au BufNewFile,BufRead *.cuh set ft=cuda
set background=dark
set number
set smartindent
set autoindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set showmatch
set hlsearch
autocmd FileType python :setlocal tabstop=4 softtabstop=4 shiftwidth=4
syntax on
highlight Search ctermfg=white ctermbg=magenta
highlight OverLength ctermfg=white ctermbg=darkred
match OverLength /\&81v./

function! ToggleNumber()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap ,m :call ToggleNumber()<CR>
