return {
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
    },
    -- Common Lisp: SLIME-like environment (REPL, eval, paredit, indentation)
    {
        "kovisoft/slimv",
        ft = "lisp",
        init = function()
            require("configs.slimv")
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        -- last main-branch commit supporting Neovim 0.11; drop this pin (and
        -- run :TSUpdate) once Neovim is upgraded to 0.12+
        commit = "90cd6580e720caedacb91fdd587b747a6e77d61f",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("configs.treesitter")
        end,
    },
    -- LSP: Install & Configure via Mason Handlers
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        dependencies = { "zapling/mason-conform.nvim" },
        config = function()
            require("configs.conform")
        end,
    },
    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "rshkarin/mason-nvim-lint" },
        config = function()
            require("configs.lint")
        end,
    },
}
