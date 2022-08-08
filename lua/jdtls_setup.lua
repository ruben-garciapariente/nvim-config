local M = {}

local lsp = require 'vim.lsp'
local jdtls = require 'jdtls'
local api = vim.api

-- id is filetype│root_dir
local lsps = {}

-- array of mappings to setup; {<capability_name>, <mode>, <lhs>, <rhs>}
local key_mappings = {
    {"code_action", "n", "<a-CR>", "<Cmd>lua require'jdtls'.code_action()<CR>"},
    {"code_action", "n", "<leader>r", "<Cmd>lua require'jdtls'.code_action(false, 'refactor')<CR>"},
    {"code_action", "v", "<a-CR>", "<Esc><Cmd>lua require'jdtls'.code_action(true)<CR>"},
    {"code_action", "v", "<leader>r", "<Esc><Cmd>lua require'jdtls'.code_action(true, 'refactor')<CR>"},

    {"document_formatting", "n", "gq", "<Cmd>lua vim.lsp.buf.formatting()<CR>"},
    {"document_range_formatting", "v", "gq", "<Esc><Cmd>lua vim.lsp.buf.range_formatting()<CR>"},
    {"find_references", "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>"},
    {"hover", "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>"},
    {"implementation", "n", "gD",  "<Cmd>lua vim.lsp.buf.implementation()<CR>"},
    {"signature_help", "i", "<c-space>",  "<Cmd>lua vim.lsp.buf.signature_help()<CR>"},
    {"workspace_symbol", "n", "gW", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>"}
}

local function on_attach(client, bufnr)
    api.nvim_buf_set_var(bufnr, "lsp_client_id", client.id)
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    api.nvim_buf_set_option(bufnr, "bufhidden", "hide")
    api.nvim_command("setlocal signcolumn=yes")

    if client.resolved_capabilities.goto_definition then
      api.nvim_buf_set_option(bufnr, 'tagfunc', "v:lua.lsp_ext.tagfunc")
    end
    local opts = { silent = true; }
    for _, mappings in pairs(key_mappings) do
        local capability, mode, lhs, rhs = unpack(mappings)
        if client.resolved_capabilities[capability] then
            api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
        end
    end
    api.nvim_buf_set_keymap(bufnr, "n", "<space>", "<Cmd>lua vim.diagnostic.show()<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "n", "crr", "<Cmd>lua vim.lsp.buf.rename(vim.fn.input('New Name: '))<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "n", "]w", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "n", "[w", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    if client.resolved_capabilities['document_highlight'] then
      api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
      api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
      api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    end
end

local function jdtls_on_attach(client, bufnr)
    on_attach(client, bufnr)
    local opts = { silent = true; }
    jdtls.setup.add_commands()    
    api.nvim_buf_set_keymap(bufnr, "n", "<A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "v", "crv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "n", "crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "v", "crc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "n", "crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
    api.nvim_buf_set_keymap(bufnr, "v", "crm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
    --api.nvim_buf_set_keymap(bufnr, "n", "<leader>df", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
    --api.nvim_buf_set_keymap(bufnr, "n", "<leader>dn", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
   
    
end

function M.test()
    jdtls.setup.add_commands()
end

function M.setup()
    local root_markers = {'pom.xml', '.git'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    local temp = os.getenv('TEMP')
    local workspace_folder = temp .. "/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace.configuration = true
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    
    local config = {
        flags = {
            allow_incremental_sync = true,
        };
        capabilities = capabilities,
    }

    config.flags.server_side_fuzzy_completion = true


    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    config.cmd = {
      'c:/Users/n129586/Aplicaciones/jdk-11.0.11/bin/java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-javaagent:C:/m2/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar',
      --'-Xbootclasspath/a:C:/Users/n129586/.m2/repository/org/projectlombok/lombok/1.18.22/lombok-1.18.22.jar',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-noverify',
      '-Dlog.level=ALL',
      '--add-modules=ALL-SYSTEM',
      '--add-opens', 'java.base/java.util=ALL-UNNAMED',
      '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
      '-jar', 'C:/Users/n129586/AppData/Local/nvim-data/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/products/languageServer.product/win32/win32/x86_64/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
      '-configuration', 'C:/Users/n129586/AppData/Local/nvim-data/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/products/languageServer.product/win32/win32/x86_64/config_win',
  
      -- See `data directory configuration` section in the README
      '-data', workspace_folder
    }

    config.on_attach = jdtls_on_attach
    config.root_dir = root_dir

    config.on_init = function(client, _)
        client.notify('workspace/didChangeConfiguration', { settings = config.settings })
    end

    config.settings = {
        java = {
            signatureHelp = { enabled = true };
            contentProvider = { preferred = 'fernflower' };
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*"
                }
            };
            sources = {
                organizeImports = {
                    starThreshold = 9999;
                    staticStarThreshold = 9999;
                };
            };
            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                }
            };
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "C:/Program Files (x86)/Java/jre1.8.0_91/",
                    },
                    {
                        name = "JavaSE-11",
                        path = "c:/Users/n129586/Aplicaciones/jdk-11.0.11/",
                    },
                },
                maven = {
                    userSettings = "c:/Users/n129586/.m2/settings.xml",
                },
            };
        };
    }

    -- Add other bundles
    --local jar_patterns = {
        --'/dev/microsoft/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar',
        --'/dev/dgileadi/vscode-java-decompiler/server/*.jar',
        --'/dev/microsoft/vscode-java-test/server/*.jar',
    --}
    --local bundles = {}
    --for _, jar_pattern in ipairs(jar_patterns) do
        --for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), '\n')) do
            --if not vim.endswith(bundle, 'com.microsoft.java.test.runner.jar') then
                --table.insert(bundles, bundle)
            --end
        --end
    --end
    --local extendedClientCapabilities = jdtls.extendedClientCapabilities;
    --extendedClientCapabilities.resolveAdditionalTextEditsSupport = true;
    --config.init_options = {
        --bundles = bundles;
        --extendedClientCapabilities = extendedClientCapabilities;
    --}

    -- Server
    require('jdtls').start_or_attach(config)
end

return M

