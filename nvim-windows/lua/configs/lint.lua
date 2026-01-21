local lint = require("lint")

lint.linters_by_ft = {
    lua = { "selene" },
    python = { "mypy", "ruff" },
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    vue = { "eslint_d" },
    svelte = { "eslint_d" },
}

lint.linters.selene.args = { "--display-style", "compact" }

if lint.linters.eslint_d then
    lint.linters.eslint_d.args = {
        "--no-warn-ignored",
        "--format",
        "unix",
        "--stdin",
        "--stdin-filename",
        function()
            return vim.api.nvim_buf_get_name(0)
        end,
    }
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})

-- Sync with Mason: Manually build list of linters to install
local linters_to_install = {}
for _, linters in pairs(lint.linters_by_ft) do
    for _, linter in ipairs(linters) do
        table.insert(linters_to_install, linter)
    end
end

require("mason-nvim-lint").setup({
    ensure_installed = linters_to_install,
    automatic_installation = false,
})
