-- Molten: evaluates Python against a Jupyter kernel and renders the result
-- (text and images) in a floating window under the cell.
-- Requires: pynvim + jupyter_client on vim.g.python3_host_prog, ImageMagick,
-- "set -g allow-passthrough on" in tmux, and rplugin left enabled in
-- configs/lazy.lua (molten is a remote plugin).

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
vim.g.molten_wrap_output = true
vim.g.molten_virt_lines_off_by_1 = true

-- Two ways to show output, swapped at runtime by <leader>jt:
--   virtual text -- drawn below the cell and stays there once you move away
--   floating window -- follows the cursor, only visible inside the cell
-- Start in virtual text; "both" keeps matplotlib images rendering in either
-- mode (they default to the float only).
local VIRT_TEXT_DEFAULT = true

vim.g.molten_virt_text_output = VIRT_TEXT_DEFAULT
vim.g.molten_virt_text_max_lines = 20
vim.g.molten_image_location = "both"
vim.g.molten_auto_open_output = not VIRT_TEXT_DEFAULT

-- Molten evaluates motions/selections; it has no notion of "# %%" cells, so
-- find the surrounding markers and hand the range to MoltenEvaluateVisual.
local eval_range
local CELL = "^#%s*%%%%"

local function cell_bounds(cur)
    cur = cur or vim.api.nvim_win_get_cursor(0)[1]
    local last = vim.api.nvim_buf_line_count(0)
    local lines = vim.api.nvim_buf_get_lines(0, 0, last, false)

    local first = 1
    for i = cur, 1, -1 do
        if lines[i]:match(CELL) then
            first = i + 1 -- the marker itself is not code
            break
        end
    end

    local final = last
    for i = cur + 1, last do
        if lines[i]:match(CELL) then
            final = i - 1
            break
        end
    end

    -- trim trailing blank lines so the output window sits under the code
    while final > first and lines[final]:match("^%s*$") do
        final = final - 1
    end
    return first, final
end

-- true when the range holds something other than blanks and comments; molten
-- would otherwise create an empty output block for a comment-only cell
local function has_code(first, final)
    for _, l in ipairs(vim.api.nvim_buf_get_lines(0, first - 1, final, false)) do
        if not l:match("^%s*$") and not l:match("^%s*#") then
            return true
        end
    end
    return false
end

-- MoltenEvaluateVisual reads the '< '> marks; setting them directly is more
-- reliable than driving visual mode from inside a keymap callback
eval_range = function(first, final)
    local last_col = #(vim.api.nvim_buf_get_lines(0, final - 1, final, false)[1] or "")
    vim.api.nvim_buf_set_mark(0, "<", first, 0, {})
    vim.api.nvim_buf_set_mark(0, ">", final, math.max(last_col - 1, 0), {})
    vim.cmd("MoltenEvaluateVisual")
end

local function eval_cell()
    local first, final = cell_bounds()
    if first > final then
        vim.notify("Molten: empty cell", vim.log.levels.WARN)
        return
    end
    eval_range(first, final)
end

