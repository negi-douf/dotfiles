"Reference
"https://github.com/Shougo/dein.vim
"https://www.lisz-works.com/entry/vim-deinvim

let s:dein_dir = expand('$HOME/.vim/plugins')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

"Install dein if not installed
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

"Manage plugins by dein
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    "Put plugins here!
    call dein#add('scrooloose/nerdtree')
    call dein#add('nathanaelkane/vim-indent-guides')
    call dein#add('scrooloose/syntastic')
    call dein#add('hashivim/vim-terraform')
    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

"NERDTree
nnoremap <silent><C-n> :NERDTreeToggle<CR>

"Syntastic
let g:syntastic_python_checkers = ["flake8"]

"Recommend setting: https://github.com/vim-syntastic/syntastic#3-recommended-settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"Python autopep8 (Format python code at save)
function! RunAutopep8()
    call execute(":silent %!autopep8 -")
endfunction

if executable('autopep8')
    "Format manualy on normal mode
    autocmd FileType python nnoremap <C-p> :call RunAutopep8() <CR>
endif

"Auto reload .vimrc
augroup source-vimrc
    autocmd!
    autocmd BufWritePost *vimrc source $MYVIMRC | set foldmethod=marker
    autocmd BufWritePost *gvimrc if has('gui_running') source $MYGVIMRC
augroup END

set fenc=utf-8

set noswapfile
set nobackup

if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

set laststatus=2

set wildmode=list:longest

set belloff=all
set virtualedit=onemore
set nu

set expandtab
set tabstop=4
set autoindent

set ignorecase
set smartcase
set incsearch
set hlsearch

set rtp+=/opt/homebrew/opt/fzf

nnoremap j gj
nnoremap k gk

syntax enable

nmap <Esc><Esc> :nohlsearch<CR><Esc>

autocmd! bufwritepost $MYVIMRC source %
