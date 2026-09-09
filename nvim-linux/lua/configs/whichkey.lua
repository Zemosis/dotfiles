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
}

-- which-key sorters are key extractors, not comparators: the view compares
-- sort(a) < sort(b). Untagged entries all return the same value, so this is
-- inert in every menu that does not use the "Category · …" convention.
function M.sort(item)
    local cat = (item.desc or ""):match("^(%a+)%s·")
    local entry = cat and M.categories[cat]
    return entry and entry.rank or 99
end

-- Build which-key spec entries for a list of { key, text[, mode] } under one
-- category, e.g. M.entries("Eval", ",", { { "d", "defun" } }).
function M.entries(category, prefix, maps)
    local cat = M.categories[category]
    local out = {}
    for _, m in ipairs(maps) do
        out[#out + 1] = {
            prefix .. m[1],
            desc = category .. M.SEP .. m[2],
            icon = { icon = cat.icon, color = cat.color },
            mode = m[3],
        }
    end
    return out
end

return M
