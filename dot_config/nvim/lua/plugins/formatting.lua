return {
    -- FORMATTING: Conform
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                nix = { "alejandra" },
                lua = { "stylua" },
                python = { "ruff_organize_imports", "ruff_format" },
                java = { "google-java-format" },
                rust = { "rustfmt" },
                html = { "prettier" },
                css = { "prettier" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                markdown = { "prettier" },
                ["_"] = { "trim_whitespace" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                prettier = {
                    prepend_args = function(_, ctx)
                        if vim.endswith(ctx.filename, ".njk") then
                            return { "--parser", "html" }
                        end
                        if vim.endswith(ctx.filename, ".styl") then
                            return { "--parser", "css" }
                        end
                        return {}
                    end,
                },
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
}
