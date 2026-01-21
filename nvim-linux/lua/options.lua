require("nvchad.options")

local o = vim.o

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- o.cursorlineopt ='both' -- to enable cursorline!

-- set filetype for .CBL COBOL files.
-- vim.cmd([[ au BufRead,BufNewFile *.CBL set filetype=cobol ]])

-- Function Folding
o.foldenable = true
o.foldlevel = 99
o.foldmethod = "indent"
o.foldcolumn = "0"
o.foldopen = ""
o.foldlevelstart = 0
