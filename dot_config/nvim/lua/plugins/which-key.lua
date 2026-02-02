return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        spec = {
            mode = { "n", "v" },
            { "<leader>a", group = "AI", icon = { icon = "󰚩 ", color = "cyan" } },
            { "<leader>f", group = "find", icon = { icon = " ", color = "green" } },
            { "<leader>g", group = "git/goto", icon = { icon = "󰊢 ", color = "orange" } },
            { "<leader>l", group = "lsp/trouble", icon = { icon = "󱖫 ", color = "yellow" } },
            { "<leader>b", group = "buffer", icon = { icon = "󰓩 ", color = "azure" } },
            { "<leader>q", group = "quit/session", icon = { icon = "󰗼 ", color = "red" } },
            { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
            { "g", group = "goto" },
            { "[", group = "prev" },
            { "]", group = "next" },
        },
        win = {
            border = "rounded",
        },
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
