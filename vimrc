" Load pathogen
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on

" General
let loaded_matchparen = 1
let xml_use_xhtml = 1

" http://stackoverflow.com/questions/16902317/vim-slow-with-ruby-syntax-highlighting
set re=1

set cursorline
set modelines=0
set nocompatible
set ruler
set showcmd
set showmatch
set splitbelow
set splitright

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
" copy selection to system clipboard
vmap <C-c> "+y

" Filetypes
au BufRead,BufNewFile *.html.erb set ft=eruby.html
au BufRead,BufNewFile *.md set ft=markdown
au BufRead,BufNewFile *.rake set ft=ruby
au BufRead,BufNewFile *.ronn set ft=markdown
au BufRead,BufNewFile *_spec.rb set ft=ruby.rspec
au BufRead,BufNewFile Guardfile set ft=ruby
au BufRead,BufNewFile Vagrantfile set ft=ruby

" zg -> add good word to dictionary
" z= -> suggest alternative
set spelllang=en_gb,de_de
au BufRead,BufNewFile *.md setlocal spell
au FileType gitcommit setlocal spell
au FileType mail setlocal spell

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
if executable("ag")
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
let g:EasyGrepMode=0
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=0
let g:EasyGrepCommand=1
let g:EasyGrepEveryMatch=1

" Completions
set wildmenu

" Statusbar
set laststatus=2
let g:Powerline_symbols = 'unicode'
call Pl#Theme#RemoveSegment('mode_indicator')
call Pl#Theme#RemoveSegment('fugitive:branch')

" syntastic
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_auto_jump=1

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

" Snake Paste for simple_bdd gem
map <leader>sp :call SnakeCasePaste()<cr>"ap==$a<cr>

function! SnakeCasePaste()
  let statement = substitute(@", "^.* \\('\\|\"\\)\\(.*\\)\\('\\|\"\\)", '\2', '')
  let method_name = substitute(statement, " ", "_", "g")
  let method = 'def ' . tolower(method_name)
  call setreg('a', method)
endfunction

" delete mail body upto, but not including signature
nnoremap <leader>dm :.,/^-- /-1d<return>:noh<return>O
" git shortcuts
nnoremap <leader>ga :Git add .<return><return>:Gcommit<return>

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
au FileType gitconfig setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
au FileType html :call ExtractSnips('~/.vim/snippets', &ft)
au FileType javascript setlocal shiftwidth=4 softtabstop=4
au FileType json setlocal shiftwidth=4 softtabstop=4
au FileType markdown setlocal formatoptions=tcroqn2 sts=4
au FileType puppet :call ExtractSnips('~/.vim/bundle/vim-puppet/snippets', &ft)
au FileType rspec :call ExtractSnips('~/.vim/snippets', &ft)
au FileType scss setlocal shiftwidth=4 softtabstop=4
au FileType sh setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
au FileType snippet setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

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
  let runner = TestRunner()
  let file = expand('%') . ':' . line('.')
  call RememberTestCommand(runner, file)
  call RunTest(runner, file)
endfunction

function! RunCurrentTestFile()
  let runner = TestRunner()
  let file = expand('%')
  call RememberTestCommand(runner, file)
  call RunTest(runner, file)
endfunction

function! RunLastTestFile()
  if exists('t:last_test_command')
    call RunTest(t:last_test_command, t:last_test_file)
  endif
endfunction

function! TestRunner()
  if findfile('.zeus.sock', '.;') != ''
    let zeus = 1
  else
    let zeus = 0
  endif

  if match(expand('%'), '_spec\.rb$') != -1
    return zeus ? 'zspec' : 'rspec'
  elseif match(expand('%'), '\.feature$') != -1
    return zeus ? 'zucumber' : 'cucumber'
  endif
endfunction

function! RememberTestCommand(command, file)
  let t:last_test_command = a:command
  let t:last_test_file = a:file
endfunction

function! RunTest(command, file)
  execute ":w\|Dispatch " . a:command . ' ' a:file
endfunction
