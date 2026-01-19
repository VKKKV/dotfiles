return {
    -- EDITOR: Commenting
    { "numToStr/Comment.nvim", lazy = "BufReadPost", opts = {} },
    {
        "gruvw/strudel.nvim",
        build = "npm ci",
        config = function()
            require("strudel").setup()
        end,
    },
    -- EDITOR: Auto Pairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
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
}
