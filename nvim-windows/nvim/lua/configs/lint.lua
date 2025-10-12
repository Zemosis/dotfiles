local lint = require("lint")

lint.linters_by_ft = {
    lua = { "selene" },
    -- haskell = { "hlint" },
    python = { "mypy", "ruff" },
}

-- lint.linters.luacheck.args = {
--     "--globals",
--     "love",
--     "vim",
--     "--formatter",
--     "plain",
--     "--codes",
--     "--ranges",
--     "-",
-- }
lint.linters.selene.args = { "--display-style", "compact" }

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})
