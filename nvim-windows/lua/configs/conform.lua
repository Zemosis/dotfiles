local formatters = require("configs.servers").formatters

require("conform").setup({
    formatters_by_ft = formatters,

    formatters = {
        -- Custom arguments for clang-format
        ["clang-format"] = {
            args = {
                "-style={BasedOnStyle: llvm, IndentWidth: 4, TabWidth: 4, UseTab: Never, AccessModifierOffset: 0, IndentAccessModifiers: true, PackConstructorInitializers: Never}",
            },
        },
        -- Custom arguments for black
        black = {
            prepend_args = { "--fast", "--line-length", "100" },
        },
    },

    format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = false,
    },
})
