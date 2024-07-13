"
" .vimrc
"
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" Tabs and Spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set backspace=indent,eol,start
set expandtab
set autoindent
set smarttab

set encoding=utf-8        " Formatage UTF-8
set incsearch             " Incremental search
set hlsearch              " Highlighte the last search pattern

" Misc
set number
set ruler
set showmatch
set wildmenu
set wildmode=list,full
set nowrap
set hidden
set modeline
set hlsearch
set incsearch
set autoread                        " Auto-reload modified files (with no local changes)
set ignorecase                      " Ignore case in search
set smartcase                       " Override ignorecase if uppercase is used in search string
set report=0                        " Report all changes
set laststatus=2                    " Always show status-line
set nocursorline                    " Highlight current line
set scrolloff=4
set nofoldenable
set timeoutlen=500                  " Set timeout between key sequences
set background=dark
set mouse=vin                       " Enable mouse in insert and normal mode
set directory=~/tmp,/var/tmp,/tmp,. " Keep swap files in one of these
set wmh=0                           " Minimum window height = 0
set showcmd
set updatetime=250                  " How long before 'CursorHold' event
set nobackup
set nowritebackup
set noswapfile
set nostartofline
set noshowmode                      " Don't show stuff like `-- INSERT --`
set foldlevel=99                    " Open all folds by default
set cmdheight=1
set matchtime=2                     " Shorter brace match time
set virtualedit=block
set tags+=.tags
set undofile
set gdefault                        " Always use /g with %s/
set colorcolumn=80
set list
set listchars=tab:·\ ,eol:¬,trail:█
set fillchars=diff:\ ,vert:│
set diffopt=filler,vertical,foldcolumn:0
set lazyredraw                      " Stop vim from freaking out all the time
set statusline=%<%f\ %h%m%r%=%{Hi()}\ %y\ \ %-14(%{&sw}:%{&sts}:%{&ts}%)%-14.(%l,%c%V%)\ %P
set mouse=v
"to show all characters
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<


"make colors of comment less ugly
color desert
" We don't use tabs much, but at least try and show less cruft
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)

    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . (!empty(bufname) ? fnamemodify(bufname, ':t') : '[No Name]') . ' '
  endfor
  return s
endfunction
set tabline=%!Tabline()

if !has("nvim")
  set nocompatible                  " Don't try to be compatible with vi
  set ttyfast
  set t_Co=256
endif

let mapleader = "\<Space>"

let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Deoplete (autocomplete)
if has("nvim")
  let g:deoplete#enable_at_startup = 0
  let g:deoplete#disable_auto_complete = 1
  inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ deoplete#mappings#manual_complete()
  function! s:check_back_space()
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
endif

" Save on focus lost
au FocusLost * call s:SaveOnFocusLost()
function! s:SaveOnFocusLost()
  if !empty(expand('%:p')) && &modified
    write
  endif
endfunction

" Per file-type indentation
au FileType haskell     setlocal sts=4 sw=4 expandtab
au FileType javascript  setlocal sts=4 sw=4 expandtab
au FileType css         setlocal ts=4  sw=4 noexpandtab
au FileType go          setlocal ts=4  sw=4 noexpandtab
au FileType c,cpp       setlocal       sw=4 noexpandtab
au FileType lua         setlocal       sw=2 expandtab
au FileType sh,zsh      setlocal ts=2  sw=2 noexpandtab
au FileType vim,ruby    setlocal sts=2 sw=2 expandtab
au FileType help        setlocal ts=4  sw=4 noexpandtab
au FileType txt         setlocal noai nocin nosi inde=

" Remove trailing whitespace on save
autocmd BufWritePre * call s:StripTrailing()
function! s:StripTrailing()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfunction

