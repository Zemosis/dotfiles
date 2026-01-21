local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities
local servers = require("configs.servers").lsp_servers

-- Loop through the master list and setup servers
for _, lsp in ipairs(servers) do
    local opts = {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    }

    -- Specific settings for Lua
    if lsp == "lua_ls" then
        opts.settings = {
            Lua = {
                diagnostics = { enable = false }, -- using selene instead
                workspace = {
                    library = {
                        vim.fn.expand("$VIMRUNTIME/lua"),
                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                        vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                        vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    },
                },
            },
        }
    end

    -- Specific settings for Python
    if lsp == "pyright" then
        opts.settings = {
            python = { analysis = { typeCheckingMode = "basic" } },
        }
    end

    -- Specific settings for C/C++
    if lsp == "clangd" then
        opts.cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--query-driver=C:/ProgramData/mingw64/bin/gcc.exe;C:/ProgramData/mingw64/bin/g++.exe",
        }
        -- Disable formatting so conform.lua handles it
        opts.on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            on_attach(client, bufnr)
        end
    end

    -- Use the new Neovim 0.11+ API
    vim.lsp.config(lsp, opts)
end

-- Enable all servers
vim.lsp.enable(servers)
