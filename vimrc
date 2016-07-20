" ------------------------------------------------------------------------
" -----------------------------   vimrc   --------------------------------
" ------------------------------------------------------------------------

" ------------------------------- System ---------------------------------
" ------------------------------------------------------------------------

" --------- Plugin Manager ---------
" ----------------------------------

" Setup NeoBundle
if has("win32")
  set runtimepath+=~/vimfiles/bundle/neobundle.vim/
  call neobundle#rc(expand('~/vimfiles/bundle/'))
else
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif


call plug#begin('~/.vim/plugged')


" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" Original repos
Plug 'altercation/vim-colors-solarized'
Plug 'crusoexia/vim-monokai'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'cespare/vim-toml'
Plug 'digitaltoad/vim-jade'
Plug 'editorconfig/editorconfig-vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'honza/vim-snippets'
Plug 'jelera/vim-javascript-syntax'
Plug 'JuliaLang/julia-vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-rails'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips'
Plug 'sjl/gundo.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/bufkill.vim'
Plug 'vim-scripts/genutils'
Plug 'vim-scripts/ini-syntax-definition'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-scripts/vcscommand.vim'
Plug 'tpope/vim-endwise'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-bundler'
Plug 'kchmck/vim-coffee-script'
Plug 'wting/rust.vim'
Plug 'junegunn/goyo.vim'

" Original mirrors
Plug 'voithos/vim-multiselect'
Plug 'godlygeek/tabular'
Plug 'fatih/vim-go'
Plug 'plasticboy/vim-markdown'
Plug 'ervandew/supertab'
" Plug 'Yggdroot/indentLine'
" Forks
Plug 'voithos/vim-colorpack'
Plug 'rodjek/vim-puppet'
Plug 'whatyouhide/vim-gotham'
Plug 'junegunn/vim-easy-align'
Plug 'xolox/vim-misc'
Plug 'lambdalisue/vim-fullscreen'



Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-dispatch'
Plug 'briancollins/vim-jst'
Plug 'jiangmiao/auto-pairs'

" Plug 'Shougo/deoplete.nvim'
Plug 'altercation/vim-colors-solarized'
Plug 'dkprice/vim-easygrep'
Plug 'tomasr/molokai'
" Plug 'tpope/vim-vinegar'
Plug 'ngmy/vim-rubocop'
Plug 'benmills/vimux'
Plug 'jingweno/vimux-zeus'
Plug 'lambdalisue/vim-fullscreen'


call plug#end()
" Platform-specific
if has("win32")
  NeoBundle 'vim-scripts/aspnetcs'
else
  NeoBundle 'majutsushi/tagbar'
  NeoBundle 'vim-scripts/AutoTag'
endif

" Turn on filetype plugin and indentation handling
filetype plugin indent on

NeoBundleCheck

" --------------------------

" Set map leader
let mapleader = ','

" ------------------------------- General --------------------------------
" ------------------------------------------------------------------------
" Make Vim more useful than Vi
set nocompatible

" Increase history size
set history=1000

" Allow changing of buffers without saving
set hidden

" Set the directory of the swap file
" The // indicates that the swap name should be globally unique
set directory=~/.vim/tmp//,/tmp//

" Enable backup files and specify backup directories
set backupdir=~/.vim/backup//,/tmp//
set backup

" Enable undo
set undodir=~/.vim/undo
set undofile

" Specify spelling file
set spellfile=~/.vim/spell/spell.utf-8.add

" Enable viminfo file, and create autocmd to restore file
" position between edits
set viminfo='10,<100,:20,%

function! ResCur()
  if line("'\"") < line("$")
    normal! g'"
    return 1
  endif
endfunction


autocmd BufReadPost * call ResCur()

" Use the bash shell
set shell=/bin/bash

" Use UTF-8 for internal text
set encoding=utf-8

" Try the following EOL formats when opening a new file
set fileformats=unix,dos,mac

" Automatically insert comment leader
set formatoptions=q

" Do not redraw while running macros
set lazyredraw

" Lower keycode timeout, to avoid lag when using <ESC> in terminal vim
" (ESC is a common starting character for terminal escape sequences)
set ttimeoutlen=100

" ------------------------------- Editing --------------------------------
" ------------------------------------------------------------------------
" Make backspace more flexible
set backspace=eol,start,indent

" Turn on syntax highlighting
syntax enable

" Set the tab stop to the given value and enable tab-to-space expansion
set tabstop=2
set shiftwidth=2
set expandtab

" Make sure that <BS> deletes a "shiftwidth" worth of spaces
set smarttab

