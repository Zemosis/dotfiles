local options = {
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "fish",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "printf",
        "python",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        -- Web development
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "vue",
        "svelte",
    },
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    indent = { enable = true },
    autotag = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
