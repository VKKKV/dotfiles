return {
    -- UI: Icons
    { "nvim-tree/nvim-web-devicons" },
    -- UI: Indent Guides
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "BufReadPre", opts = {} },
    -- UI: Smooth Scrolling
    { "karb94/neoscroll.nvim", opts = { duration_multiplier = 0.1145141919810 } },
    -- SAME WORD HIGHLIGHT
    { "RRethy/vim-illuminate", event = "BufReadPost" },
    -- UI: Status Line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = { theme = "gruvbox", section_separators = "", component_separators = "" },
            tabline = { lualine_a = { "buffers" } },
            sections = { lualine_c = { "filename" } },
        },
    },
    -- UI: File Explorer
    {
        "stevearc/oil.nvim",
        lazy = false,
        priority = 1000,
        main = "oil",
        opts = {
            delete_to_trash = true,
            view_options = { show_hidden = true },
            keymaps = {
                ["q"] = "actions.close",
            },
            float = {
                padding = 2,
                max_width = 0.8,
                max_height = 0.8,
                border = "rounded",
                win_options = { winblend = 10 },
            },
            columns = {},
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>e",
                function()
                    require("oil").toggle_float()
                end,
            },
        },
    },
    -- UI: Fuzzy Finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "FzfLua",
        keys = {
            -- File Mappings
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Fzf Files" },
            { "<leader>fr", "<cmd>FzfLua live_grep<cr>", desc = "Fzf Live Grep" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Fzf Buffers" },
            { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Fzf Keymaps" },
            { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Fzf Marks" },
        },
        opts = {
            winopts = {
                height = 0.9527,
                width = 0.666,
                preview = {
                    layout = "vertical",
                    vertical = "up:40%",
                    scrollbar = false,
                },
                backdrop = 100,
            },
            files = {
                formatter = "path.filename_first",
            },
            grep = {
                formatter = "path.filename_first",
            },
        },
        config = function(_, opts)
            local fzf = require("fzf-lua")
            fzf.setup(opts)
            fzf.register_ui_select()
        end,
    },
    -- UI ENHANCE
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        init = function()
            vim.opt.showmode = false
            vim.opt.cmdheight = 0
        end,
        config = function()
            require("noice").setup({
                presets = {
                    bottom_search = true,
                    command_palette = false,
                    long_message_to_split = true,
                    lsp_doc_border = true,
                },
                cmdline = {
                    enabled = true,
                    view = "cmdline",
                },
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                },
                routes = {
                    {
                        filter = {
                            event = "notify",
                            find = "code_action",
                        },
                        opts = { skip = true },
                    },
                },
            })
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- 核心按键绑定
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").treesitter()
                end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function()
                    require("flash").remote()
                end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function()
                    require("flash").treesitter_search()
                end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function()
                    require("flash").toggle()
                end,
                desc = "Toggle Flash Search",
            },
        },
    },
}
