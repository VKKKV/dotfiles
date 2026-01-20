return {
    -- UI: Icons
    { "nvim-tree/nvim-web-devicons" },
    -- UI: Indent Guides
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "BufReadPre", opts = {} },
    -- UI: Smooth Scrolling
    { "karb94/neoscroll.nvim", opts = { duration_multiplier = 0.1145141919810 } },
    -- UI: Highlight Same Word
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
    -- UI: Notifications & Messages
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
}