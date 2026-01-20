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
                "Exafunction/codeium.nvim",
                cmd = "Codeium",
                build = ":Codeium Auth",
                opts = {
                    enable_cmp_source = false,
                    virtual_text = {
                        enabled = true,
                    },
                },
            },
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
            keymap = { preset = "enter" },
            snippets = {
                preset = "luasnip",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer", "codeium" },
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
            completion = {
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
        },
    },

    -- CODING: Commenting
    { "numToStr/Comment.nvim", lazy = "BufReadPost", opts = {} },

    -- CODING: Auto Pairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
}