" Make the indent carry to the next line
set autoindent

" Jump to the corresponding brace when inserting closing braces
" for the given time, in tenths of a second
set showmatch
set matchtime=3

" ------------------------------ Interface -------------------------------
" ------------------------------------------------------------------------
" Set options for GUI vs shell
if has("gui_running")
  " Disable the toolbar
  set guioptions-=T
  set t_Co=256

  " Set theme options
  syntax enable
  " let g:solarized_contrast = "high"
  " let g:solarized_visibility = "low"
  " Set theme options

  syntax enable

  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove right-hand scroll bar

  " Set font
  if has("win32")
    set guifont=Consolas:h10:b:cANSI
  else
    set guifont=Ubuntu\ Mono\ derivative\ Powerline\ Bold\ 16 
  endif

  " Disable the toolbar
  set guioptions-=T "remove toolbar
  set guioptions-=r "remove right-hand scroll bar
  set guioptions-=L "remove left-hand scroll bar. Fix for TagBar.

  " Set theme options
  set background=dark
  set t_Co=256
  syntax enable
  set background=dark
  colorscheme Tomorrow-Night-Eighties

else
  " Enable more colors for the terminal
  set t_Co=256
  syntax enable
  set background=dark
  colorscheme Tomorrow-Night-Eighties

endif

" Turn on Wild Menu for command completion
set wildmenu

" Set the title to be more meaningful
set title

" Keep the screen neat by not wrapping long lines
" set nowrap

set wrap " wrap lines, we dont want long lines
set showbreak=↪ " character show when wrapping line
" Set whitespace characters to use when using list
set listchars=eol:¬,tab:»\ ,trail:·

" Set list by default
set list

" Enable an warning when exceeding a certain line length
" set colorcolumn=80
" let &colorcolumn=join(range(81,999),",")

" Enable line numbers
set number

" Show the line and column numbers
set ruler

" Increase height of Vim command prompt
set cmdheight=1

" Enable status line for all files
set laststatus=2

" Set the status line to show useful information
set statusline=\ %F%m%r%h\ %w\ \ [%{&ff}]%y\ Line:\ %l/%L:%c\ (%p%%)

" Always report number of lines modified
set report=0

" Maintain a certain number of lines between the cursor
" and the end of the window
set scrolloff=7

" ------------------------------ Searching -------------------------------
" ------------------------------------------------------------------------
" Ignore case in searching by default, unless there are capitals
set ignorecase
set smartcase

" Match searches immediately, and highlight subsequent matches
set incsearch
set hlsearch
set linespace=4

" ------------------------------ Mappings --------------------------------
" ------------------------------------------------------------------------
" Map spellcheck toggle
nnoremap <silent> <leader>s :setlocal spell! spelllang=en_us<CR>

" Map list command
nnoremap <silent> <leader>l :set list!<CR>

" Map window switching shortcut
nnoremap <silent> <leader>w <C-W><C-W>

" Map CTRL+L to clear highlight search
noremap <silent> <C-L> :silent nohlsearch<CR>

" Map CTRL+Backspace to delete words in insert mode
inoremap <C-BS> <C-W>

" Map CTRL+S to select all
nnoremap <C-A> ggVG
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

" Map clipboard register paste and copy operations
nnoremap <C-P> "+gp
inoremap <C-P> <C-R>+
vnoremap <C-X> "+d
vnoremap <C-Y> "+y
vnoremap <C-P> "+gP

