-- Completion in the ":" and "/" command lines. NvChad wires nvim-cmp for
-- insert mode only, so without this the command line falls back to wildmenu
-- (which needs an explicit <Tab>).
local cmp = require("cmp")

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "async_path" },
    }, {
        -- ignore_cmds: these read better with the plain wildmenu
        { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
})

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
})
