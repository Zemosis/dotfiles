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
        cmd = "TroubleToggle",
        opts = {},
    },
    {
        "numToStr/Comment.nvim",
        event = "BufReadPre",
        config = true,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
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
