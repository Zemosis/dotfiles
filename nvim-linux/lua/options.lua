require("nvchad.options")

-- Re-enable the python3 provider (NvChad turns it off for startup speed);
-- slimv drives the SWANK connection through it.
vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = "/usr/bin/python3"

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
