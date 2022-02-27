" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocp
filetype plugin on 

let $PATH = 'c:\Users\N129586\Aplicaciones\Git\bin;C:\Users\n129586\Aplicaciones\commands;C:\Users\n129586\Aplicaciones\mingw64\bin;' . $PATH
let $LANG = 'es_ES'

" PLUGINS
call plug#begin('~/AppData/Local/nvim/plugged')
" below are some vim plugins for demonstration purpose.
" add the plugin you want to use here.
Plug 'preservim/nerdcommenter'
Plug 'bling/vim-airline'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'tpope/vim-fugitive'

Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'tami5/sqlite.lua'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-ui-select.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'mfussenegger/nvim-jdtls'

call plug#end()

" I'm come from windows
source $VIMRUNTIME/mswin.vim

" My personal keys
let mapleader =","
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
noremap <F5> <Esc>:e<CR>
inoremap <F5> <C-o>:e<CR>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Console
set guifont="DroidSansMono NF":h9
set encoding=utf-8
set termguicolors 

" Diff options
set diffopt+=iwhite

" Issues keys with AltGr (spanish-keyboard)
imap <M-Esc> [
imap <M-C-]> ]
imap <M-C-\> \
imap <M-C-@> @
imap <M-C-#> #
map! <M-Esc> [
map! <M-C-]> ]
map! <M-C-\> \
map! <M-C-@> @
map! <M-C-#> #

" SQLLite, necessary for Telescope frecency
let g:sqlite_clib_path = "C:\\Users\\n129586\\AppData\\Local\\nvim-data\\sqlite\\sqlite3.dll"

" Find files using Telescope command-line sugar.
lua << EOF
require("telescope").load_extension("frecency")
require("telescope").load_extension("ui-select")
EOF
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope frecency<cr>

" XML
" gg=G
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

" LUA
autocmd FileType lua setlocal shiftwidth=4 softtabstop=4 expandtab

" JSON
" :%!jq

" nvim-jdtl
augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require'jdtls_setup'.setup()
augroup end

" Permitir pegar en telescope
" Añadir dap
" Añadir otros jar
" Revisar warning dynamicRegistration
" Arreglar curl (añadir certificados)
" Problema con warning next
" Revisar lombok


