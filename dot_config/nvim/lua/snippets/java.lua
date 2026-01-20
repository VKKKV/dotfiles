local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local l = require("luasnip.extras").lambda
local r = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local events = require("luasnip.util.events")

-- Helper: Get current file name without extension
local function get_file_name()
    return vim.fn.expand("%:t:r")
end

-- Helper: Calculate Java package based on file path
local function get_java_package()
    local file_path = vim.fn.expand("%:p:h")
    local _, match_end = string.find(file_path, "src/main/java/")
 
    if not match_end then
        _, match_end = string.find(file_path, "src/")
    end

    if match_end then
        local package_path = string.sub(file_path, match_end + 1)
        return string.gsub(package_path, "/", ".")
    end

    return "kita.default"
end

return {
    ls.add_snippets("java", {
        -- Main Method
        s("main", fmt([[
public static void main(String[] args) {{
    {}
}}
]], { i(0) })),
        s("psvm", fmt([[
public static void main(String[] args) {{
    {}
}}
]], { i(0) })),

        -- Package Declaration
        s("package", fmt("package {};", { f(get_java_package) })),

        -- Class Definition
        s("class", fmt([[
public class {} {{
    {}
}}
]], { f(get_file_name), i(0) })),

        -- Enum Definition
        s("enum", fmt([[
public enum {} {{
    {}
}}
]], { f(get_file_name), i(0) })),

        -- Constructor
        s("constructor", fmt([[
public {}({}) {{
    {}
}}
]], { f(get_file_name), i(1), i(0) })),

        -- Print to StdOut
        s("sysout", fmt("System.out.println({});", { i(0) })),
        s("sout", fmt("System.out.println({});", { i(0) })),

        -- Print to StdErr
        s("syserr", fmt("System.err.println({});", { i(0) })),
        s("serr", fmt("System.err.println({});", { i(0) })),

        -- For Loop (Indexed)
        s("fori", fmt([[
for ({} {} = {}; {} < {}; {}++) {{
    {}
}}
]], { i(1, "int"), i(2, "i"), i(3, "0"), r(2), i(4, "max"), r(2), i(0) })),

        -- For-Each Loop
        s("foreach", fmt([[
for ({} {} : {}) {{
    {}
}}
]], { i(1, "type"), i(2, "var"), i(3, "iterable"), i(0) })),

        -- Conditionals
        s("if", fmt([[
if ({}) {{
    {}
}}
]], { i(1, "condition"), i(0) })),

        s("ifelse", fmt([[
if ({}) {{
    {}
}} else {{
    {}
}}
]], { i(1, "condition"), i(2), i(0) })),

        s("ifnull", fmt("if ({} == null) {{ {} }}", { i(1, "condition"), i(0) })),
        s("ifnotnull", fmt("if ({} != null) {{ {} }}", { i(1, "condition"), i(0) })),

        -- Try-Catch
        s("try_catch", fmt([[
try {{
    {}
}} catch ({} {}) {{
    {} // TODO: handle exception
}}
]], { i(1), i(2, "Exception"), i(3, "e"), i(0) })),

        -- Try-with-Resources
        s("try_resources", fmt([[
try ({}) {{
    {}
}} catch ({} {}) {{
    {} // TODO: handle exception
}}
]], { i(1), i(2), i(3, "Exception"), i(4, "e"), i(0) })),

        -- Variable Instantiation
        s("new", fmt("{} {} = new {}();", { i(1, "Object"), i(2, "foo"), r(1) })),

        -- Lambda
        s("lam", fmt("({}) -> {}", { i(1, "params"), i(0) })),
    }),
}
