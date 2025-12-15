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

return {
    -- Italics
    s({ trig = "*", priority = -50 }, {
        t("*"),
        i(1),
        t("*"),
        i(0),
    }),
    -- Bold
    s({ trig = "**", priority = -50 }, {
        t("**"),
        i(1),
        t("**"),
        i(0),
    }),
    -- Bold Italics
    s({ trig = "***", priority = -50 }, {
        t("***"),
        i(1),
        t("***"),
        i(0),
    }),

    -- Link: [Text](url)
    s(

        "link",
        fmt("[{}]({}){}", {
            i(1),
            i(2, "https://www.url.com"),
            i(0),
        })
    ),

    -- Image: ![alt](path "title")
    s(
        "img",
        fmt("![{}]({}{}){}", {
            i(1, "pic alt"),
            i(2, "path"),
            f(function(args) -- 处理可选的 title
                if args[1][1] and args[1][1] ~= "" then
                    return ' "' .. args[1][1] .. '"'
                else
                    return ""
                end
            end, { 3 }), -- 依赖节点 3 (title)
            i(0),
        })
    ),

    -- Inline Code
    s("inline", fmt([[`{}`{}]], { i(1), i(0) })),

    -- Codeblock
    s(
        "code",
        fmt(
            [[
            ```{}
            {}
            ```
            ]],
            { i(1, "bash"), i(0) }
        )
    ),

    -- Spoiler for hexo
    s("spo", fmt([[{{% spoiler {} %}}]], { i(1) })),

    s(
        { trig = "date" },
        fmt([[{}]], { f(function(_, _)
            return os.date("%Y-%m-%d %H:%M:%S")
        end) })
    ),

    -- blog posts for hexo
    s(
        "hexo",
        fmt(
            [[
            ---
            title: {}
            date: {}
            tags: {}
            categories: {}
            description: {}
            mathjax: true
            ---
            {}
            ]],
            {
                i(1, "title"),
                i(2, "date"),
                i(3, "tags"),
                i(4, "categories"),
                i(5),
                i(0),
            }
        )
    ),
}
