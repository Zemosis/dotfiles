local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c_cpp = { "clang-format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "black" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        vue = { "prettier" },
    },

    formatters = {
        ["clang-format"] = {
            prepend_args = {
                "-style={"
                    .. "IndentWidth: 4, "
                    .. "TabWidth: 4, "
                    .. "UseTab: Never, "
                    .. "AccessModifierOffset: 0, "
                    .. "IndentAccessModifiers: true, "
                    .. "PackConstructorInitializers: Never"
                    .. "}",
            },
        },
        black = {
            prepend_args = { "--fast", "--line-length", "100" },
        },
        prettier = {
            command = "prettierd",
            fallback = "prettier",
            args = {
                "--print-width",
                "100",
                "--tab-width",
                "2",
                "--use-tabs",
                "false",
                "--single-quote",
                "true",
                "--trailing-comma",
                "es5",
                "--arrow-parens",
                "avoid",
            },
        },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = true,
    },
}

require("conform").setup(options)

require("mason-conform").setup({
    ignore_install = {},
})
