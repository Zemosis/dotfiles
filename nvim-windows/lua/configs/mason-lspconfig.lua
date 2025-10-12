local mason_lspconfig = require("mason-lspconfig")

-- List of servers we want installed by mason
-- (must match the ones you defined in lspconfig.lua)
local servers = {
    "lua_ls",
    "clangd",
    "pyright",
    -- "gopls",
    -- "hls",
}

-- Ignore certain servers if needed
local ignore_install = {}

local function filter_servers(list, ignore)
    local result = {}
    for _, s in ipairs(list) do
        local skip = false
        for _, ign in ipairs(ignore) do
            if s == ign then
                skip = true
                break
            end
        end
        if not skip then
            table.insert(result, s)
        end
    end
    return result
end

mason_lspconfig.setup({
    ensure_installed = filter_servers(servers, ignore_install),
    automatic_installation = false,
})
