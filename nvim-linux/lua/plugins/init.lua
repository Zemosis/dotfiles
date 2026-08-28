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
    -- ":" / "/" completion (NvChad sets nvim-cmp up for insert mode only)
    {
        "hrsh7th/cmp-cmdline",
        event = "CmdlineEnter",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
            require("configs.cmdline")
        end,
    },

    -- which-key ships icons for its own rules only; these give our custom
    -- maps the same treatment (doc-only entries -- the keymaps themselves
    -- live in mappings.lua and configs/molten.lua)
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>s", icon = { icon = "", color = "yellow" } },
                { "<leader>j", group = "jupyter", icon = { icon = "", color = "green" } },
                { "<leader>ji", icon = { icon = "", color = "green" } },
                { "<leader>jr", icon = { icon = "", color = "green" } },
                { "<leader>jl", icon = { icon = "", color = "green" } },
                { "<leader>jv", icon = { icon = "", color = "green" } },
                { "<leader>jc", icon = { icon = "", color = "azure" } },
                { "<leader>ja", icon = { icon = "", color = "green" } },
                { "<leader>jA", icon = { icon = "", color = "azure" } },
                { "<leader>jo", icon = { icon = "", color = "cyan" } },
                { "<leader>jh", icon = { icon = "", color = "grey" } },
                { "<leader>je", icon = { icon = "", color = "cyan" } },
                { "<leader>jn", icon = { icon = "", color = "blue" } },
                { "<leader>jp", icon = { icon = "", color = "blue" } },
                { "<leader>jk", icon = { icon = "", color = "orange" } },
                { "<leader>jR", icon = { icon = "", color = "red" } },
                { "<leader>jd", icon = { icon = "", color = "red" } },
                { "<leader>jx", icon = { icon = "", color = "purple" } },
                { "<leader>jm", icon = { icon = "", color = "purple" } },
                { "<leader>ts", icon = { icon = "", color = "yellow" } },
            },
        },
    },

    -- Jupyter kernel inside the editor: run "# %%" cells, output (including
    -- matplotlib images) renders under the cell. See configs/molten.lua.
    {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        ft = "python",
        build = ":UpdateRemotePlugins",
        dependencies = { "3rd/image.nvim" },
        -- init, not config: molten reads its g: vars while loading
        init = function()
            require("configs.molten")
        end,
    },
    {
        "3rd/image.nvim",
        ft = "python",
        opts = {
            backend = "kitty", -- ghostty speaks the kitty graphics protocol
            processor = "magick_cli", -- shells out to ImageMagick; no luarock
            integrations = {}, -- molten drives it; no markdown auto-render
            max_width_window_percentage = 100,
        },
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
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            -- JSON schema catalog for jsonls (data only, no runtime cost).
            -- version = false: the repo's tags are stale, master is the release.
            { "b0o/SchemaStore.nvim", version = false },
        },
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
