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
-- Set leader key
vim.g.mapleader = " "
--  PLUGINS
require("lazy").setup({
    -- UI: Icons
    "nvim-tree/nvim-web-devicons",
    -- CORE: Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "bash", "c", "javascript", "lua", "markdown", "python", "rust", "typescript", "typst", "vim", "vue", "glsl", },
            sync_install = false,
            auto_install = true,
            indent = { enable = true },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    if lang == "html" then return true end
                    local max_filesize = 233 * 1024 -- 233 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify("File too large, Treesitter disabled", vim.log.levels.WARN)
                        return true
                    end
                end,
            },
        },
    },
    -- UI: Status Line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = { theme = "gruvbox" },
            tabline = { lualine_a = { "buffers" } },
        },
    },
    -- UI: File Explorer
    {
        "stevearc/oil.nvim",
        opts = {
            delete_to_trash = true,
            view_options = { show_hidden = true, },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = { { "<leader>e", "<CMD>Oil<CR>", desc = "Open File Explorer" } },
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
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    -- EDITOR: Commenting
    { "numToStr/Comment.nvim", lazy = false, opts = {} },
    -- EDITOR: Surround
    { "kylechui/nvim-surround", event = "VeryLazy" },
    -- EDITOR: Multi Cursor
    -- default keymaps:
    -- Ctrl-n to select word and add cursorcolumn
    -- Ctrl-Down / Ctrl-Up to add cursor below/above
    { "mg979/vim-visual-multi", branch = "master" },
    -- EDITOR: Auto Pairs
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    -- THEME: Gruvbox
    { "ellisonleao/gruvbox.nvim", priority = 1000, config = function() vim.cmd.colorscheme("gruvbox") end},
    -- SNIPPETS: LuaSnip
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = function()
            require("luasnip").setup({ enable_autosnippets = true })
            require("luasnip.loaders.from_vscode").lazy_load()
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
                    python = { "ruff", "black" },
                },
                formatters = {
                    mystylua = {
                        command = "stylua",
                        args = { "--indent-type", "Spaces", "--indent-width", "4", "-" },
                    },
                },
                -- format_on_save = { timeout_ms = 500, lsp_fallback = true },
            })

            -- Setup Mason (Installer for LSPs)
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "nil_ls", "lua_ls", "tinymist", "rust_analyzer", "marksman", "glsl_analyzer", },
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
                -- Autocomplete keymaps
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
            { "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", },
            { "<leader>ls", "<cmd>Trouble symbols toggle focus=false<cr>", },
            { "<leader>la", "<cmd>Trouble qflist toggle<cr>", },
        },
        opts = { focus = true, warn_no_results = false },
    },
    -- PREVIEW
    -- MARKDOWN PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- TYPST PREVIEW
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        build = function() require("typst-preview").update() end,
    },
    -- AI TOOLS
    {
        "qapquiz/sidekick.nvim",
        opts = { cli = { mux = { backend = "tmux", enabled = true, }, }, },
        keys = {
            {
                "<leader>ao",
                function()
                    require("sidekick.cli").toggle({ name = "opencode", focus = true })
                end,
                desc = "Sidekick Toggle opencode",
            },
            {
                "<leader>as",
                function()
                    require("sidekick.cli").select()
                end,
                desc = "Select CLI",
            },
            {
                "<leader>ad",
                function()
                    require("sidekick.cli").close()
                end,
                desc = "Detach a CLI Session",
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
                "<leader>af",
                function()
                    require("sidekick.cli").send({ msg = "{file}" })
                end,
                desc = "Send File",
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
                "<leader>ap",
                function()
                    require("sidekick.cli").prompt()
                end,
                mode = { "n", "x" },
                desc = "Sidekick Select Prompt",
            },
        },
    },
    -- COPILOT
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = true,
                auto_trigger = true,
                -- keymap to accept suggestion
                keymap = {
                    accept = "<C-a>",
                },
            },
            panel = { enabled = false },
            filetypes = { markdown = false, help = false },
        },
    },
})

-- Settings
local opt = vim.opt
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

-- Keymaps
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
keymap("n", "<leader>h", ":resize -2<CR>")
keymap("n", "<leader>l", ":resize +2<CR>")
keymap("n", "<leader>k", ":vertical resize -2<CR>")
keymap("n", "<leader>j", ":vertical resize +2<CR>")

-- Comment
-- Use Ctrl+/ to toggle comments in normal and visual mode
keymap("n", "<C-_>", function() vim.api.nvim_feedkeys("gcc", "x", true) end, { desc = "Toggle Line Comment" })
keymap("v", "<C-_>", function() vim.api.nvim_feedkeys("gb", "v", true) end, { desc = "Toggle Line Comment" })

-- Auto Commands
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWritePre", { pattern = "*", command = ":%s/\\s\\+$//e", })
autocmd("FileType", {
  pattern = "typst",
  callback = function()
    vim.keymap.set("n", "<leader>o", ":TypstPreviewToggle<CR>", { noremap = true, silent = true, })
  end,
})
autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<leader>o", ":MarkdownPreviewToggle<CR>", { noremap = true, silent = true, })
  end,
})
autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>d", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set({ "n", "v" }, "<leader>=", function()
            require("conform").format({
                async = true,
                lsp_fallback = true, -- Fallback to LSP formatting if no CLI formatter is found
            })
        end, { desc = "Format code" })
    end,
})
