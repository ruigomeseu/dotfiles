set nocompatible            " Disable compatibility to old-time vi
set showmatch               " Show matching brackets.
set ignorecase              " Do case insensitive matching
set mouse=v                 " middle-click paste with mouse
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set relativenumber
set clipboard=unnamedplus
"set termguicolors

filetype off                " required

set rtp+=/usr/bin/fzf

let g:vue_disable_pre_processors=1

call plug#begin('~/.config/nvim/plugged')

Plug 'mhartington/oceanic-next'
Plug 'scrooloose/nerdtree'
Plug 'othree/html5.vim'
Plug 'othree/yajs.vim'
Plug 'posva/vim-vue'
Plug '/usr/bin/fzf'
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'itchyny/lightline.vim'

call plug#end()

"let g:gruvbox_contrast_dark = 'hard'
"colorscheme gruvbox

syntax enable
colorscheme OceanicNext

silent! nmap <C-p> :FZF<CR>
silent! map <F2> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
