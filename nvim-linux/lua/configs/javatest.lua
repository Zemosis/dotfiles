-- Runs the JUnit tests for the current Java buffer in a terminal split.
-- Maven/Gradle projects go through their build tool. Anything else (a loose
-- folder, or an Eclipse project with only .classpath) is compiled with javac
-- into nvim's cache -- never the project's own bin/ -- and run with JUnit 4's
-- JUnitCore, or the JUnit 5 console launcher when that jar is on the classpath.
local M = {}

local home = vim.env.HOME

-- JUnit 4 from the local Maven cache: the classpath for folders that declare
-- none. configs/lspconfig.lua hands the same jars to jdtls.
M.junit4_jars = {
    home .. "/.m2/repository/junit/junit/4.13.2/junit-4.13.2.jar",
    home .. "/.m2/repository/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar",
}

local function read(path)
    local f = io.open(path)
    if not f then
        return nil
    end
    local s = f:read("*a")
    f:close()
    return s
end

-- jars from .classpath "lib" entries plus <root>/lib/**/*.jar
local function project_jars(root)
    local jars = vim.fn.glob(root .. "/lib/**/*.jar", false, true)
    for tag in (read(root .. "/.classpath") or ""):gmatch("<classpathentry[^>]*>") do
        local path = tag:match('kind="lib"') and tag:match('path="([^"]+)"')
        if path then
            table.insert(jars, vim.startswith(path, "/") and path or root .. "/" .. path)
        end
    end
    return jars
end

-- Test class for the buffer: the file itself when it is a *Test.java, else
-- its FooTest.java sibling, so the key works from the class under test too.
local function test_file(file)
    if file:match("Test%.java$") then
        return file
    end
    local sibling = file:gsub("%.java$", "Test.java")
    return vim.uv.fs_stat(sibling) and sibling or nil
end

local function package_of(file)
    for line in io.lines(file) do
        local pkg = line:match("^%s*package%s+([%w_.]+)%s*;")
        if pkg then
            return pkg
        end
    end
end

-- Shell command that runs the tests for `file`, or nil + reason.
function M.command(file)
    file = test_file(file)
    if not file then
        return nil, "no *Test.java for this file"
    end
    local pkg = package_of(file)
    local class = vim.fn.fnamemodify(file, ":t:r")
    local fqcn = pkg and pkg .. "." .. class or class
    local esc = vim.fn.shellescape

    local root = vim.fs.root(file, { "pom.xml", "build.gradle", "build.gradle.kts" })
    if root then
        local cd = "cd " .. esc(root) .. " && "
        if vim.uv.fs_stat(root .. "/pom.xml") then
            local mvn = vim.uv.fs_stat(root .. "/mvnw") and "./mvnw" or "mvn"
            return cd .. mvn .. " test -Dtest=" .. esc(fqcn)
        end
        local gradle = vim.uv.fs_stat(root .. "/gradlew") and "./gradlew" or "gradle"
        return cd .. gradle .. " test --tests " .. esc(fqcn)
    end

    -- source root = the file's folder minus one level per package segment
    local src = vim.fs.dirname(file)
    for _ in (pkg or ""):gmatch("[^.]+") do
        src = vim.fs.dirname(src)
    end
    root = vim.fs.root(file, ".classpath") or src

    local jars = project_jars(root)
    local has_junit = vim.iter(jars):any(function(j)
        return j:match("junit") ~= nil
    end)
    if not has_junit then
        vim.list_extend(jars, M.junit4_jars)
    end
    local cp = table.concat(jars, ":")
    local out = vim.fn.stdpath("cache") .. "/javatest" .. root

    -- -sourcepath makes javac compile only what the test actually references,
    -- so an unrelated broken file in the folder doesn't block the run
    local compile = ("rm -rf %s && javac -d %s -cp %s -sourcepath %s %s"):format(
        esc(out),
        esc(out),
        esc(cp),
        esc(src),
        esc(file)
    )
    local console = vim.iter(jars):find(function(j)
        return j:match("junit%-platform%-console%-standalone") ~= nil
    end)
    local run = console
            and ("java -jar %s execute -cp %s --select-class %s"):format(
                esc(console),
                esc(out .. ":" .. cp),
                esc(fqcn)
            )
        or ("java -cp %s org.junit.runner.JUnitCore %s"):format(esc(out .. ":" .. cp), esc(fqcn))
    return "cd " .. esc(root) .. " && " .. compile .. " && " .. run
end

function M.run()
    vim.cmd("silent! wall")
    local cmd, err = M.command(vim.api.nvim_buf_get_name(0))
    if not cmd then
        vim.notify("JavaTest: " .. err, vim.log.levels.WARN)
        return
    end
    require("nvchad.term").runner({ pos = "sp", id = "javatest", cmd = cmd })
end

return M
