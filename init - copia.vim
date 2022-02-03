" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let $PATH .= ';c:\Users\N129586\Aplicaciones\Git\bin;C:\Users\n129586\Aplicaciones\commands'
let $LD_LIBRARY_PATH ='C:\Users\n129586\Aplicaciones\cygwin\bin'

if !has("gui_running")
"  set term=xterm
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
  set guifont=Consolas:h9
  set encoding=utf-8
  behave xterm
  " behave mswin
  set <up>=[A 
  set <down>=[B
  set <left>=[D
  set <right>=[C
endif

" Abrir por defecto el nuevo fichero a la derecha
set splitright
set splitbelow

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=160

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

source $VIMRUNTIME/mswin.vim

set wildmenu
set nowrap
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
noremap <F5> <Esc>:e<CR>
inoremap <F5> <C-o>:e<CR>
"nmap <F8> :TagbarToggle<CR>
set tabstop    =4
set shiftwidth =4
set expandtab
set fileformats=unix,dos
set nu
set history    =1000            " keep 50 lines of command line history
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set incsearch                  " do incremental searching
set undofile
set foldmethod =syntax
set foldlevel=20
set laststatus =2
let mapleader =","
set diffopt+=iwhite
set hidden

set belloff=all

" Directorios backup, swp ,undo
"set undodir=~/.vim/.undo/
"set backupdir=~/.vim/.backup/
"set directory=~/.vim/.swp/

filetype plugin on

" Configurar python
let g:python3_host_prog='c:/Program Files/Python/python.exe'


" PLUGINS
call plug#begin('~/AppData/Local/nvim/plugged')
" below are some vim plugins for demonstration purpose.
" add the plugin you want to use here.
"Plug 'dracula/vim'
"Plug 'mhinz/vim-startify'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'tpope/vim-jdaddy'
"Plug 'bling/vim-airline'
"Plug 'junegunn/fzf'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'lgranie/vim-lsp-java'


"Plug 'scrooloose/nerdtree'
"Plug 'preservim/nerdcommenter'
"Plug 'nvim-treesitter/nvim-treesitter'
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'ryanoasis/vim-devicons'
call plug#end()

" color schemes
if (has("termguicolors"))
    set termguicolors
endif
syntax enable
 " colorscheme evening
" colorscheme dracula


"
" Plugin controlp
"
let g:ctrlp_cmd = 'CtrlPBuffer'
hi! link CtrlPBufferHid Normal

" nvim-treesitter
"
"require'nvim-treesitter.configs'.setup {
  "ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  "highlight = {
    "enable = true,              -- false will disable the whole extension
  "},
"}

let g:vim_lsp_java = {
  \ 'eclipse_jdtls' : {
    \ 'repository': expand('~/opt/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository'),
    \ 'config': 'config_linux',
    \ 'workspace': expand('$WORKSPACE'),
  \ },
\ }


" FUNCIONES
"
" Funcion formatear XML
"
function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!C:/Users/n129586/Aplicaciones/Git/mingw64/bin/xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction

command! FormatXML call DoPrettyXML()
"
" Función Formatear JSON
" 
"command! FormatJSON %!c:/ApliGBPE/cygwin/bin/python2.7 -m json.tool

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

