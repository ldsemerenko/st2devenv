" Configuration file for vim

version 4.0		" avoid warning for wrong version

set number
set ruler
set showmatch
set smarttab
set smd
set tabstop=4
"set softtabstop=4
set expandtab

hi LineNr term=bold
set textwidth=0
set sw=4
set bs=2		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set tw=78		" always limit the width of text to 78
set nobackup
set viminfo='10,\"10,:20

" Makefile auto command
autocmd FileType make setlocal noexpandtab

" When starting to edit a file:
"   For *.c and *.h files set formatting of comments and set C-indenting on
"   For other files switch it off
"   Don't change the sequence, it's important that the line with * comes first.
autocmd BufRead * set formatoptions=tcql nocindent comments&
autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://

" Enable editing of gzipped files
"    read: set binary mode before reading the file
"          uncompress text in buffer after reading
"   write: compress file after writing
"  append: uncompress file, append, compress file
autocmd BufReadPre,FileReadPre      *.gz set bin
autocmd BufReadPost,FileReadPost    *.gz '[,']!gunzip
autocmd BufReadPost,FileReadPost    *.gz set nobin

autocmd BufWritePost,FileWritePost  *.gz !mv <afile> <afile>:r
autocmd BufWritePost,FileWritePost  *.gz !gzip <afile>:r

autocmd FileAppendPre               *.gz !gunzip <afile>
autocmd FileAppendPre               *.gz !mv <afile>:r <afile>
autocmd FileAppendPost              *.gz !mv <afile> <afile>:r
autocmd FileAppendPost              *.gz !gzip <afile>:r

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

syntax on
