local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local postfix = require("luasnip.extras.postfix").postfix

local function get_match(_, parent)
    return parent.snippet.env.POSTFIX_MATCH
end

local text_pattern = "[%S]+"

return {
    -- Date: YYYY-MM-DD HH:MM:SS
    s("date", fmt("{}", {
        f(function()
            return os.date("%Y-%m-%d %H:%M:%S")
        end)
    })),

    -- Time: HH:MM:SS
    s("time", fmt("{}", {
        f(function()
            return os.date("%H:%M:%S")
        end)
    })),
}
