local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

-- List of servers to ensure are installed
local servers = {
    "lua_ls",
    "clangd",
    "pyright",
    "html",
    "cssls",
    "tailwindcss",
    "ts_ls",
    "jsonls",
    "emmet_ls",
}

-- Setup Mason and use 'handlers' to configure servers automatically
mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = false,
    handlers = {
        -- The default handler (runs for every server unless overridden below)
        function(server_name)
            lspconfig[server_name].setup({
                on_attach = on_attach,
                on_init = on_init,
                capabilities = capabilities,
            })
        end,

        -- Custom overrides for specific servers
        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                on_init = on_init,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { enable = false },
                        workspace = {
                            library = {
                                vim.fn.expand("$VIMRUNTIME/lua"),
                                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                                vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                                vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                            },
                            maxPreload = 100000,
                            preloadFileSize = 10000,
                        },
                    },
                },
            })
        end,

        ["pyright"] = function()
            lspconfig.pyright.setup({
                on_attach = on_attach,
                on_init = on_init,
                capabilities = capabilities,
                settings = {
                    python = { analysis = { typeCheckingMode = "off" } },
                },
            })
        end,

        ["clangd"] = function()
            lspconfig.clangd.setup({
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    on_attach(client, bufnr)
                end,
                on_init = on_init,
                capabilities = capabilities,
            })
        end,
    },
})
