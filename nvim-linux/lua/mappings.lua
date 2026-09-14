require("nvchad.mappings")

-- add yours here
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("t", "<leader>x", "<cmd>bd!<cr>", { desc = "Close terminal" })
map("n", "<leader>ts", "<cmd>set list!<cr>", { desc = "Toggle whitespace dots" })

-- JUnit: run the current test class (or FooTest for Foo.java) in a split
local function java_test()
    require("configs.javatest").run()
end
map("n", "<leader>tt", java_test, { desc = "Run JUnit tests" })
vim.api.nvim_create_user_command("JavaTest", java_test, { desc = "Run JUnit tests" })

-- Replace all occurrences: word under cursor (normal) or selection (visual).
-- Prefills :%s/…//gI with the cursor at the replacement spot; \< \> match
-- whole words only, \V + escape() make the visual selection literal.
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("x", "<leader>s", [[y:%s/\V<C-r>=escape(@", '/\')<CR>//gI<Left><Left><Left>]], { desc = "Replace selection" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