" Haskell
let g:haskellmode_completion_ghc = 0
let g:haskell_enable_quantification = 1
au FileType haskell setlocal omnifunc=necoghc#omnifunc
au FileType haskell setlocal makeprg=stack\ build
au FileType haskell setlocal errorformat=
                \%-G,
                \%-Z\ %#,
                \%W%f:%l:%c:\ Warning:\ %m,
                \%E%f:%l:%c:\ %m,
                \%E%>%f:%l:%c:,
                \%+C\ \ %#%m,
                \%W%>%f:%l:%c:,
                \%+C\ \ %#%tarning:\ %m,

if executable('haskell-tags')
  au BufWritePost *.hs  silent !haskell-tags % '.tags'
  au BufWritePost *.hsc silent !haskell-tags % '.tags'
endif

" File-type
filetype on
filetype plugin on
filetype indent on

nnoremap <Space> <NOP>
nnoremap Q       <NOP>

" Make `Y` behave like `D` and `C`
nnoremap Y       y$

" Copy selected text to clipboard
xnoremap Y       "+y

" Easy command mode switch
inoremap kj <Esc>
inoremap <C-l> <C-x><C-l>

" Jump to high/low and scroll
noremap <C-k> H{
noremap <C-j> L}

" Move easily between ^ and $
noremap <C-h> ^
noremap <C-l> $
noremap j gj
noremap k gk

" Like '*' but stays on the original word
nnoremap <Leader>/       *N
nnoremap <C-n>           *N
nnoremap <C-p>           #N
nnoremap c*              *Ncgn
nnoremap <Leader>h       :nohl<CR>

nnoremap <Leader>n      :cnext<CR>
nnoremap <Leader>p      :cprev<CR>

" Git
cnoreabbrev gw    Gwrite
cnoreabbrev gwa   Git add -u
cnoreabbrev gc    Gcommit -v
cnoreabbrev gca   gwa <Bar> gc

autocmd BufRead fugitive\:* xnoremap <buffer> dp :diffput<CR>
autocmd BufRead fugitive\:* xnoremap <buffer> do :diffget<CR>

 " Select recently pasted text
nnoremap <leader>p       V`]

" Switch buffers easily
nnoremap <Tab>   <C-^>

" Actually easier to type and I do it by mistake anyway
cnoreabbrev W w
cnoreabbrev Q q

" Ack
cnoreabbrev ack Ack!

" File navigation/search
nnoremap <Leader>o      :FuzzyOpen<CR>

" Navigate relative to the current file
cmap     %/         %:p:h/

map <Leader>m       :make<CR>
map <Leader>e       :e ~/.vimrc<CR>
map <Leader>s       :source ~/.vimrc<CR>

" Repeat previous command
map <Leader><Space> @:

" Commenting
nmap <C-_>           <Plug>CommentaryLine
xmap <C-_>           <Plug>Commentary

if has("nvim")
  tnoremap <Esc> <C-\><C-n>
endif

if executable('rg')
  let g:ackprg = 'rg -S --no-heading --vimgrep'
endif

" Syntax coloring
syntax enable

try
  colorscheme shady
catch
endtry

" Profiling
command! ProfileStart call s:ProfileStart()
function! s:ProfileStart()
  profile start profile
  profile func *
  profile file *
endfunction

command! ProfileStop call s:ProfileStop()
function! s:ProfileStop()
  profile stop
  tabnew profile
endfunction

" Get highlight group under cursor
command! Hi call s:ToggleHi()
function! s:ToggleHi()
  if exists('g:show_hi')
    unlet g:show_hi
  else
    let g:show_hi = 1
  endif
endfunction
function! Hi()
  if exists('g:show_hi')
    return synIDattr(synID(line("."), col("."), 1), "name")
  endif
  return ''
endfunction

set nocompatible              " be iMproved, required

" Spelling.
function! ToggleSpell()
  if !exists("b:spell")
    setlocal spell spelllang=en_us
    let b:spell = 1
  else
    setlocal nospell
    unlet b:spell
  endif
endfunction

noremap zz <c-w>_ \| <c-w>\|
noremap zo <c-w>=
