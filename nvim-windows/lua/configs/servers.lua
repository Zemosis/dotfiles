local M = {}

-- The single list of LSP servers you want
M.lsp_servers = {
    "lua_ls",
    "clangd",
    "pyright",
    "ts_ls",
    "tailwindcss",
    "html",
    "cssls",
}

-- The single list of formatters for Conform
M.formatters = {
    lua = { "stylua" },
    python = { "black" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
}

-- The single list of linters for nvim-lint
M.linters = {
    lua = { "selene" },
    python = { "mypy", "ruff" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
}

return M
