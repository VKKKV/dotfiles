return {
    -- AI TOOLS
    {
        "qapquiz/sidekick.nvim",
        opts = { cli = { mux = { backend = "tmux", enabled = true } } },
        keys = {
            {
                "<leader>.",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle",
                mode = { "n", "t", "x" },
            },
            {
                "<leader>av",
                function()
                    require("sidekick.cli").send({ msg = "{selection}" })
                end,
                mode = { "x" },
                desc = "Send Visual Selection",
            },
            {
                "<leader>aa",
                function()
                    require("sidekick.cli").toggle()
                end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>at",
                function()
                    require("sidekick.cli").send({ msg = "{this}" })
                end,
                mode = { "x", "n" },
                desc = "Send This",
            },
            {
                "<leader>ao",
                function()
                    require("sidekick.cli").toggle({ name = "opencode", focus = true })
                end,
                desc = "Sidekick Toggle opencode",
            },
            {
                "<leader>ag",
                function()
                    require("sidekick.cli").toggle({ name = "gemini", focus = true })
                end,
                desc = "Sidekick Toggle gemini",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select()
                end,
                desc = "Select CLI",
            },
            {
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "Send File",
            },
            {
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
        },
    },
}
