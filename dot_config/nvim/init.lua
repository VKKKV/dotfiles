-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
--  PLUGINS
require("lazy").setup({
    -- CORE: Icons
    "nvim-tree/nvim-web-devicons",
    -- CORE: Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "javascript",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                    "typescript",
                    "typst",
                    "vim",
                    "vue",
                    "glsl",
                },
                auto_install = true,
                indent = { enable = true },

                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        if lang == "html" then
                            print("disabled treesitter for html")
                            return true
                        end
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            vim.notify(
                                "File larger than 100KB treesitter disabled for performance",
                                vim.log.levels.WARN,
                                { title = "Treesitter" }
                            )
                            return true
                        end
                    end,
                },
            })
        end,
    },
    -- UI: Status Line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = { theme = "gruvbox" },
                tabline = {
                    lualine_a = { "buffers" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = { "tabs" },
                },
            })
        end,
    },
    -- UI: File Explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        keys = { { "<leader>e", ":Neotree toggle<CR>" } },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    commands = {
                        avante_add_files = function(state)
                            local node = state.tree:get_node()
                            local filepath = node:get_id()
                            local relative_path = require("avante.utils").relative_path(filepath)

                            local sidebar = require("avante").get()

                            local open = sidebar:is_open()
                            -- 确保 avante 侧边栏已打开
                            if not open then
                                require("avante.api").ask()
                                sidebar = require("avante").get()
                            end

                            sidebar.file_selector:add_selected_file(relative_path)

                            -- 删除 neo tree 缓冲区
                            if not open then
                                sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
                            end
                        end,
                    },
                    window = {
                        mappings = {
                            ["oa"] = "avante_add_files",
                        },
                    },
                },
            })
        end,
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
        },
        config = function()
            require("lsp-file-operations").setup()
        end,
    },
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        config = function()
            require("window-picker").setup({
                filter_rules = {
                    include_current_win = false,
                    autoselect_one = true,
                    -- filter using buffer options
                    bo = {
                        -- if the file type is one of following, the window will be ignored
                        filetype = { "neo-tree", "neo-tree-popup", "notify" },
                        -- if the buffer type is one of following, the window will be ignored
                        buftype = { "terminal", "quickfix" },
                    },
                },
            })
        end,
    },
    -- UI: Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>" },
            { "<leader>fr", "<cmd>Telescope live_grep<cr>" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
        },
    },
    -- UI: Indent Guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    -- EDITOR: Commenting
    {
        "numToStr/Comment.nvim",
        opts = {},
        lazy = false,
    },
    -- EDITOR: Surround
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
    -- EDITOR: Multi Cursor (Kept vim-visual-multi as it has no equal pure-lua replacement yet)
    { "mg979/vim-visual-multi", branch = "master" },
    -- EDITOR: Auto Pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    -- THEME: Gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },
    -- SNIPPETS: LuaSnip
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",

        config = function()
            -- require("luasnip").setup({ enable_autosnippets = true })
            require("luasnip.loaders.from_lua").load({ paths = "./snippets" })
        end,
    },
    -- LSP: Native LSP Config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "stevearc/conform.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- formatter settings
            require("conform").setup({
                formatters_by_ft = {
                    nix = { "alejandra" },
                    lua = { "mystylua" },
                    python = { "isort", "black" },
                },
                formatters = {
                    mystylua = {
                        command = "stylua",
                        args = { "--indent-type", "Spaces", "--indent-width", "4", "-" },
                    },
                },
                format_on_save = { timeout_ms = 500, lsp_fallback = true },
            })

            -- Setup Mason (Installer for LSPs)
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "nil_ls",
                    "lua_ls",
                    "tinymist",
                    "rust_analyzer",
                    "marksman",
                    "glsl_analyzer",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = { version = "Lua 5.1" },
                                    diagnostics = {
                                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                    },
                                },
                            },
                        })
                    end,
                },
            })

            local luasnip = require("luasnip")
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            -- Autocomplete setup
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                    ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),

                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm({
                                    select = true,
                                })
                            end
                        else
                            fallback()
                        end
                    end),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
    -- Trouble
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            {
                "<leader>lq",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>ls",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>la",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        config = function()
            require("trouble").setup({
                focus = true,
                warn_no_results = false,
            })
        end,
    },
    -- MARKDOWN PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        keys = { { "<leader>o", "<cmd>MarkdownPreviewToggle<cr>" } },
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_auto_close = 1
        end,
    },
    -- TYPST PREVIEW
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        build = function()
            require("typst-preview").update()
        end,
    },
    -- COPILOT
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<C-A>",
                    },
                },
                panel = { enabled = false },
                filetypes = { markdown = false, help = false },
            })
        end,
    },
    -- AI
    {
        "yetone/avante.nvim",
        build = "make",
        event = "VeryLazy",
        version = false, -- 永远不要将此值设置为 "*"！永远不要！
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            provider = "siliconflow",
            providers = {
                claude = {
                    endpoint = "https://api.anthropic.com",
                    model = "claude-sonnet-4-20250514",
                    timeout = 30000,
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480,
                    },
                },
                siliconflow = {
                    __inherited_from = "openai",
                    endpoint = "https://api.siliconflow.cn/v1",
                    api_key_name = "SILICONFLOW_API_KEY",
                    model = "MiniMaxAI/MiniMax-M2",
                },
                openrouter = {
                    __inherited_from = "openai",
                    endpoint = "https://openrouter.ai/api/v1",
                    api_key_name = "OPENROUTER_API_KEY",
                    model = "deepseek/deepseek-r1",
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- 以下依赖项是可选的，
            "echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
            "nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
            "hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
            "ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
            "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- 用于 providers='copilot'
            {
                -- 支持图像粘贴
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- 推荐设置
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                    },
                },
            },
        },
    },
})

