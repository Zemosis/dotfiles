-- Molten: evaluates Python against a Jupyter kernel. Text output renders under
-- the cell; matplotlib plots are sent to a WezTerm split (see below).
-- Requires: pynvim + jupyter_client on vim.g.python3_host_prog, nvim running
-- inside WezTerm (for plots), and rplugin left enabled in configs/lazy.lua
-- (molten is a remote plugin).
--
-- WINDOWS: image.nvim's kitty graphics protocol is blocked on native Windows,
-- so images use molten's "wezterm" provider, which shells images out to
-- `wezterm imgcat` via wezterm.nvim. The wezterm provider requires
-- molten_auto_open_output = false; molten_virt_text_output keeps a short text
-- output visible inline (otherwise nothing shows until you open the output).
vim.g.molten_image_provider = "wezterm"
vim.g.molten_auto_open_output = false
vim.g.molten_virt_text_output = true
vim.g.molten_output_win_max_height = 20
vim.g.molten_wrap_output = true
vim.g.molten_virt_lines_off_by_1 = true

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
    -- user kernelspec dir differs by OS: %APPDATA%\jupyter on Windows,
    -- ~/.local/share/jupyter on Linux
    local specs = vim.fn.has("win32") == 1 and vim.fn.expand("~/AppData/Roaming/jupyter/kernels/")
        or vim.fn.expand("~/.local/share/jupyter/kernels/")
    if env and env ~= "" and vim.fn.isdirectory(specs .. env) == 1 then
        vim.cmd("MoltenInit " .. env)
    else
        vim.cmd("MoltenInit")
    end
end

local function map(buf, lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
end

local function attach(buf)
    map(buf, "<leader>ji", init_kernel, "Init kernel (active conda env)")
    map(buf, "<leader>jr", eval_cell, "Run cell")
    map(buf, "<leader>jl", "<cmd>MoltenEvaluateLine<cr>", "Run line")
    map(buf, "<leader>jc", "<cmd>MoltenReevaluateCell<cr>", "Re-run cell")
    map(buf, "<leader>ja", eval_all_cells, "Run all cells")
    map(buf, "<leader>jA", "<cmd>MoltenReevaluateAll<cr>", "Re-run evaluated cells")
    map(buf, "<leader>jv", ":<C-u>MoltenEvaluateVisual<cr>gv", "Run selection", "x")
    map(buf, "<leader>jo", "<cmd>MoltenShowOutput<cr>", "Show output")
    map(buf, "<leader>jh", "<cmd>MoltenHideOutput<cr>", "Hide output")
    map(buf, "<leader>je", "<cmd>noautocmd MoltenEnterOutput<cr>", "Enter output (scroll)")
    map(buf, "<leader>jn", goto_cell(1), "Next cell")
    map(buf, "<leader>jp", goto_cell(-1), "Previous cell")
    map(buf, "<leader>jk", "<cmd>MoltenInterrupt<cr>", "Interrupt kernel")
    map(buf, "<leader>jR", "<cmd>MoltenRestart!<cr>", "Restart kernel")
    map(buf, "<leader>jd", "<cmd>MoltenDelete<cr>", "Delete cell output")
    map(buf, "<leader>jx", "<cmd>MoltenExportOutput<cr>", "Export outputs to .ipynb")
    map(buf, "<leader>jm", "<cmd>MoltenImportOutput<cr>", "Import outputs from .ipynb")
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
