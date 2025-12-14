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
    -- CORE: Icons (Required by many plugins)
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
                    "jsdoc",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "rust",
                    "typescript",
                    "typst",
                    "vim",
                    "vimdoc",
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
                  lualine_a = {'buffers'},
                  lualine_b = {'branch'},
                  lualine_c = {'filename'},
                  lualine_x = {},
                  lualine_y = {},
                  lualine_z = {'tabs'}
                }
            })
        end,
    },

    -- UI: File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        keys = { { "<leader>e", ":NvimTreeToggle<CR>" } },
        config = function()
            require("nvim-tree").setup({
                view = { width = 30 },
                renderer = { group_empty = true },
                filters = { dotfiles = false },
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

    -- LSP: Native LSP Config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            -- Formatting engine
            "stevearc/conform.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            require("conform").setup({
                formatters_by_ft = {
                    nix = { "alejandra" },
                },
                -- format_on_save = {
                --     timeout_ms = 300,
                --     lsp_format = "fallback",
                -- },
            })

            -- Setup Mason (Installer for LSPs)
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "tinymist",
                    "rust_analyzer",
                    "nil_ls",
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
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    runtime = { version = "Lua 5.1" },
                                    diagnostics = {
                                        globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,

                },
            })

            -- Autocomplete setup
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                window = {
                    completion = {
                        scrollbar = false,
                        border = "rounded",
                        winhighlight = "Normal:CmpNormal",
                    },
                    documentation = {
                        scrollbar = false,
                        border = "rounded",
                        winhighlight = "Normal:CmpNormal",
                    }
                },
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
            require("trouble").setup {
                focus = true,
                warn_no_results = false,
            }
        end
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
                        accept = "<C-A>", -- Ctrl+A to accept
                    },
                },
                panel = { enabled = false },
                filetypes = { markdown = false, help = false }, -- disable for markdown
            })
        end,
    },
})

-- Keymaps
local opt = vim.opt

-- Settings
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4

opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true

opt.smartindent = true
opt.wrap = true
opt.scrolloff = 4
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 50
opt.splitbelow = true
opt.splitright = true
opt.list = true

opt.incsearch = true
opt.hlsearch = true

opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- Keymaps
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
-- keymap({ "n", "v" }, "<leader>d", '"+d')

-- Window navigation
keymap("n", "<leader>h", "<C-w>h")
keymap("n", "<leader>j", "<C-w>j")
keymap("n", "<leader>k", "<C-w>k")
keymap("n", "<leader>l", "<C-w>l")

-- Resize
keymap("n", "<C-Left>", ":resize -2<CR>")
keymap("n", "<C-Right>", ":resize +2<CR>")
keymap("n", "<C-Up>", ":vertical resize -2<CR>")
keymap("n", "<C-Down>", ":vertical resize +2<CR>")

-- Autocommands
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e", -- Remove trailing whitespace
})

autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

        vim.keymap.set("n", "<leader>=", vim.lsp.buf.format)
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)

        -- vim.keymap.set("n", "<leader>p", ":TypstPreview<CR>", opts)
        -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end,
})
