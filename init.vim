" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocp
filetype plugin on 

let $PATH .= ';c:\Users\N129586\Aplicaciones\Git\bin;C:\Users\n129586\Aplicaciones\commands'
let $LD_LIBRARY_PATH ='C:\Users\n129586\Aplicaciones\cygwin\bin'
let $LANG = 'es_ES'

" PLUGINS
call plug#begin('~/AppData/Local/nvim/plugged')
" below are some vim plugins for demonstration purpose.
" add the plugin you want to use here.
Plug 'preservim/nerdcommenter'
Plug 'bling/vim-airline'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'mfussenegger/nvim-jdtls'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tami5/sqlite.lua'
Plug 'nvim-telescope/telescope-frecency.nvim'

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

" SQLLite, necessary for Telescope frecency
let g:sqlite_clib_path = "C:\\Users\\n129586\\AppData\\Local\\nvim-data\\sqlite\\sqlite3.dll"

" Find files using Telescope command-line sugar.
lua << EOF
require"telescope".load_extension("frecency")
EOF
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope frecency<cr>

" XML
" gg=G
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

" JSON
" :%!jq

" nvim-jdtl
"function LoadJDT()
lua << EOF
-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    'c:/Users/n129586/Aplicaciones/jdk-11.0.11/bin/java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', 'C:/Users/n129586/AppData/Local/nvim-data/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/products/languageServer.product/win32/win32/x86_64/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    --'/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
         -- Must point to the                                                     Change this to
         -- eclipse.jdt.ls installation                                           the actual version

    '-configuration', 'C:/Users/n129586/AppData/Local/nvim-data/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/products/languageServer.product/win32/win32/x86_64/config_win',
    --'/path/to/jdtls_install_location/config_SYSTEM',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.


    -- See `data directory configuration` section in the README
    '-data', 'C:/TEMP/.workspace'
    --'/path/to/unique/per/project/workspace/folder' 
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {}
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
EOF
"endfunction

augroup jdtls_lsp
    autocmd!
    autocmd FileType java lua require'jdtls_setup'.setup()
augroup end

"nnoremap <A-o> <Cmd>lua require'jdtls'.organize_imports()<CR>
"nnoremap crv <Cmd>lua require('jdtls').extract_variable()<CR>
"vnoremap crv <Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>
"nnoremap crc <Cmd>lua require('jdtls').extract_constant()<CR>
"vnoremap crc <Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>
"vnoremap crm <Esc><Cmd>lua require('jdtls').extract_method(true)<CR>

"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
"command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
"command! -buffer JdtJol lua require('jdtls').jol()
"command! -buffer JdtBytecode lua require('jdtls').javap()
"command! -buffer JdtJshell lua require('jdtls').jshell()