-- MoltenReevaluateAll only re-runs cells that already have output, so on a
-- fresh kernel it does nothing. This walks every "# %%" block in the buffer.
local function eval_all_cells()
    local last = vim.api.nvim_buf_line_count(0)
    local lines = vim.api.nvim_buf_get_lines(0, 0, last, false)

    local starts = {}
    if not (lines[1] or ""):match(CELL) then
        starts[1] = 1 -- code above the first marker is a cell too
    end
    for i, l in ipairs(lines) do
        if l:match(CELL) then
            starts[#starts + 1] = i + 1
        end
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local ran = 0
    for _, s in ipairs(starts) do
        if s <= last then
            local first, final = cell_bounds(s)
            if first <= final and has_code(first, final) then
                eval_range(first, final)
                ran = ran + 1
            end
        end
    end
    pcall(vim.api.nvim_win_set_cursor, 0, cursor)
    vim.notify(string.format("Molten: queued %d cell%s", ran, ran == 1 and "" or "s"))
end

local function goto_cell(dir)
    return function()
        local cur = vim.api.nvim_win_get_cursor(0)[1]
        local last = vim.api.nvim_buf_line_count(0)
        local lines = vim.api.nvim_buf_get_lines(0, 0, last, false)
        local range = dir > 0 and vim.fn.range(cur + 1, last) or vim.fn.range(cur - 1, 1, -1)
        for _, i in ipairs(range) do
            if lines[i] and lines[i]:match(CELL) then
                vim.api.nvim_win_set_cursor(0, { i, 0 })
                return
            end
        end
    end
end

-- Don't hardcode a kernel: prefer the activated conda env when a kernelspec
-- of that name exists, otherwise let MoltenInit prompt with the list.
local function init_kernel()
    local env = vim.env.CONDA_DEFAULT_ENV
    local specs = vim.fn.expand("~/.local/share/jupyter/kernels/")
    if env and env ~= "" and vim.fn.isdirectory(specs .. env) == 1 then
        vim.cmd("MoltenInit " .. env)
    else
        vim.cmd("MoltenInit")
    end
end

-- Molten caches its options at load (it is a remote plugin), so flipping a
-- g: var after the fact does nothing -- MoltenUpdateOption is the supported
-- way in. Turning virt text *on* redraws every existing output on the next
-- update; turning it *off* only stops new ones, so virt text already on
-- screen sticks around until that cell is re-run (<leader>jc) or its output
-- deleted (<leader>jd). Molten exposes no "clear all virt text" call.
local virt_text = VIRT_TEXT_DEFAULT

local function toggle_output_mode()
    virt_text = not virt_text
    local ok = pcall(function()
        vim.fn.MoltenUpdateOption("virt_text_output", virt_text)
        vim.fn.MoltenUpdateOption("auto_open_output", not virt_text)
        vim.fn.MoltenUpdateInterface()
    end)
    if not ok then
        virt_text = not virt_text -- no kernel yet; leave the state alone
        vim.notify("Molten: no kernel running (<leader>ji first)", vim.log.levels.WARN)
        return
    end
    vim.notify(
        "Molten output: " .. (virt_text and "virtual text (stays)" or "floating window (follows cursor)")
    )
end

-- Grouped by purpose, not by key: configs.whichkey turns the category and
-- the position in each list into which-key's sort order, so the menu reads
-- kernel -> run -> output -> move -> notebook.
local menu = {
    { "Kernel", {
        { "i", "Init (active conda env)", init_kernel },
        { "k", "Interrupt", "<cmd>MoltenInterrupt<cr>" },
        { "R", "Restart", "<cmd>MoltenRestart!<cr>" },
    } },
    { "Run", {
        { "r", "Cell", eval_cell },
        { "l", "Line", "<cmd>MoltenEvaluateLine<cr>" },
        { "v", "Selection", ":<C-u>MoltenEvaluateVisual<cr>gv", "x" },
        { "c", "Re-run cell", "<cmd>MoltenReevaluateCell<cr>" },
        { "a", "All cells", eval_all_cells },
        { "A", "Re-run evaluated cells", "<cmd>MoltenReevaluateAll<cr>" },
    } },
    { "Output", {
        { "t", "Toggle virtual text / float", toggle_output_mode },
        { "o", "Show", "<cmd>MoltenShowOutput<cr>" },
        { "h", "Hide", "<cmd>MoltenHideOutput<cr>" },
        { "e", "Enter (scroll)", "<cmd>noautocmd MoltenEnterOutput<cr>" },
        { "d", "Delete", "<cmd>MoltenDelete<cr>" },
    } },
    { "Move", {
        { "n", "Next cell", goto_cell(1) },
        { "p", "Previous cell", goto_cell(-1) },
    } },
    { "Notebook", {
        { "x", "Export outputs to .ipynb", "<cmd>MoltenExportOutput<cr>" },
        { "m", "Import outputs from .ipynb", "<cmd>MoltenImportOutput<cr>" },
    } },
}

local function attach(buf)
    local wkc = require("configs.whichkey")
    local spec = { buffer = buf }

    for _, group in ipairs(menu) do
        local category, maps = group[1], group[2]
        local labels = {}
        for i, m in ipairs(maps) do
            local key, label, rhs, mode = m[1], m[2], m[3], m[4]
            vim.keymap.set(mode or "n", "<leader>j" .. key, rhs, {
                buffer = buf,
                desc = category .. wkc.SEP .. label,
            })
            labels[i] = { key, label, mode }
        end
        vim.list_extend(spec, wkc.entries(category, "<leader>j", labels))
    end

    local ok, wk = pcall(require, "which-key")
    if ok then
        wk.add(spec)
    end
end

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function(args)
        attach(args.buf)
    end,
})

-- init runs on the FileType event that loads molten, so the buffer that
-- triggered it has already missed the autocmd above
if vim.bo.filetype == "python" then
    attach(vim.api.nvim_get_current_buf())
end
