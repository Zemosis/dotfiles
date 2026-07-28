-- NvChad's defaults() already applies capabilities/on_init via vim.lsp.config("*")
-- and sets up keymaps through an LspAttach autocmd, so per-server overrides below
-- only need the settings that differ from the defaults.

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
    "vue_ls",
    "svelte",
}

-- Vue works in hybrid mode: vue_ls covers the template/CSS parts while ts_ls
-- must attach to .vue buffers with @vue/typescript-plugin for the script part.
-- The plugin ships inside Mason's vue-language-server package.
local vue_plugin_location = vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

vim.lsp.config("ts_ls", {
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_plugin_location,
                languages = { "vue" },
            },
        },
    },
    -- full list: vim.lsp.config replaces list values instead of merging them
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
    },
})

-- lua_ls diagnostics off: selene handles lua linting (see configs/lint.lua)
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = { enable = false },
        },
    },
})

-- clang-format via conform owns C/C++ formatting
vim.lsp.config("clangd", {
    on_attach = function(client, _)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
})

-- Installs the servers; automatic_enable starts them via vim.lsp.enable().
-- ruff is excluded: the ruff binary doubles as an LSP server, which would
-- duplicate the diagnostics nvim-lint already produces with it.
require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_enable = {
        exclude = { "ruff" },
    },
})
