local servers = require("configs.servers").lsp_servers

require("mason-lspconfig").setup({
    ensure_installed = servers,
    automatic_installation = false,
})
