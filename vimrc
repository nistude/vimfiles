" Load pathogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on

" General
let loaded_matchparen = 1
let xml_use_xhtml = 1

set cursorline
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
set listchars=trail:.,extends:>,tab:>-
set nolist
set pastetoggle=<F12>
set shiftwidth=2
set softtabstop=2

" Filetypes
au BufRead,BufNewFile *.html.erb set ft=eruby.html
au BufRead,BufNewFile *.md set ft=markdown
au BufRead,BufNewFile *.rake set ft=ruby
au BufRead,BufNewFile *.ronn set ft=markdown
au BufRead,BufNewFile *_spec.rb set ft=ruby.rspec
au BufRead,BufNewFile Guardfile set ft=ruby
au BufRead,BufNewFile Vagrantfile set ft=ruby

" Highlighting
syntax on
set background=dark
colorscheme hemisu
set colorcolumn=80
" tweak mail highlighting
hi def link mailSubject Statement
hi def link mailQuoted1 Delimiter
hi def link mailQuoted2 Comment
" tweak gitcommit highlighting
hi def link gitcommitOverflow Error

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

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
let g:ctrlp_extensions = ['tag']
let g:ctrlp_cmd = 'CtrlPTag'
nnoremap <silent> <F9> :TagbarToggle<CR>
" use :tjump by default (jump to single tag or list multiple)
nnoremap <c-]> g<c-]>
vnoremap <c-]> g<c-]>
" does not interfere with insert mode
nnoremap <silent> <return> :noh<return>

" Search and Replace
" 0 - All
" 1 - Buffers
" 2 - Track
let g:EasyGrepMode=2
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=0

" Completions
set wildmenu

" Statusbar
set laststatus=2
let g:Powerline_symbols = 'unicode'
call Pl#Theme#RemoveSegment('mode_indicator')
call Pl#Theme#RemoveSegment('fugitive:branch')

" Allow Ctrl+PgUp/PgDn in tmux
if &term == "screen-256color"
  set t_kN=[6;*~
  set t_kP=[5;*~
endif

" Editor behaviour
"" format current paragraph according to textwidth
imap <C-J> <C-O>gqap
nmap <C-J>      gqap
vmap <C-J>      gq
"" set title in xterm
let &titlestring = expand("%:t")
set title
" indented paste
nnoremap <leader>p p`[v`]=
nnoremap <leader>P P`[v`]=

" highlight trailing whitespace
highlight ExtraWhitespace ctermbg=88
match ExtraWhitespace /\s\+$/
" activate for all windows
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" don't match in insert mode
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" manually remove trailing whitespace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Restore cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Languages
au FileType eruby :call ExtractSnips('~/.vim/snippets', &ft)
au FileType html :call ExtractSnips('~/.vim/snippets', &ft)
au FileType json set sts=4
au FileType markdown set formatoptions=tcroqn2 sts=4
au FileType puppet :call ExtractSnips('~/.vim/bundle/vim-puppet/snippets', &ft)
au FileType rspec :call ExtractSnips('~/.vim/snippets', &ft)
au FileType sh set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
au FileType snippet set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

" align blocks on first '='
command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>
function! AlignSection(regex) range
  let extra = 1
  let sep = empty(a:regex) ? '=' : a:regex
  let maxpos = 0
  let section = getline(a:firstline, a:lastline)
  for line in section
    let pos = match(line, ' *'.sep)
    if maxpos < pos
      let maxpos = pos
    endif
  endfor
  call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
  call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, maxpos, extra)
  let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
  if empty(m)
    return a:line
  endif
  let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
  return m[1] . spaces . m[2]
endfunction

" test stuff
" detects specs and features, uses zeus or bundle exec
map <leader>s :call RunSingleTestCase()<cr>
map <leader>t :call RunCurrentTestFile()<cr>
map <leader>l :call RunLastTestFile()<cr>

function! RunSingleTestCase()
  let l:command = TestRunner() . @% . ':' . line('.')
  call SetLastTestCommand(l:command)
  call RunTest(l:command)
endfunction

function! RunCurrentTestFile()
  let l:command = TestRunner() . @%
  call SetLastTestCommand(l:command)
  call RunTest(l:command)
endfunction

function! RunLastTestFile()
  if exists('t:last_test_command')
    call RunTest(t:last_test_command)
  endif
endfunction

function! TestRunner()
  if findfile('.zeus.sock', '.;') != ''
    let l:testrunner = 'zeus'
  elseif findfile('Gemfile', '.;') != ''
    let l:testrunner = 'bundle exec'
  else
    let l:testrunner = ''
  endif

  if match(expand('%'), '_spec\.rb$') != -1
    return l:testrunner . ' rspec '
  elseif match(expand('%'), '\.feature$') != -1
    return l:testrunner . ' cucumber '
  endif
endfunction

function! SetLastTestCommand(command)
  let t:last_test_command = a:command
endfunction

function! RunTest(command)
  execute ":w\|!clear && echo " . a:command . " && echo && " . a:command
endfunction
