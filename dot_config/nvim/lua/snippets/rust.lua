local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

-- Helper function: format strings using `~ delimiters instead of {}
-- This avoids escaping conflicts with Rust's syntax (braces, arrows, etc.)
local function f(str, nodes)
    return fmt(str, nodes, { delimiters = "`~" })
end

return {
    -- Function definitions
    s(
        "fn",
        f("fn `~(`~)`~\n{\n    `~\n}", {
            i(1, "name"),
            i(2),
            c(3, { t(""), f(" -> `~", { i(1, "Type") }) }),
            i(4, "todo!();"),
        })
    ),

    s(
        "pfn",
        f("pub fn `~(`~)`~\n{\n    `~\n}", {
            i(1, "name"),
            i(2),
            c(3, { t(""), f(" -> `~", { i(1, "Type") }) }),
            i(4, "todo!();"),
        })
    ),

    s(
        "afn",
        f("async fn `~(`~)`~\n{\n    `~\n}", {
            i(1, "name"),
            i(2),
            c(3, { t(""), f(" -> `~", { i(1, "Type") }) }),
            i(4, "todo!();"),
        })
    ),

    s(
        "pafn",
        f("pub async fn `~(`~)`~\n{\n    `~\n}", {
            i(1, "name"),
            i(2),
            c(3, { t(""), f(" -> `~", { i(1, "Type") }) }),
            i(4, "todo!();"),
        })
    ),

    s("main", f("fn main() {\n    `~\n}", { i(1, "todo!();") })),

    s(
        "new",
        f("pub fn new(`~) -> Self {\n    Self {\n        `~\n    }\n}", {
            i(1),
            i(2, "fields"),
        })
    ),

    s(
        "cnew",
        f("pub const fn new(`~) -> Self {\n    Self {\n        `~\n    }\n}", {
            i(1),
            i(2, "fields"),
        })
    ),

    -- Structs and Enums
    s(
        "struct",
        f("#[derive(Debug)]\nstruct `~ {\n    `~: `~\n}", {
            i(1, "Name"),
            i(2, "field"),
            i(3, "Type"),
        })
    ),

    s(
        "struct-tuple",
        f("#[derive(Debug)]\nstruct `~(`~);", {
            i(1, "Name"),
            i(2, "Type"),
        })
    ),

    s("struct-unit", f("#[derive(Debug)]\nstruct `~;", { i(1, "Name") })),

    s(
        "enum",
        f("#[derive(Debug)]\nenum `~ {\n    `~,\n    `~,\n}", {
            i(1, "Name"),
            i(2, "Variant1"),
            i(3, "Variant2"),
        })
    ),

    -- Traits and Implementations
    s(
        "trait",
        f("trait `~ {\n    `~\n}", {
            i(1, "Name"),
            i(2, "// add code here"),
        })
    ),

    s(
        "impl",
        f("impl `~ {\n    `~\n}", {
            i(1, "Type"),
            i(2, "// add code here"),
        })
    ),

    s(
        "impl-trait",
        f("impl `~ for `~ {\n    `~\n}", {
            i(1, "Trait"),
            i(2, "Type"),
            i(3, "// add code here"),
        })
    ),

    -- Control Flow
    s(
        "if",
        f("if `~ {\n    `~\n}", {
            i(1, "expr"),
            i(2, "todo!();"),
        })
    ),

    s(
        "if-let",
        f("if let `~ = `~ {\n    `~\n}", {
            i(1, "Some(pat)"),
            i(2, "expr"),
            i(3, "todo!();"),
        })
    ),

    s(
        "match",
        f("match `~ {\n    `~ => `~\n}", {
            i(1, "expr"),
            i(2, "pattern"),
            i(3, "todo!(),"),
        })
    ),

    s(
        "for",
        f("for `~ in `~ {\n    `~\n}", {
            i(1, "pat"),
            i(2, "iter"),
            i(3, "todo!();"),
        })
    ),

    -- Macros
    s("println", f('println!("`~");', { i(1) })),
    s("print", f('print!("`~");', { i(1) })),
    s("format", f('format!("`~")', { i(1) })),
    s("vec", f("vec![`~]", { i(1) })),
    s("panic", f('panic!("`~");', { i(1) })),

    s(
        "macro_rules",
        f("macro_rules! `~ {\n    (`~) => (`~)\n}", {
            i(1, "name"),
            i(2),
            i(3),
        })
    ),

    -- Attributes (choice node allows selecting between derive, cfg, allow, etc.)
    s(
        "attr",
        c(1, {
            f("#[derive(`~)]", { i(1, "Debug") }),
            f("#[cfg(`~)]", { i(1, "test") }),
            f("#[allow(`~)]", { i(1, "dead_code") }),
        })
    ),

    s("derive", f("#[derive(`~)]", { i(1, "Debug") })),

    -- Testing
    s("test", f("#[test]\nfn `~();", { i(1, "test_name") })),

    s(
        "modtest",
        f("#[cfg(test)]\nmod tests {\n    use super::*;\n\n    #[test]\n    fn `~() {\n        `~\n    }\n}", {
            i(1, "test_name"),
            i(2, "todo!();"),
        })
    ),

    -- Helpers
    s("ok", f("Ok(`~)", { i(1) })),
    s("err", f("Err(`~)", { i(1) })),
    s("some", f("Some(`~)", { i(1) })),
}
