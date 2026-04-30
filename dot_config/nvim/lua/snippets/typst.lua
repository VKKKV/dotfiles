local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local postfix = require("luasnip.extras.postfix").postfix

local function get_match(_, parent)
    return parent.snippet.env.POSTFIX_MATCH
end

local text_pattern = "[%S]+"

return {
    -- math modes
    s({ trig = "mt", snippetType = "autosnippet" }, fmta("$<>$ ", { i(1) })),
    s({ trig = "mmt", snippetType = "autosnippet" }, fmta("$ <> $ ", { i(1) })),
    s({ trig = "i" }, fmt("==>", {})),
    s(
        { trig = "([^%s]*)", regTrig = true },
        fmta([[$<>$ <>]], {
            f(function(_, s)
                return s.captures[1]
            end),
            i(1),
        })
    ),
    s({ trig = "cent" }, fmta("#align(center)[<>]", { i(1) })),
    s({ trig = "v" }, fmta("#let <> = <>", { i(1), i(2) })),
    s(
        { trig = "f" },
        fmta(
            [[
#let <> = (<>) = {
	<>
}]],
            { i(1), i(2), i(3) }
        )
    ),
}
