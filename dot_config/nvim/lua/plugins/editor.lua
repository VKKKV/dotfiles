return {
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
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        keys = {
            {
                "<C-up>",
                function()
                    require("multicursor-nvim").lineAddCursor(-1)
                end,
                mode = { "n", "x" },
                desc = "Add cursor up",
            },
            {
                "<C-down>",
                function()
                    require("multicursor-nvim").lineAddCursor(1)
                end,
                mode = { "n", "x" },
                desc = "Add cursor down",
            },
            {
                "<C-n>",
                function()
                    require("multicursor-nvim").matchAddCursor(1)
                end,
                mode = { "n", "x" },
                desc = "Add cursor next match",
            },
            {
                "<leader>s",
                function()
                    require("multicursor-nvim").matchSkipCursor(1)
                end,
                mode = { "n", "x" },
                desc = "Skip cursor next match",
            },
            {
                "<leader>S",
                function()
                    require("multicursor-nvim").matchSkipCursor(-1)
                end,
                mode = { "n", "x" },
                desc = "Skip cursor previous match",
            },
            {
                "<leader>A",
                function()
                    require("multicursor-nvim").matchAllAddCursors()
                end,
                mode = { "n", "x" },
                desc = "Add all matches",
            },
            {
                "<esc>",
                function()
                    local mc = require("multicursor-nvim")
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    elseif mc.hasCursors() then
                        mc.clearCursors()
                    else
                        return "<esc>"
                    end
                end,
                mode = "n",
                desc = "Clear/Enable cursors",
                expr = true,
            },
        },
        config = function()
            require("multicursor-nvim").setup()
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { link = "Cursor" })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end,
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
                max_width = 0.6,
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
            { "<leader>fh", "<cmd>FzfLua history<cr>", desc = "Fzf Marks" },
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
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
            },
        },
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
        },
    },
}
