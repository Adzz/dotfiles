"My Vimrc
"----------
"Leader is the space bar
let mapleader = "\<Space>"

" NB remember to run plug install if cloning dotfiles from a new machine

" BASIC MAPPINGS
"----------

" This is how mappings work

" -----------------------------------------
"     MODE     | RECURSIVE | NON_RECURSIVE |
" -------------|-----------|---------------|
"      All     |    map    |    noremap    |
" -----------------------------------------|
"     Normal   |    nmap   |   nnoremp     |
" -----------------------------------------|
"     Visual   |           |               |
"       &      |    vmap   | vnoremap      |
"     Select   |           |               |
" -----------------------------------------|
"     Visual   |    xmap   |  xnoremap     |
"      only    |           |               |
" -----------------------------------------|
"     Select   |    smap   |   snoremap    |
"      only    |           |               |
" -----------------------------------------|
"     Insert   |    imap   |   inoremap    |
" -----------------------------------------|
" Command-line |    cmap   |    cnoremap   |
" -----------------------------------------|

" Vim-Plug Plugin Manager
" --------

call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-mix-format'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'mileszs/ack.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'elixir-lang/vim-elixir'
Plug 'othree/html5.vim'
Plug 'mhartington/oceanic-next'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-dispatch'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'jiangmiao/auto-pairs'

" conditional loading of plugins
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'slashmili/alchemist.vim', { 'for': 'elixir' }

call plug#end()

"Open nerd tree:
nmap <leader>d :NERDTreeToggle<CR>
"Reveals current file in NerdTree
nmap <leader>f :NERDTreeFind<CR>
"Sets 0 as line begining:
nmap 0 ^
"Open vimrc in new buffer split:
nmap <leader>vr :tabedit $MYVIMRC<CR>
"Source vimrc:
nmap <leader>so :source $MYVIMRC<CR>
"Save :
nmap <leader>w :w<CR>
"Quit without saving:
nmap <leader>qn :q!<CR>
"Quit :
nmap <leader>q :q<CR>
"Move up and down a visual line when text is wrapped, rather than by line number
nmap k gk
nmap j gj
"Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
"remaps enter to save and repeat last command ran. Such TDD, many rspec.
nnoremap <CR> :wa<CR>:!!<CR>
" auto resize windows
autocmd VimResized * :wincmd =
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>
nnoremap <leader>pi :PlugInstall<cr>
" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
"insert pry for elixir
nmap <leader>b orequire IEx;IEx.pry()<ESC>
"pipe the thing into inspect
nmap <leader>i i\|>IO.inspect()<ESC>
"cycle through open buffers buffer
nmap <tab> :w<CR>:bnext<CR>
" we need shift tab to do reverse
nmap <s-tab> :w<CR>:bp<CR>

