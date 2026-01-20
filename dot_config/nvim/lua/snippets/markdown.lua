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

-- Markdown Snippets definition
return {
    ls.add_snippets("markdown", {
        -- Strikethrough: ~~text~~
        s("~~", fmt([[~~{}~~{}]], { i(1), i(0) })),

        -- Italics: *text*
        s({ trig = "*", priority = -50 }, {
            t("*"),
            i(1),
            t("*"),
            i(0),
        }),

        -- Bold: **text**
        s({ trig = "**", priority = -50 }, {
            t("**"),
            i(1),
            t("**"),
            i(0),
        }),

        -- Bold Italics: ***text***
        s({ trig = "***", priority = -50 }, {
            t("***"),
            i(1),
            t("***"),
            i(0),
        }),

        -- Link: [Text](url)
        s("link", fmt("[{}]({}){}", {
            i(1),
            i(2, "https://www.url.com"),
            i(0),
        })),

        -- Image: ![alt](path "title")
        s("img", fmt("![{}]({}{}){}", {
            i(1, "pic alt"),
            i(2, "path"),
            f(function(args) -- Handle optional title
                if args[1][1] and args[1][1] ~= "" then
                    return ' "' .. args[1][1] .. '"'
                else
                    return ""
                end
            end, { 3 }), -- Depends on node 3 (title)
            i(0),
        })),

        -- Inline Code: `text`
        s("inline", fmt([[`{}`{}]], { i(1), i(0) })),

        -- Codeblock: ```lang ... ```
        s("code", fmt([[
```{}
{}
```
]], { i(1, "bash"), i(0) })),

        -- Spoiler for Hexo: {% spoiler text %}
        s("spo", fmt([[{{% spoiler {} %}}]], { i(1) })),

        -- Date: YYYY-MM-DD HH:MM:SS
        s({ trig = "date" }, fmt([[{}]], {
            f(function(_, _)
                return os.date("%Y-%m-%d %H:%M:%S")
            end)
        })),

        -- Blog Post Frontmatter for Hexo
        s("hexo", fmt([[
---
title: {}
date: {}
tags: {}
categories: {}
description: {}
mathjax: true
---

{}
]], {
            i(1, "title"),
            i(2, "date"),
            i(3, "tags"),
            i(4, "categories"),
            i(5),
            i(0),
        })),
    }),
}
