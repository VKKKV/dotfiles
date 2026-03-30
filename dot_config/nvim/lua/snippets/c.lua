local ls = require("luasnip")
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix

local function get_match(_, parent)
    return parent.snippet.env.POSTFIX_MATCH
end

local text_pattern = "[%S]+"

return {
    s("main", fmt([[
        int main(int argc, char *argv[]) {{
            {}
            
            return EXIT_SUCCESS;
        }}
    ]], {
        i(0, "/* Your Arch-level code here */")
    })),
    s("malloc", fmt([[
        {} *{} = malloc(sizeof({}) * {});
        if ({} == NULL) {{
            fprintf(stderr, "Fatal: failed to allocate memory.\n");
            exit(EXIT_FAILURE);
        }}
        {}
    ]], {
        i(1, "type"),       -- 类型 (例如 int, struct Node)
        i(2, "ptr"),        -- 指针变量名
        rep(1),             -- 自动重复类型，避免手滑写错 sizeof
        i(3, "1"),          -- 分配数量
        rep(2),             -- 自动重复指针变量名用于判空
        i(0)                -- 光标最后停留点
    })),
    s("inc", c(1, {
        fmt("#include <{}>", { i(1, "stdio.h") }),
        fmt('#include "{}"', { i(1, "my_header.h") }),
    })),
    s("struct", fmt([[
        struct {}{{
            {}
        }};
    ]], {
        i(1, "StructName"),
        i(2, "/* members */")
    }))
}
