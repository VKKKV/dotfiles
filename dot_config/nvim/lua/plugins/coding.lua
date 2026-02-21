return {
    -- CODING: Completion, Snippets, AI
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            -- SNIPPETS: LuaSnip
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                config = function()
                    require("luasnip").setup({ enable_autosnippets = true })
                    require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })
                end,
            },
            {
                "Exafunction/windsurf.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    "saghen/blink.cmp",
                },
                config = function()
                    require("codeium").setup({
                        enable_cmp_source = false,
                        virtual_text = {
                            enabled = true,
                            key_bindings = {
                                accept = "<c-a>",
                                accept_line = "<c-f>",
                            },
                        },
                    })
                end,
            },
            { "Exafunction/codeium.nvim" },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            enabled = function()
                local path = vim.api.nvim_buf_get_name(0)
                if string.find(path, "oil://", 1, true) == 1 then
                    return false
                end
                return true
            end,
            keymap = {
                preset = "default",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
            },
            completion = {
                list = { selection = { preselect = true, auto_insert = false } },
                menu = {
                    max_height = 99,
                    auto_show = true,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    window = {
                        max_width = 99,
                        max_height = 99,
                    },
                },
            },
            snippets = {
                preset = "luasnip",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lazydev", "snippets", "lsp", "path", "buffer", "codeium" },
                providers = {
                    codeium = { name = "Codeium", module = "codeium.blink", async = true },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            signature = { enabled = true },
        },
    },

    -- CODING: Commenting
    { "numToStr/Comment.nvim", lazy = "BufReadPost", opts = {} },

    -- CODING: Auto Pairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_mode = 0
            vim.opt.conceallevel = 2
            vim.g.tex_conceal = "abdmgs"
        end,
    },
    -- CODING: Refactoring
    {
        "ThePrimeagen/refactoring.nvim",
        lazy = false,
        desc = "Refactoring tools for extracting functions, variables, and inlining code",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            local refactoring = require("refactoring")
            refactoring.setup({})

            vim.keymap.set({ "n", "x" }, "<leader>re", function()
                return refactoring.refactor("Extract Function")
            end, { expr = true, desc = "Extract Function" })
            vim.keymap.set({ "n", "x" }, "<leader>rf", function()
                return refactoring.refactor("Extract Function To File")
            end, { expr = true, desc = "Extract Function To File" })
            vim.keymap.set({ "n", "x" }, "<leader>rv", function()
                return refactoring.refactor("Extract Variable")
            end, { expr = true, desc = "Extract Variable" })
            vim.keymap.set({ "n", "x" }, "<leader>rI", function()
                return refactoring.refactor("Inline Function")
            end, { expr = true, desc = "Inline Function" })
            vim.keymap.set({ "n", "x" }, "<leader>ri", function()
                return refactoring.refactor("Inline Variable")
            end, { expr = true, desc = "Inline Variable" })

            vim.keymap.set({ "n", "x" }, "<leader>rbb", function()
                return refactoring.refactor("Extract Block")
            end, { expr = true, desc = "Extract Block" })
            vim.keymap.set({ "n", "x" }, "<leader>rbf", function()
                return refactoring.refactor("Extract Block To File")
            end, { expr = true, desc = "Extract Block To File" })

            local pick = function()
                local fzf_lua = require("fzf-lua")
                local results = refactoring.get_refactors()
                local opts = {
                    actions = {
                        ["default"] = function(selected)
                            -- Execute the selected refactoring action
                            refactoring.refactor(selected[1])
                        end,
                    },
                }
                -- Use fzf-lua to present the options
                fzf_lua.fzf_exec(results, opts)
            end
            vim.keymap.set({ "n", "x" }, "<leader>rr", pick)
        end,
    },
    -- CODING: Code Runner
    {
        "CRAG666/code_runner.nvim",
        cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
        config = function()
            require("code_runner").setup({
                mode = "term",
                focus = true,
                startinsert = true,
                filetype = {
                    c = "gcc % -o %< && ./%<",
                    cpp = "g++ % -o %< && ./%<",
                    python = "python -u",
                    sh = "bash",
                    rust = "cargo run",
                },
            })
        end,
    },
}
