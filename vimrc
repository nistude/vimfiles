" General
let loaded_matchparen = 1
let xml_use_xhtml = 1

set modelines=0
set nocompatible
set ruler
set showcmd
set showmatch

" Editing
set autoindent
set backspace=indent,eol,start
set cindent
set esckeys
set expandtab
set list
set listchars=trail:.,extends:>,tab:>-
set nolist
set pastetoggle=<F12>
set shiftwidth=2
set softtabstop=2

" Filetypes
filetype off " forces reload
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
au BufRead,BufNewFile *.html.erb set ft=eruby.html
au BufRead,BufNewFile *.md set ft=markdown
au BufRead,BufNewFile *.rake set ft=ruby
au BufRead,BufNewFile *.ronn set ft=markdown
au BufRead,BufNewFile *_spec.rb set ft=ruby.rspec foldenable foldlevel=2

" Highlighting
syntax on
set background=dark
colorscheme hemisu
highlight OverLength ctermfg=red
match OverLength /\%>80v.\+/
"highlight ColorColumn ctermbg=darkgrey
"set colorcolumn=80

" Folding
" syntax or indent
set foldmethod=syntax
set foldnestmax=5
set nofoldenable
set foldlevel=2

" Searching
set hlsearch
set ignorecase
set incsearch
set smartcase
" does not interfere with insert mode
nnoremap <silent> <return> :noh<return>

" Completions
set wildmenu

" Editor behaviour
"" format current paragraph according to textwidth
imap <C-J> <C-O>gqap
nmap <C-J>      gqap
vmap <C-J>      gq
"" set title in xterm
let &titlestring = expand("%:t")
set title
"" http://vim.wikia.com/wiki/Remove_unwanted_spaces
"" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
:endfunction

au FileWritePre * :call TrimWhiteSpace()
au FileAppendPre * :call TrimWhiteSpace()
au FilterWritePre * :call TrimWhiteSpace()
au BufWritePre * :call TrimWhiteSpace()

" Languages
au FileType eruby :call ExtractSnips('~/.vim/snippets', &ft)
au FileType html :call ExtractSnips('~/.vim/snippets', &ft)
au FileType html let g:html_indent_tags = g:html_indent_tags.'\|p'
au FileType json set sts=4
au FileType mail colorscheme desert
au FileType markdown set formatoptions=tcroqn2 sts=4
au FileType puppet :call ExtractSnips('~/.vim/bundle/vim-puppet/snippets', &ft)
au FileType rspec :call ExtractSnips('~/.vim/snippets', &ft)