-- Keymaps
local opt = vim.opt

-- Settings
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- Keymaps
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.scrolloff = 4
opt.termguicolors = true
opt.signcolumn = "yes"
opt.smartindent = true
opt.wrap = true
opt.updatetime = 50
opt.list = true

opt.cursorcolumn = true
opt.cursorline = true

opt.tabstop = 4
opt.expandtab = true
opt.softtabstop = 4

opt.splitbelow = true
opt.splitright = true

opt.incsearch = true
opt.hlsearch = true

opt.ignorecase = true
opt.smartcase = true

opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

opt.foldopen = "mark,percent,quickfix,search,tag,undo"

local keymap = vim.keymap.set

keymap("n", "<leader>w", "<CMD>write<CR>", { silent = true })
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>x", ":bd<CR>")
keymap("n", "<C-L>", ":nohlsearch<CR>")

keymap("n", "<leader>n", ":bn<CR>")
keymap("n", "<leader>p", ":bp<CR>")

-- System clipboard
keymap({ "n", "v" }, "<leader>y", '"+y')

-- Resize
keymap("n", "<C-Left>", ":resize -2<CR>")
keymap("n", "<C-Right>", ":resize +2<CR>")
keymap("n", "<C-Up>", ":vertical resize -2<CR>")
keymap("n", "<C-Down>", ":vertical resize +2<CR>")

-- Comment
-- Use Ctrl+/ to toggle comments in normal and visual mode
keymap("n", "<C-_>", function()
    vim.api.nvim_feedkeys("gcc", "x", true)
end, { desc = "Toggle Line Comment" })

keymap("v", "<C-_>", function()
    vim.api.nvim_feedkeys("gb", "v", true)
end, { desc = "Toggle Line Comment" })

-- Auto Commands
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e", -- Remove trailing whitespace
})

autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "<leader>d", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
        end, opts)

        vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)
        vim.keymap.set("n", "<leader>la", function()
            vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>lr", function()
            vim.lsp.buf.rename()
        end, opts)

        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        -- vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", opts)
        -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end,
})
