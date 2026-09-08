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
    -- Windows: NvChad sets sync_root_with_cwd, so opening nvim in the home dir
    -- makes nvim-tree's recursive fs watcher span %TEMP%. Mason/pip installs
    -- (e.g. clang-format, a pip package) churn thousands of files there and
    -- flood the UI with "Observed 1001 consecutive file system events".
    -- Skip watching the churn dirs. (ignore_dirs are vim regexes; nvim-tree
    -- turns "/" into "\" on Windows, so forward slashes are fine here.)
    {
        "nvim-tree/nvim-tree.lua",
        opts = function(_, opts)
            opts.filesystem_watchers = opts.filesystem_watchers or {}
            opts.filesystem_watchers.ignore_dirs = {
                "AppData/Local/Temp",
                "/node_modules",
                "/.git",
            }
            return opts
        end,
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

    -- Jupyter kernel inside the editor: run "# %%" cells; text output renders
    -- under the cell, matplotlib plots go to a WezTerm split. See configs/molten.lua.
    -- Windows note: image.nvim (kitty graphics protocol) cannot render on native
    -- Windows -- Windows blocks the escape codes -- so molten uses its "wezterm"
    -- image provider, which drives wezterm.nvim to send plots to a WezTerm split
    -- via `wezterm imgcat`. This requires running nvim inside WezTerm.
    {
        "benlubas/molten-nvim",
        version = "^1.0.0",
        ft = "python",
        build = ":UpdateRemotePlugins",
        dependencies = { "willothy/wezterm.nvim" },
        -- init, not config: molten reads its g: vars while loading
        init = function()
            require("configs.molten")
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
