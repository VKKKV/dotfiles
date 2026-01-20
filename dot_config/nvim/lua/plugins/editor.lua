return {
    -- EDITOR: Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = "<leader>t",
                direction = "horizontal",
                shade_terminals = true,
            })
        end,
    },
    -- EDITOR: Git
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    -- EDITOR: Multi Cursor
    {
        "mg979/vim-visual-multi",
        branch = "master",
        event = "BufReadPost",
    },
    -- EDITOR: Task Runner / Workflow
    {
        "gruvw/strudel.nvim",
        build = "npm ci",
        config = function()
            require("strudel").setup()
        end,
    },
    -- EDITOR: File Explorer
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
    -- EDITOR: Fuzzy Finder
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
    -- EDITOR: Navigation / Motion
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