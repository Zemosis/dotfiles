local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c_cpp = { "clang-format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        -- go = { "gofumpt", "goimports-reviser", "golines" },
        -- haskell = { "fourmolu", "stylish-haskell" },
        python = { "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
    },

    formatters = {
        -- -- C & C++
        ["clang-format"] = {
            args = {
                "-style={BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4, UseTab: Never, AccessModifierOffset: 0, IndentAccessModifiers: true, PackConstructorInitializers: Never}",
            },
        },
        -- -- Golang
        -- ["goimports-reviser"] = {
        --     prepend_args = { "-rm-unused" },
        -- },
        -- golines = {
        --     prepend_args = { "--max-len=80" },
        -- },
        -- -- Lua
        -- stylua = {
        --     prepend_args = {
        --         "--column-width", "80",
        --         "--line-endings", "Unix",
        --         "--indent-type", "Spaces",
        --         "--indent-width", "4",
        --         "--quote-style", "AutoPreferDouble",
        --     },
        -- },
        -- -- Python
        black = {
            prepend_args = {
                "--fast",
                "--line-length",
                "100",
            },
        },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 5000,
        lsp_fallback = false,
    },
}

require("conform").setup(options)
