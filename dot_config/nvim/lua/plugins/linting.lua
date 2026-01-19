return {
    -- LINTING: nvim-lint
    {
        "mfussenegger/nvim-lint",
        dependencies = {
            {
                "rshkarin/mason-nvim-lint",
                opts = {
                    automatic_installation = true,
                },
            },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                bash = { "shellcheck" },
                sh = { "shellcheck" },
                dockerfile = { "hadolint" },
                make = { "checkmake" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                css = { "stylelint" },
                json = { "jsonlint" },
                python = { "ruff" },
                go = { "golangcilint" },
                kotlin = { "ktlint" },
                yaml = { "yamllint" },
                markdown = { "markdownlint" },
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
