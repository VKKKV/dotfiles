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
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            -- ghost
            -- cursor_color = "none", -- 不强制颜色，跟随你的 Cursor Highlight 变化（如果插件支持），或者设个半透明灰色 #505050
            -- stiffness = 0.6,
            -- trailing_stiffness = 0.3,
            -- trailing_exponent = 5,
            -- particles_enabled = true,
            -- particles_per_second = 800,
            -- particle_max_lifetime = 600,
            -- particle_gravity = -20, -- 反重力，粒子向上飘
            -- particle_velocity_from_cursor = 0, -- 粒子不继承光标速度
            -- particle_max_initial_velocity = 5,
            -- particle_damping = 0.5, -- 很快减速，停在原地

            -- jelly
            -- cursor_color = "#DCA561",
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

            -- cyber
            -- cursor_color = "#66ccff",
            -- stiffness = 1, -- 刚度很高，光标紧跟，不拖泥带水
            -- trailing_stiffness = 100, -- 尾巴收得很快
            -- trailing_exponent = 2, -- 尾巴形状更线性
            -- distance_stop_animating = 1, -- 停下来立刻静止，不仅是省电，更是干练
            -- hide_target_hack = false, -- 这种高亮下，保留原始光标可能看着清楚点
            -- particles_enabled = true,
            -- particle_spread = 4, -- 扩散范围大
            -- particles_per_second = 3000, -- 粒子极其密集
            -- particle_max_lifetime = 1000,
            -- particle_velocity_from_cursor = 0.2, -- 粒子带有巨大的初速度
            -- particle_gravity = 0, -- 无重力，像是在太空漂浮
            -- particle_damping = 0.5, -- 几乎没有阻力
        },
    },
}
