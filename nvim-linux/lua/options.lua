require("nvchad.options")

-- Re-enable the python3 provider (NvChad turns it off for startup speed);
-- slimv drives the SWANK connection through it and molten runs on it.
-- A dedicated venv, not the system python: a "conda activate" in the shell
-- leaks vars like PYTHONNOUSERSITE into nvim, which hides --user packages
-- and breaks the provider. This venv holds pynvim + jupyter_client and is
-- unaffected by whichever conda env is active.
vim.g.loaded_python3_provider = nil
vim.g.python3_host_prog = vim.fn.expand("~/.venvs/nvim/bin/python")

local o = vim.o

-- Indenting
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- Show indentation as dots. "lead" covers only the whitespace before the
-- first non-blank char, so spaces inside code stay invisible ("space" would
-- dot every one of them). tab/nbsp are here to make characters that look
-- like spaces but aren't stand out -- this config is spaces-only.
-- fallback for when cmp-cmdline is not driving the command line: show the
-- whole match list and complete only the common prefix, instead of jumping
-- straight to the first match
o.wildmode = "longest:full,full"

o.list = true
o.listchars = "lead:\u{b7},trail:\u{b7},tab:\u{bb} ,nbsp:\u{2423}"

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
