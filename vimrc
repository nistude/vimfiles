" General
let loaded_matchparen = 1
set modelines=0
set nocompatible
set relativenumber
set ruler
set showcmd
set showmatch

" Highlighting
colorscheme desert
syntax on
highlight OverLength ctermfg=red
match OverLength /\%>80v.\+/

" Editing
set backspace=indent,eol,start
set esckeys
set listchars=trail:.,extends:>,tab:>-
set nolist
set pastetoggle=<F12>

" Filetypes
filetype off " forces reload
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
au BufRead,BufNewFile *.html.erb set ft=eruby.html
au BufRead,BufNewFile *.md set ft=markdown
au BufRead,BufNewFile *.rake set ft=ruby
au BufRead,BufNewFile *.ronn set ft=markdown
au BufRead,BufNewFile *_spec.rb set ft=ruby.rspec

" Searching
set hlsearch
set ignorecase
set incsearch
set smartcase

" Completions
set wildmenu

" Navigating Tabs
""   :tabnew
""   :tabclose
""   CTRL-PageUp / CTRL-PageDown

" Navigating Windows
""   vertical split	:vsplit -> CTRL-w v
""   vertical split new	:vnew

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
au FileType cucumber set ai et list sts=2 sw=2
au FileType eruby set ai cindent et list sts=2 sw=2
au FileType eruby :call ExtractSnips('~/.vim/snippets', &ft)
au FileType html set ai cindent et list sts=2 sw=2
au FileType html :call ExtractSnips('~/.vim/snippets', &ft)

au FileType markdown set ai et formatoptions=tcroqn2 list sts=4

au FileType perl set ai cindent
au FileType puppet set ai et list sts=2 sw=2
au FileType puppet :call ExtractSnips('~/.vim/bundle/vim-puppet/snippets', &ft)

au FileType rspec :call ExtractSnips('~/.vim/snippets', &ft)
au FileType ruby set ai cindent et list sts=2 sw=2

au FileType yaml set ai cindent et list sts=2 sw=2

" Reminders
"" nerdcommenter:
""   toggle comment: [count]<leader>c<space>
""   <leader> == \
"" vim-matchit:
""   % to bounce from do to end, etc.
"" vim-surround:
""   change surrounding X to Y: csXY
