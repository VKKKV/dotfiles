return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
        {
            "<leader>ld",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<leader>ls",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<leader>lq",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
    config = function()
        require("trouble").setup {
            focus = true,
            warn_no_results = false,
        }
    end
}
