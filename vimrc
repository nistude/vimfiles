" General
let loaded_matchparen = 1
set modelines=0
set nocompatible
"" vim 7.3
"" set relativenumber
set ruler
set showcmd
set showmatch
set showmode

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
colorscheme desert
syntax on

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

" Perl
au FileType perl set ai cindent

" Puppet
au FileType puppet set ai et list sts=2 sw=2
au FileType puppet :call ExtractSnipsFile('~/.vim/bundle/vim-puppet/snippets/puppet.snippets', &ft)

" Ruby
au FileType cucumber set ai et list sts=2 sw=2
au FileType eruby set ai cindent et list sts=2 sw=2
au FileType ruby set ai cindent et list sts=2 sw=2

" Text
au BufRead,BufNewFile *.ronn set ft=markdown
au FileType html set ai cindent et list sts=2 sw=2
au FileType markdown set ai et formatoptions=tcroqn2 list sts=4
au FileType yaml set ai cindent et list sts=2 sw=2

" Reminders
"" nerdcommenter:
""   toggle comment: [count]<leader>c<space>
"" vim-matchit:
""   % to bounce from do to end, etc.
"" vim-surround:
""   change surrounding X to Y: csXY
