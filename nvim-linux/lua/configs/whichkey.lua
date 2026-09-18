-- Shared which-key pieces: the category table the Lisp menu is built from,
-- and a sorter that groups menu entries by those categories.
local M = {}

M.SEP = " · "

-- Slimv's mappings are flat single letters, so they cannot be nested into
-- real which-key groups. Instead every description is tagged "Category · …"
-- and the sorter below orders by category, which puts related commands
-- next to each other and gives each group one icon and colour.
M.categories = {
    Eval = { rank = 1, icon = "\u{f04b}", color = "green" },
    Compile = { rank = 2, icon = "\u{f085}", color = "azure" },
    REPL = { rank = 3, icon = "\u{f120}", color = "cyan" },
    Docs = { rank = 4, icon = "\u{f02d}", color = "blue" },
    Macro = { rank = 5, icon = "\u{f0e7}", color = "purple" },
    Debug = { rank = 6, icon = "\u{f188}", color = "red" },
    Profile = { rank = 7, icon = "\u{f080}", color = "orange" },
    Threads = { rank = 8, icon = "\u{f0c0}", color = "yellow" },
    Edit = { rank = 9, icon = "\u{f044}", color = "grey" },

    -- Jupyter/molten menu (<leader>j). Ranks are namespaced away from the
    -- Lisp ones above purely for readability -- the two menus are filetype
    -- scoped (python vs lisp) and never appear together.
    Kernel = { rank = 11, icon = "\u{f135}", color = "azure" },
    Run = { rank = 12, icon = "\u{f04b}", color = "green" },
    Output = { rank = 13, icon = "\u{f06e}", color = "cyan" },
    Move = { rank = 14, icon = "\u{f0dc}", color = "blue" },
    Notebook = { rank = 15, icon = "\u{f02d}", color = "purple" },
}

-- Sort keys by description, filled in by M.entries. which-key's spec has no
-- user-settable "order" field, so the sorter below is the only hook for
-- ordering *within* a category; this table carries the declaration order
-- across to it.
M.order = {}

-- which-key sorters are key extractors, not comparators: the view compares
-- sort(a) < sort(b). Untagged entries all return the same value, so this is
-- inert in every menu that does not use the "Category · …" convention.
function M.sort(item)
    local desc = item.desc or ""
    local known = M.order[desc]
    if known then
        return known
    end
    -- tagged by hand rather than through M.entries: order within the group
    -- falls back to which-key's own sorters
    local cat = desc:match("^(%a+)%s·")
    local entry = cat and M.categories[cat]
    return entry and entry.rank * 100 or 9999
end

-- Build which-key spec entries for a list of { key, text[, mode] } under one
-- category, e.g. M.entries("Eval", ",", { { "d", "defun" } }).
-- Records each description's sort key in M.order, so the menu shows the maps
-- in the order they are declared here rather than alphanumerically.
function M.entries(category, prefix, maps)
    local cat = M.categories[category]
    local out = {}
    for i, m in ipairs(maps) do
        local desc = category .. M.SEP .. m[2]
        M.order[desc] = cat.rank * 100 + i
        out[#out + 1] = {
            prefix .. m[1],
            desc = desc,
            icon = { icon = cat.icon, color = cat.color },
            mode = m[3],
        }
    end
    return out
end

return M
