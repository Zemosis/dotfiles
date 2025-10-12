local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

-- ---------------------------------------------------------------------
-- Define LSP server configurations
---------------------------------------------------------------------

-- Lua LS
vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable lua_ls diagnostics
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
                typeCheckingMode = "off", -- Disable type checking diagnostics
            },
        },
    },
})

-- Clangd
vim.lsp.config("clangd", {
    on_attach = function(client, bufnr)
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
        "--query-driver=C:/ProgramData/mingw64/bin/gcc.exe;C:/ProgramData/mingw64/bin/g++.exe",
    },
})

-- -- Go (gopls)
-- vim.lsp.config("gopls", {
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--     on_attach(client, bufnr)
--   end,
--   on_init = on_init,
--   capabilities = capabilities,
--   cmd = { "gopls" },
--   filetypes = { "go", "gomod", "gotmpl", "gowork" },
--   root_markers = { "go.work", "go.mod", ".git" },
--   settings = {
--     gopls = {
--       analyses = { unusedparams = true },
--       completeUnimported = true,
--       usePlaceholders = true,
--       staticcheck = true,
--     },
--   },
-- })
--
-- -- Haskell (hls)
-- vim.lsp.config("hls", {
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--     on_attach(client, bufnr)
--   end,
--   on_init = on_init,
--   capabilities = capabilities,
-- })
--

---------------------------------------------------------------------
-- Enable the servers (auto-starts when matching files open)
---------------------------------------------------------------------
vim.lsp.enable({
    "lua_ls",
    "clangd",
    "pyright",
    -- "gopls",
    -- "hls",
    -- Add more servers here when you need them
})
