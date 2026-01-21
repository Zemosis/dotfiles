local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

---------------------------------------------------------------------
-- Define LSP server configurations using the new API
---------------------------------------------------------------------

-- Generic setup for web-related servers
local default_servers = { "ts_ls", "tailwindcss", "html", "cssls" }

for _, lsp in ipairs(default_servers) do
    vim.lsp.config(lsp, {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    })
end

-- Lua LS
vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Diagnostics handled by selene
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

-- Pyright
vim.lsp.config("pyright", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic", -- Enabled basic checking for cleaner code
            },
        },
    },
})

-- Clangd
vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
        -- Disable formatting to let conform.lua handle it
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        on_attach(client, bufnr)
    end,
    on_init = on_init,
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=never",
        -- Path configured for your MinGW environment
        "--query-driver=C:/ProgramData/mingw64/bin/gcc.exe;C:/ProgramData/mingw64/bin/g++.exe",
    },
})

---------------------------------------------------------------------
-- Enable the servers
---------------------------------------------------------------------
vim.lsp.enable({
    "lua_ls",
    "clangd",
    "pyright",
    "ts_ls",
    "tailwindcss",
    "html",
    "cssls",
})
