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
-- Descriptions are tagged "Category · …" so configs.whichkey's sorter groups
-- them; slimv's flat single-letter keys cannot be nested into real groups.
local wkc = require("configs.whichkey")

local slimv_maps = {
    Eval = {
        { "d", "defun (top-level form)" },
        { "e", "current expression" },
        { "b", "buffer" },
        { "r", "region", { "n", "v" } },
        { "v", "expression (prompt)" },
    },
    Compile = {
        { "D", "defun" },
        { "F", "file" },
        { "L", "file + load" },
        { "R", "region" },
    },
    REPL = {
        { "c", "connect / start" },
        { "g", "set current package" },
        { "u", "undefine function" },
        { "y", "interrupt running program" },
        { "-", "clear" },
        { "Q", "quit" },
    },
    Docs = {
        { "h", "HyperSpec for symbol" },
        { "s", "describe symbol" },
        { "A", "apropos (search symbols)" },
        { "i", "inspect value" },
        { "j", "find definition" },
    },
    Macro = {
        { "1", "expand once" },
        { "m", "expand all" },
    },
    Debug = {
        { "t", "trace function" },
        { "T", "untrace function" },
        { "B", "set breakpoint" },
        { "E", "break on exception" },
        { "a", "abort" },
        { "n", "continue" },
        { "N", "restart frame" },
        { "q", "quit one level" },
        { "l", "disassemble function" },
    },
    Profile = {
        { "p", "profile function" },
        { "P", "profile by name substring" },
        { "o", "report" },
        { "?", "show profiled" },
        { "X", "reset" },
        { "U", "unprofile all" },
    },
    Threads = {
        { "H", "list" },
        { "K", "kill" },
        { "G", "debug" },
    },
    Edit = {
        { ")", "close open parens" },
        { "(", "toggle paredit" },
        { "]", "generate tags file" },
        { ",", "slimv command menu" },
    },
}

local descriptions = { { ",", group = "Slimv (Lisp)" } }
for category, maps in pairs(slimv_maps) do
    vim.list_extend(descriptions, wkc.entries(category, ",", maps))
end

-- paredit structural editing (grouped under <leader>l via g:paredit_leader)
vim.list_extend(descriptions, {
    { "<leader>l", group = "paredit (lisp)" },
    { "<leader>lW", desc = "Edit · wrap form in ( )" },
    { "<leader>lS", desc = "Edit · splice (remove parens)" },
    { "<leader>lI", desc = "Edit · raise (replace parent)" },
    { "<leader>lJ", desc = "Edit · join forms" },
    { "<leader>lO", desc = "Edit · split form" },
    { "<leader>l<", desc = "Edit · move paren left (barf)" },
    { "<leader>l>", desc = "Edit · move paren right (slurp)" },
    { "<leader>lw", group = "wrap in ..." },
    { "<leader>lw(", desc = "Edit · wrap in ( )" },
    { '<leader>lw"', desc = "Edit · wrap in quotes" },
    { "<leader>l<Up>", desc = "Edit · delete to form start + splice" },
    { "<leader>l<Down>", desc = "Edit · delete to form end + splice" },
    { "<leader>l(", desc = "Edit · toggle paredit" },
})

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
