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
                                local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
                                if next(clients) == nil then
                                    return msg
                                end
                                local name = {}
                                for _, client in ipairs(clients) do
                                    table.insert(name, client.name)
                                end
                                return table.concat(name, ", ")
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
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            cursor_color = "#E46876",
            stiffness = 0.6, -- 非常软，像果冻
            trailing_stiffness = 0.1, -- 尾巴拖得很长，极其慵懒
            trailing_exponent = 25, -- 这种指数会让尾巴末端迅速收细，像水滴
            gamma = 1, -- 线性颜色混合
            damping = 0.4, -- 阻尼小，晃动感强
            particles_enabled = true,
            particles_per_second = 2000, -- 粒子很少，只是点缀
            particle_max_lifetime = 1000, -- 粒子存在时间长
            particle_gravity = 5, -- 稍微有点重力，像液体滴落
            particle_spread = 1, -- 几乎不扩散，聚在一起
            never_draw_over_target = true, -- if you want to actually see under the cursor
            hide_target_hack = true,
        },
    },
}