" Replace the backtick with the apostrophe, for better accessibility
nnoremap ' `
nnoremap ` '

" Same with the colon and semicolon; colon is used very often
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :

" Map Enter and Shift-Enter to insert newlines below and above the cursor
nnoremap <CR> o<ESC>0d$
nnoremap <S-CR> O<ESC>0d$

" Helper functions to avoid BufChange'ing the NERD tree window
function! BufNext()
  if exists("t:NERDTreeBufName")
    if bufnr(t:NERDTreeBufName) != bufnr('')
      bn
    endif
  else
    bn
  endif
endfunction

function! BufPrev()
  if exists("t:NERDTreeBufName")
    if bufnr(t:NERDTreeBufName) != bufnr('')
      bp
    endif
  else
    bp
  endif
endfunction

function! BufWipe()
  if exists("t:NERDTreeBufName")
    if bufnr(t:NERDTreeBufName) != bufnr('')
      BW
    endif
  else
    BW
  endif
endfunction

" Map buffer navigation easier
nnoremap <silent> <M-Right> :call BufNext()<cr>
nnoremap <silent> <M-Left> :call BufPrev()<cr>


" Map easier shortcuts to common plugins
nnoremap <silent> <leader>t :NERDTreeToggle<CR>
nnoremap <silent> <leader>q :call BufWipe()<CR> " Close buffer without closing window
nnoremap <silent> <leader>gu :GundoToggle<CR>
nnoremap <silent> T :BTags!<CR>
nnoremap <silent> <leader>vt :SignifyToggle<CR>
nnoremap <silent> <leader>a :Ag ''<LEFT>

" Map timestamp functions
" nnoremap <F4> a<C-R>=strftime("%m/%d/%y")<CR><ESC>
" inoremap <F4> <C-R>=strftime("%m/%d/%y")<CR>
" nnoremap <F3> a<C-R>=strftime("%Y-%m-%d %a")<CR>
" inoremap <F3> <C-R>=strftime("%Y-%m-%d %a")<CR>


set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux


" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

endif
" bind K to grep word under cursor

nnoremap K :Ag! "\bdef\s<C-R><C-W>\b"<CR>:cw<CR>
nnoremap M :Ag! "\b<C-R><C-W>\b"<CR>:cw<CR>
nmap <Leader>ct <Plug>silent! !ctags -R . &

" }}}


" ------------------------------- Plugins --------------------------------
" ------------------------------------------------------------------------
" NERDCommenter
let NERDSpaceDelims = 1

" NERDTree
let NERDTreeIgnore = ['\.pyc$']

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 0
let  g:airline#extensions#branch#enabled = 1
let  g:airline#extensions#syntastic#enabled = 1
function! AirlineInit()
  let g:airline_section_y = airline#section#create(['ffenc', ' ⮃ %{strftime("%H:%M")}'])
endfunction

let g:airline_right_alt_sep     = '⮃'
autocmd VimEnter * call AirlineInit()


" Syntastic
let g:syntastic_mode_map = { 'mode': 'passive',
      \ 'active_filetypes': [],
      \ 'passive_filetypes': [] }

" UltiSnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"

let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-Tab>'


" Emmet
let g:user_emmet_leader_key = '<C-Z>'

" ------------------------ Environment-Specific --------------------------
" ------------------------------------------------------------------------
if has("win32")
  " Try DOS EOL first
  set fileformats=dos,unix,mac

  " Fix shell options
  set shell=cmd.exe
  set shellcmdflag=/C

  " Specify swap directory
  set directory=~/vimfiles/tmp//,$TMP

  " Specify backup directory
  set backupdir=~/vimfiles/backup//,$TMP

  " Specify undo directory
  set undodir=~/vimfiles/undo

  " Specify spelling file
  set spellfile=~/vimfiles/spell/spell.utf-8.add

  " Switch to tabs
  set noexpandtab

  " No powerline fonts
  " let g:airline_powerline_fonts = 1
endif

" ------------------------------ Includes --------------------------------
" ------------------------------------------------------------------------

if has("win32")
  " Add extra filetypes
  source ~/vimfiles/filetypes.vim
  " Extra helper functions
  source ~/vimfiles/functions.vim
else
  " Add extra filetypes
  source ~/.vim/filetypes.vim
  " Extra helper functions
  source ~/.vim/functions.vim
endif
map <silent> <C-F11>
      \    :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

"------------------------------- Customs --------------------------------
"-------------------------- Bindings for VCSCommand  --------------------

nmap <Leader>va <Plug>VCSAdd
nmap <Leader>va <Plug>VCSAdd
nmap <Leader>vc <Plug>VCSCommit
nmap <Leader>vd <Plug>VCSDiff
nmap <Leader>vs <Plug>VCSStatus
nmap <Leader>vu <Plug>VCSUpdate
let g:signify_mapping_next_hunk = '<leader>gj' 
let g:signify_mapping_prev_hunk = '<leader>gk' 

" Use relative numbering in insert mode
set number
set relativenumber
:hi CursorLineNr guifg=#566978
" autocmd InsertLeave * set number
"
" Settings for Go-Lang
"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
" let g:indentLine_char = '│'
command! Wd write|bdelete
" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
nnoremap o <NOP> 
let NERDTreeQuitOnOpen = 1


" fzf settings
" Advanced customization using autoload functions
autocmd VimEnter * command! Colors
      \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Open files in horizontal split
nnoremap <silent> <c-p> :call fzf#run({
      \   'down': '40%',
      \   'sink': 'e' })<CR>


" List of buffers
function! BufList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! BufOpen(e)
  execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <NUL> :call fzf#run({
      \   'source':  reverse(BufList()),
      \   'sink':    function('BufOpen'),
      \   'options': '+m',
      \   'down':    '40%'
      \ })<CR>

nnoremap <silent> <C-b> :call fzf#run({
      \   'source':  reverse(BufList()),
      \   'sink':    function('BufOpen'),
      \   'options': '+m',
      \   'down':    '40%'
      \ })<CR>

nnoremap <silent> <C-space> :call fzf#run({
      \   'source':  reverse(BufList()),
      \   'sink':    function('BufOpen'),
      \   'options': '+m',
      \   'down':    '40%'
      \ })<CR>

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" Replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

function! s:make_sentence(lines)
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

inoremap <expr> <c-x><c-s> fzf#complete({
      \ 'source':  'cat /usr/share/dict/words',
      \ 'reducer': function('<sid>make_sentence'),
      \ 'options': '--multi --reverse --margin 15%,0',
      \ 'left':    20})

" This is the default extra key bindings
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

nnoremap <C-t> :call RunCurrentSpecFile()<CR>

let g:rspec_command = "compiler rspec | set makeprg=zeus | Make rspec {spec}"

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <C-Down> <C-W><C-J>
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-S-Right> <C-W><C-L>
nnoremap <C-S-Left> <C-W><C-H>

set splitbelow
set splitright


nnoremap <silent> <Leader>C :call fzf#run({
      \   'source':
      \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
      \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
      \   'sink':    'colo',
      \   'options': '+m',
      \   'left':    30
      \ })<CR>

nnoremap <C-S-Down> :m .+1<CR>==
nnoremap <C-S-Up> :m .-2<CR>==
inoremap <C-S-Down> <Esc>:m .+1<CR>==gi
inoremap <C-S-Up> <Esc>:m .-2<CR>==gi
vnoremap <C-S-Down> :m '>+1<CR>gv=gv
vnoremap <C-S-Up> :m '<-2<CR>gv=gv
nnoremap <F7> :Dispatch<CR>


let g:fzf_layout = { 'window': 'enew' }
" let g:deoplete#enable_at_startup = 1

" ----------------------------------------------------------------------------
" Buffers
" ----------------------------------------------------------------------------
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" ----------------------------------------------------------------------------
" Tabs
" ----------------------------------------------------------------------------
nnoremap ]t :tabn<cr>
nnoremap [t :tabp<cr>

" ----------------------------------------------------------------------------
" <tab> / <s-tab> | Circular windows navigation
" ----------------------------------------------------------------------------
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W



"----------------------------------------------------
" Jump to tags in the current buffer
"----------------------------------------------------


function! s:align_lists(lists)
  let maxes = {}
  for list in a:lists
    let i = 0
    while i < len(list)
      let maxes[i] = max([get(maxes, i, 0), len(list[i])])
      let i += 1
    endwhile
  endfor
  for list in a:lists
    call map(list, "printf('%-'.maxes[v:key].'s', v:val)")
  endfor
  return a:lists
endfunction

function! s:btags_source()
  let lines = map(split(system(printf(
    \ 'ctags -f - --sort=no --excmd=number --language-force=%s %s',
    \ &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error
    throw 'failed to extract tags'
  endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  execute split(a:line, "\t")[2]
endfunction

function! s:btags()
  try
    " call fzf#run({
    " \ 'source':  s:btags_source(),
    " \ 'options': '+m',
    " \ 'sink':    function('s:btags_sink'),
    " \ 'left':    30
    " })

    call fzf#run({
      \   'source' : s:btags_source(),
      \   'sink'   : 'colo',
      \   'options': '+m',
      \   'left'   : 30
      \ })<CR>


  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! BTags call s:btags()

nnoremap <leader>B :BTags<CR>
let g:vimrubocop_keymap = 0
nmap <Leader>r :RuboCop<CR>
if has("gui_running")
  let g:fzf_launcher='gnome-terminal --disable-factory -x bash -ic %s'
  set vb t_vb=
else
  set noeb vb t_vb=
endif


function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
        \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
        \            '| grep -v ^!',
        \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
        \ 'down':    '40%',
        \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()

fu! FzfTagsCurrWord()
  let currWord = expand('<cword>')
  if len(currWord) > 0
    call fzf#vim#tags({'options': '-q ' . currWord})
  else
    execute ':Tags'
  endif
endfu
nnoremap <leader>T :Tags <c-r><c-w><cr> 


function! NumberToggle()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <Leader>E :call NumberToggle()<cr>

