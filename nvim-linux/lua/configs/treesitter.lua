-- nvim-treesitter main branch: no more configs module / ensure_installed.
-- Highlighting is started globally by nvchad.autocmds (vim.treesitter.start
-- on FileType); this file installs parsers and opts into treesitter indent.

pcall(function()
    dofile(vim.g.base46_cache .. "syntax")
    dofile(vim.g.base46_cache .. "treesitter")
end)

local parsers = {
    "bash",
    "c",
    "cmake",
    "commonlisp",
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
    "json", -- also covers the jsonc filetype
    "vue",
    "svelte",
}

-- async; skips parsers that are already installed
require("nvim-treesitter").install(parsers)

-- treesitter-based indentation for the languages above
-- (commonlisp excluded: slimv ships better lisp indentation)
local indent_exclude = { commonlisp = true }
local fts = {}
for _, lang in ipairs(parsers) do
    if not indent_exclude[lang] then
        vim.list_extend(fts, vim.treesitter.language.get_filetypes(lang))
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = fts,
    callback = function(args)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
