local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "ruff_format" },
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
        ruff_format = {
            -- flags must come after the "format" subcommand, so override args fully
            args = {
                "format",
                "--line-length",
                "100",
                "--force-exclude",
                "--stdin-filename",
                "$FILENAME",
                "-",
            },
        },
        prettier = {
            command = "prettier",
        },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
}

require("conform").setup(options)

require("mason-conform").setup({
    ignore_install = {},
})
