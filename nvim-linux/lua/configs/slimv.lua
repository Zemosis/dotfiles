-- Slimv settings + friendly which-key labels for its raw vimscript mappings.
-- Loaded from the plugin's init (runs at startup, before slimv itself loads).

-- start the bundled SWANK server in a nvim terminal split
-- (slimv's autodetect would otherwise look for tmux/xterm)
vim.g.slimv_swank_cmd = ':botright 12split | execute "terminal sbcl --load '
    .. vim.fn.stdpath("data")
    .. '/lazy/slimv/slime/start-swank.lisp" | wincmd p'
vim.g.slimv_repl_split = 4 -- REPL window on the right

-- group all paredit commands under <leader>l ("lisp") instead of scattering
-- them across the top-level <leader> menu
vim.g.paredit_leader = "<leader>l"

-- Slimv/paredit ship without keymap descriptions, so which-key shows their
-- raw vimscript. These doc-only entries give the menus readable labels.
local descriptions = {
    { ",", group = "Slimv (Lisp)" },
    -- eval / REPL
    { ",c", desc = "Connect / start REPL" },
    { ",d", desc = "Eval defun (top-level form)" },
    { ",e", desc = "Eval current expression" },
    { ",b", desc = "Eval buffer" },
    { ",r", desc = "Eval region", mode = { "n", "v" } },
    { ",v", desc = "Eval expression (prompt)" },
    { ",-", desc = "Clear REPL" },
    { ",Q", desc = "Quit REPL" },
    { ",g", desc = "Set current package" },
    { ",u", desc = "Undefine function" },
    { ",y", desc = "Interrupt running program" },
    -- docs & inspection
    { ",h", desc = "HyperSpec docs for symbol" },
    { ",s", desc = "Describe symbol" },
    { ",A", desc = "Apropos (search symbols)" },
    { ",i", desc = "Inspect value" },
    { ",j", desc = "Find definition" },
    -- macros
    { ",1", desc = "Macroexpand once" },
    { ",m", desc = "Macroexpand all" },
    -- compile
    { ",D", desc = "Compile defun" },
    { ",F", desc = "Compile file" },
    { ",L", desc = "Compile + load file" },
    { ",R", desc = "Compile region" },
    -- debugger
    { ",t", desc = "Trace function" },
    { ",T", desc = "Untrace function" },
    { ",B", desc = "Set breakpoint" },
    { ",E", desc = "Break on exception" },
    { ",a", desc = "Debugger: abort" },
    { ",n", desc = "Debugger: continue" },
    { ",N", desc = "Debugger: restart frame" },
    { ",q", desc = "Debugger: quit level" },
    { ",l", desc = "Disassemble function" },
    -- profiler / threads
    { ",p", desc = "Profile function" },
    { ",o", desc = "Profile report" },
    { ",?", desc = "Show profiled" },
    { ",X", desc = "Profile reset" },
    { ",U", desc = "Unprofile all" },
    { ",H", desc = "List threads" },
    { ",K", desc = "Kill thread" },
    { ",G", desc = "Debug thread" },
    -- misc
    { ",)", desc = "Close open parens" },
    { ",(", desc = "Toggle paredit" },
    { ",P", desc = "Profile by name substring" },
    { ",]", desc = "Generate tags file" },
    { ",,", desc = "Slimv command menu" },
    -- paredit structural editing (grouped under <leader>l via g:paredit_leader)
    { "<leader>l", group = "paredit (lisp)" },
    { "<leader>lW", desc = "Wrap form in ( )" },
    { "<leader>lS", desc = "Splice (remove parens)" },
    { "<leader>lI", desc = "Raise (replace parent)" },
    { "<leader>lJ", desc = "Join forms" },
    { "<leader>lO", desc = "Split form" },
    { "<leader>l<", desc = "Move paren left" },
    { "<leader>l>", desc = "Move paren right" },
    { '<leader>lw', group = "wrap in ..." },
    { '<leader>lw(', desc = "Wrap in ( )" },
    { '<leader>lw"', desc = "Wrap in quotes" },
    { "<leader>l<Up>", desc = "Delete to form start + splice" },
    { "<leader>l<Down>", desc = "Delete to form end + splice" },
    { "<leader>l(", desc = "Toggle paredit" },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lisp",
    callback = function(args)
        vim.schedule(function()
            local ok, wk = pcall(require, "which-key")
            if not ok or not vim.api.nvim_buf_is_valid(args.buf) then
                return
            end
            local spec = { buffer = args.buf }
            vim.list_extend(spec, descriptions)
            wk.add(spec)
        end)
    end,
})
