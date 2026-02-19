local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix

-- Helper: Create a dynamic node that repeats the postfix match content
local function match_content(index)
    return d(index, function(_, parent)
        return sn(nil, { t(parent.snippet.env.POSTFIX_MATCH) })
    end)
end

-- Pattern for capturing postfix triggers
local text_pattern = "[%w%.%_%-%(\\)\"']+"

return {
    ----------------------------------------------------------------------------
    -- Postfix Snippets
    ----------------------------------------------------------------------------

    -- .b -> **text**
    postfix({ trig = ".b", match_pattern = text_pattern }, fmt("**{}**", {
        match_content(1)
    })),

    -- .i -> *text*
    postfix({ trig = ".i", match_pattern = text_pattern }, fmt("*{}*", {
        match_content(1)
    })),

    -- .code -> `text`
    postfix({ trig = ".code", match_pattern = text_pattern }, fmt("`{}`", {
        match_content(1)
    })),

    -- .link -> [text](url)
    postfix({ trig = ".link", match_pattern = text_pattern }, fmt("[{}]({})", {
        match_content(1),
        i(2, "url")
    })),

    ----------------------------------------------------------------------------
    -- Text Formatting
    ----------------------------------------------------------------------------
    
    -- Strikethrough: ~~text~~
    s("~~", fmt("~~{}~~{}", { i(1), i(0) })),

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

    ----------------------------------------------------------------------------
    -- Elements
    ----------------------------------------------------------------------------

    -- Link: [Text](url)
    s("link", fmt("[{}]({}){}", {
        i(1, "text"),
        i(2, "https://example.com"),
        i(0),
    })),

    -- Image: ![alt](path)
    -- Simplified from original to ensure stability
    s("img", fmt("![{}]({}){}", {
        i(1, "alt text"),
        i(2, "path/to/image"),
        i(0),
    })),

    -- Inline Code: `text`
    s("inline", fmt("`{}`{}", { i(1), i(0) })),

    -- Codeblock: ```lang ... ```
    s("bash", fmt([[
```bash
{}
```
]], { i(0) })),

    s("code", fmt([[
```{}
{}
```
]], { i(1), i(0) })),

    -- Spoiler for Hexo: {% spoiler text %}
    s("spo", fmt("{{% spoiler {} %}}", { i(1) })),

    -- Date: YYYY-MM-DD HH:MM:SS
    s("date", fmt("{}", {
        f(function()
            return os.date("%Y-%m-%d %H:%M:%S")
        end)
    })),

    ----------------------------------------------------------------------------
    -- Templates
    ----------------------------------------------------------------------------

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
        i(1, "Title"),
        f(function() return os.date("%Y-%m-%d %H:%M:%S") end),
        i(2, "tags"),
        i(3, "categories"),
        i(4, "description"),
        i(0),
    })),
}
