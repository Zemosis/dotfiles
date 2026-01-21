local options = {
    ensure_installed = {
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "c",
        "cpp",
        "make",
        "cmake",
        "python",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "markdown",
        "markdown_inline",
        "yaml",
        "toml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
