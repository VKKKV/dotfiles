return {
    -- UI: Icons
    { "nvim-tree/nvim-web-devicons" },
    -- UI: Indent Guides
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "BufReadPre", opts = {} },
    -- UI: Smooth Scrolling
    { "karb94/neoscroll.nvim", opts = { duration_multiplier = 0.1145141919810 } },
    -- UI: Highlight Same Word
    { "RRethy/vim-illuminate", event = "BufReadPost" },
    -- UI: Notifications & Messages
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            local notify = require("notify")
            vim.notify = notify

            notify.setup({
                stages = "static",
                render = "minimal",
                timeout = 2880,
                max_width = function()
                    return math.floor(vim.o.columns * 0.4)
                end,
                top_down = false,
                level = vim.log.levels.INFO,
            })
        end,
    },
    -- UI: Fidget
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                    align = "top",
                    x_padding = 1,
                    y_padding = 1,
                },
                view = {
                    stack_upwards = false,
                },
            },
            progress = {
                display = {
                    done_icon = "✔",
                },
            },
        },
    },
    -- UI: Status Line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", lazy = true },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "gruvbox_dark",
                    globalstatus = true,
                    section_separators = "",
                    component_separators = "",
                },
                tabline = { lualine_a = { "buffers" } },
                sections = {
                    lualine_c = {
                        "filename",
                        "lsp_progress",
                        {
                            function()
                                local msg = "No Active Lsp"
                                local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
                                local clients = vim.lsp.get_clients()
                                if next(clients) == nil then
                                    return msg
                                end
                                for _, client in ipairs(clients) do
                                    local filetypes = client.config.filetypes
                                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                                        return client.name
                                    end
                                end
                                return msg
                            end,
                        },
                    },
                    lualine_z = { "location" },
                },
            })
        end,
    },
    {
        "uga-rosa/ccc.nvim",
        cmd = "CccPick",
        config = true,
    },
    {
        "brenoprata10/nvim-highlight-colors",
        config = function()
            require("nvim-highlight-colors").setup({})
        end,
    },
}
