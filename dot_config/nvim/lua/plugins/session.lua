return {
    "rmagatti/auto-session",
    lazy = false,
    dependencies = {
        "ibhagwan/fzf-lua",
    },
    keys = {
        { "<leader>fs", "<cmd>AutoSession search<cr>", desc = "Session Search" },
        { "<leader>qr", "<cmd>AutoSession restore<cr>", desc = "Session Restore" },
        { "<leader>qw", "<cmd>AutoSession save<cr>", desc = "Session Save" },
        { "<leader>qd", "<cmd>AutoSession delete<cr>", desc = "Session Delete" },
    },
    opts = {
        auto_restore_enabled = true,
        auto_save_enabled = true,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
}
