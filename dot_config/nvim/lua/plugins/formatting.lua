return {
    -- FORMATTING: Conform
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                nix = { "alejandra" },
                lua = { "stylua" },
                python = { "ruff" },
                java = { "google-java-format" },
                json = { "jq" },
                rust = { "rustfmt" },
                ["_"] = { "trim_whitespace" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
