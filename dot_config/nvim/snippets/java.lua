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

local function get_file_name()
    return vim.fn.expand("%:t:r")
end

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

        -- lambda
        s("lam", fmt("({}) -> {}", { i(1, "params"), i(0) })),

        s("package", fmt("package {};", {
            f(get_java_package)
        })),

        -- public static final
        s("pub", {
            t("public static final "),
            i(1), -- 类型
            t(" "),
            i(2), -- 变量名
            t(" = "),
            i(3), -- 值
            t(";"),
        }),

        -- private static final
        s("pri", {
            t("private static final "),
            i(1),
            t(" "),
            i(2),
            t(" = "),
            i(3),
            t(";"),
        }),

        -- Main Method
        s("main", fmt([[
public static void main(String[] args) {{
    {}
}}
]], { i(0) })),

        -- Class definition (自动填充类名)
        s("class", fmt([[
public class {} {{
    {}
}}
]], { f(get_file_name), i(0) })),

        -- System.out.println
        s("sysout", fmt("System.out.println({});", { i(0) })),
        s("syserr", fmt("System.err.println({});", { i(0) })),

        -- For loops
        s("fori", fmt([[
for ({} {} = {}; {} < {}; {}++) {{
    {}
}}
]], { i(1, "int"), i(2, "i"), i(3, "0"), r(2), i(4, "max"), r(2), i(0) })),

        s("foreach", fmt([[
for ({} {} : {}) {{
    {}
}}
]], { i(1, "type"), i(2, "var"), i(3, "iterable"), i(0) })),

        -- Constructor
        s("cons", fmt([[
public {}($2) {{
    {}
}}
]], { f(get_file_name), i(0, "super();") })),

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

        s("ifnull", fmt([[if ({} == null) {{ {} }}]], { i(1, "condition"), i(0) })),
        s("ifnotnull", fmt([[if ({} != null) {{ {} }}]], { i(1, "condition"), i(0) })),

        -- Try-Catch
        s("try_catch", fmt([[
try {{
    {}
}} catch ({} {}) {{
    {}//TODO: handle exception
}}
]], { i(1), i(2, "Exception"), i(3, "e"), i(0) })),

        s("try_resources", fmt([[
try ({}) {{
    {}
}} catch ({} {}) {{
    {}//TODO: handle exception
}}
]], { i(1), i(2), i(3, "Exception"), i(4, "e"), i(0) })),

        -- Methods
        s("public_method", fmt([[
public {} {}({}) {{
    {}
}}
]], { i(1, "void"), i(2, "name"), i(3), i(0) })),

        s("private_method", fmt([[
private {} {}({}) {{
    {}
}}
]], { i(1, "void"), i(2, "name"), i(3), i(0) })),

        s("public_static_method", fmt([[
public static {} {}({}) {{
    {}
}}
]], { i(1, "void"), i(2, "name"), i(3), i(0) })),

        -- Fields & Misc
        s("new", fmt("{} {} = new {}();", { i(1, "Object"), i(2, "foo"), r(1) })),
        s("import", fmt("import {};", { i(1, "PackageName") })),
    }),
}