" bind leader k to grep word under cursor in the current project folder
"nnoremap <leader>k :grep! \"\b<C-R><C-W>\b"<CR>
nnoremap \ :Ack<SPACE>
" load the command for running a test in an iex shell ready to go. We dont
" <cr> so that we can add a line number to the end of the %:p , or add --only
" and a tag
nmap <leader>ss :!iex -S mix test %:p --trace
" re-indent entire file, returning cursor to position you started at
nmap <leader>== mzgg=G`z
"run mix formatter on the current file
nmap <leader>mf :!mix format %:p<cr><cr>

" Plugin Settings
" ----------------
"
" Grepping
" --------

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  let g:ackprg = 'ag --vimgrep --nogroup'
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif


"CtrlP
"-----
let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("e")': ['<cr>', '<2-LeftMouse>'],
      \ 'AcceptSelection("v")': ['<c-v>', '<RightMouse>'],
      \ }
nnoremap <leader>o :CtrlP<CR>

"vim-test
" -----------------

" Use absolute file-path - this is needed for umbrella apps
" otherwise you'll get 'Test patterns did not match any file'
" if you are in the root of the umbrella app.
let test#filename_modifier = ":p"

" MAPPINGS
"nearest to cursor
nmap <silent> <leader>s :TestNearest<CR>
"run current test file
nmap <silent> <leader>S :TestFile<CR>
"'test it all
nmap <silent> <leader>a :TestSuite<CR>
"visits the test file when you run it:
nmap <silent> <leader>g :TestVisit<CR>

" NerdTree :
"-----------

let NERDTreeShowLineNumbers=1       "Shows line numbers
let NERDTreeAutoCenter=1            "Auto Centers cursor in nerdtree
let NERDTreeAutoCenterThreshold=15  "Default 3.
let NERDTreeShowHidden=1            "Shows hidden files
let NERDTreeAutoDeleteBuffer=1      "Auto remove buffer when file deleted
let NERDTreeIgnore=['^\.DS_Store$'] "Dont show listed files
let NERDTreeWinSize=25              "Default 31

" Selecta
" --------

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories starting in the working directory.
" Fuzzy select one of those. Open the selected file with :e.
"nnoremap <leader>k :call SelectaCommand("find * -type f", "", ":e")<cr>

" Mix Formatter: https://github.com/mhinz/vim-mix-format
" run formatter on save
"let g:mix_format_on_save = 1


"BASIC USE SETTINGS
"------------------
" Persistent undo - this is so undo history is not lost when you switch
" buffers. Usually you can set hidden so the buffer hides when you switch but
" this is probably better
set undofile
set undodir=$HOME/.vim/undo
set undolevels=1000
set undoreload=10000

set incsearch                  " highights search as you type!
set timeoutlen=420             "Timeout length between commands
set mouse =a                   "Enables mouse use in all modes. Wont copy line numbers when copying from vim
set ignorecase                 "Makes searches case insensitive by default. Put \C anywhere in the search to make it case sensitve.
set smartcase                  "Smart case sensitivity. The 'smartcase' option only applies to search patterns that you type; it does not apply to * or # or gd. Will make a case sensitive search if you use an upper case letter, otherwise it will not be.
set backspace=2                "Same as :set backspace=indent,eol,start. Make backspace work like most other apps. Hitting backspace usually deletes what has been inserted in the current insert mode and on the current line. Using the default backspace option also leaves the old characters on the screen and they won't disappear until you exit back to normal mode.
set autoindent                 "Copy indent from current line when starting a new line.
set foldcolumn=2               " the number of columns to use for folding display at the left
set updatetime=250             "If this many milliseconds nothing is typed the swap file will be written to disk. Default is 4 seconds, we speed it up for git gutter so it picks up on changes we make quicker.  Setting it too low probably causes glitches.

"DISPLAY SETINGS
"---------------
if !exists("g:syntax_on")
  syntax enable
endif                          "Allow syntax highlighting, see here https://stackoverflow.com/questions/33380451/is-there-a-difference-between-syntax-on-and-syntax-enable-in-vimscript
set t_Co=256                   " sets colour did this because here: https://github.com/mhartington/oceanic-next the oceanic next theme said so
filetype plugin indent on      "Detect filetype, set the approppriate indent for the filetype, and allow filetype specific plugins
colorscheme OceanicNext        " Sets the colour scheme
set number                     "Show line numbers when combined with above shows rel line numbers and the absolute number of the line you are on.
set cursorline                 "Highlight the line the cursor is on
set splitbelow                 "Open new split panes to bottom
set splitright                 "and right which feels more natural
set noswapfile                 "Stops generating swp files
set scrolloff=4                "4 lines above/below cursor when scrolling
set colorcolumn=81             "Colours the 81st column in to look like two pages. Not sure why
set wrap                       "Should wrap lines visually
set expandtab                  "Convert <tab> to spaces (2 or 4)
set showmatch                  "Show matching bracket (briefly jump)
set matchtime=2                "Show matching bracket for 0.2 seconds
set lazyredraw                 " redraw only when we need to.
set matchpairs+=<:>            "Specially for html
set noshowmode                 "hides current mode from the status bar
set wildmenu                   "Allows autocomplete on vim commands.
set wildmode=longest,list,full "First tab completes longest common string, then second tab will complete to first full match and open the wildmenu.
set laststatus=2               "The value of this option influences when the last window will have a status line. 0  = never, 1 = only if there are t least 2 windows, 2 = always.
let &t_SI = "\<Esc>]50;CursorShape=1\x7"   "Changes cursor shape in different modes. Works for iterm2 on OSX
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" Enable spellchecking for Markdown
autocmd FileType markdown setlocal spell

" Always strip whitespace for it be evil
autocmd BufWritePre * :%s/\s\+$//e

"TAB SETTINGS
"------------
set expandtab                  "Removes hard tabs for, makes them spaces instead
set tabstop=2                  "Two space tab as default
set shiftwidth=2               "Control how many columns text is indented with the reindent operations >>
set softtabstop=2              "How many columns vim uses when you hit Tab in insert mode

"COPYING AND PASTING
"----------------

set pastetoggle=<C-p>          "Sets ctrl + p to enter paste mode, allows unmodified pasting from other applications
set clipboard=unnamed          "Use system clipboard
"Below, non recursively maps ctrl + p to changing paste mode.
nnoremap <C-p> :set invpaste paste?<CR>
