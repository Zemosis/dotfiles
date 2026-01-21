ocal lint = require("lint")
local linters = require("configs.servers").linters

lint.linters_by_ft = linters

-- Custom arguments for Selene
lint.linters.selene.args = { "--display-style", "compact" }

-- Auto-trigger linting
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})
