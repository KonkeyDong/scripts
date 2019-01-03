set showmatch
set number
set expandtab
set tabstop=4
set shiftwidth=4
set ruler
syntax on

" Automatically deletes all trailing whitespace on save.
autocmd BufWritePre * %s/\s\+$//e
