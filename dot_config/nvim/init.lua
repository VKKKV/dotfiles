-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
    { "nvim-tree/nvim-web-devicons" },
    -- UI: Indent Guides
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "BufReadPre", opts = {} },
    -- UI: Smooth Scrolling
    { "karb94/neoscroll.nvim", opts = {} },
    -- SAME WORD HIGHLIGHT
    { "RRethy/vim-illuminate", event = "BufReadPost" },
    -- EDITOR: Commenting
    { "numToStr/Comment.nvim", lazy = "BufReadPost", opts = {} },
    -- EDITOR: Auto Pairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = "<C-t>",
                direction = "horizontal",
                shade_terminals = true,
            })
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    -- EDITOR: Surround
    {
        "nvim-mini/mini.surround",
        version = "*",
        config = function()
            require("mini.surround").setup({})
        end,
    },
    -- EDITOR: Multi Cursor
    {
        "mg979/vim-visual-multi",
        branch = "master",
        event = "BufReadPost",
    },
    -- THEME: Gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },
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
    -- UI: File Explorer
    {
        "stevearc/oil.nvim",
        main = "oil",
        opts = {
            delete_to_trash = true,
            view_options = { show_hidden = true },
            keymaps = {
                ["q"] = "actions.close",
            },
            float = {
                padding = 2,
                max_width = 0.8,
                max_height = 0.8,
                border = "rounded",
                win_options = { winblend = 10 },
            },
            columns = {},
            default_file_explorer = true,
            skip_confirm_for_simple_edits = true,
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>e",
                function()
                    require("oil").toggle_float()
                end,
            },
        },
    },
    -- UI: Fuzzy Finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "FzfLua",
        keys = {
            -- File Mappings
            { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Fzf Files" },
            { "<leader>fr", "<cmd>FzfLua live_grep<cr>", desc = "Fzf Live Grep" },
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Fzf Buffers" },
            { "<leader>fl", "<cmd>FzfLua blines<cr>", desc = "Fzf Current Buffer Lines" },
            { "<leader>ft", "<cmd>FzfLua tabs<cr>", desc = "Fzf Tabs" },
            { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Fzf Help Tags" },
            { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Fzf Keymaps" },
            { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Fzf Marks" },
            { "<leader>f=", "<cmd>FzfLua spell_suggest<cr>", desc = "Spelling suggestions" },
        },
        opts = {
            winopts = {
                height = 0.9,
                width = 0.85,
                preview = {
                    layout = "vertical",
                    vertical = "up:40%",
                    scrollbar = false,
                },
                backdrop = 100,
            },
            files = {
                formatter = "path.filename_first",
            },
            grep = {
                formatter = "path.filename_first",
            },
        },
        config = function(_, opts)
            local fzf = require("fzf-lua")
            fzf.setup(opts)
            fzf.register_ui_select()
        end,
    },
    -- UI ENHANCE
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
    -- CORE: Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "BufNewFile" },
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "markdown",
                "markdown_inline",
                "python",
                "java",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    if lang == "html" then
                        return true
                    end
                    local max_filesize = 114 * 1024 -- 114 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify("File too large, Treesitter disabled", vim.log.levels.WARN)
                        return true
                    end
                end,
            },
            indent = {
                enable = true,
                disable = function(_, buf)
                    local max_filesize = 514 * 1024 -- 514 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify("File too large, indent disabled", vim.log.levels.WARN)
                        return true
                    end
                end,
            },
        },
    },
    -- FORMATTING: Conform
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                nix = { "alejandra" },
                lua = { "stylua" },
                python = { "ruff" },
                java = { "google-java-format" },
                json = { "jq" },
                ["_"] = { "trim_whitespace" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    -- COMPLETION: blink.cmp (Modern, Fast, Rust-based)
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            -- SNIPPETS: LuaSnip
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                config = function()
                    require("luasnip").setup({ enable_autosnippets = true })
                    require("luasnip.loaders.from_lua").load({ paths = "./snippets" })
                end,
            },
            {
                "Exafunction/codeium.nvim",
                cmd = "Codeium",
                build = ":Codeium Auth",
                opts = {
                    enable_cmp_source = false,
                    virtual_text = {
                        enabled = true,
                    },
                },
            },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            enabled = function()
                local path = vim.api.nvim_buf_get_name(0)
                if string.find(path, "oil://", 1, true) == 1 then
                    return false
                end
                return true
            end,
            keymap = { preset = "enter" },
            snippets = {
                preset = "luasnip",
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer", "codeium" },
                providers = {
                    codeium = { name = "Codeium", module = "codeium.blink", async = true },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            signature = { enabled = true },
            completion = {
                menu = {
                    max_height = 99,
                    auto_show = true,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    window = {
                        max_width = 99,
                        max_height = 99,
                    },
                },
            },
        },
    },
    -- LINTING: nvim-lint
    {
        "mfussenegger/nvim-lint",
        dependencies = {
            {
                "rshkarin/mason-nvim-lint",
                opts = {
                    automatic_installation = true,
                },
            },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                bash = { "shellcheck" },
                sh = { "shellcheck" },
                dockerfile = { "hadolint" },
                make = { "checkmake" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                css = { "stylelint" },
                json = { "jsonlint" },
                python = { "ruff" },
                go = { "golangcilint" },
                kotlin = { "ktlint" },
                yaml = { "yamllint" },
                markdown = { "markdownlint" },
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    -- LSP
    { "mfussenegger/nvim-jdtls" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            require("mason").setup()
            require("mason-lspconfig").setup({
                automatic_enable = {
                    exclude = {
                        "jdtls",
                    },
                },
                ensure_installed = {
                    "nil_ls",
                    "lua_ls",
                    "ts_ls",
                    "tinymist",
                    "rust_analyzer",
                    "marksman",
                    "glsl_analyzer",
                    "bashls",
                    "gradle_ls",
                    "gopls",
                    "jsonls",
                    "html",
                    "cssls",
                    "pyright",
                    "yamlls",
                    "kotlin_language_server",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },
    -- PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        build = function()
            require("typst-preview").update()
        end,
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰚌",
                        [vim.diagnostic.severity.WARN] = "󱐋",
                        [vim.diagnostic.severity.HINT] = "󰌵",
                        [vim.diagnostic.severity.INFO] = "󰋽",
                    },
                },
            })
            require("tiny-inline-diagnostic").setup({
                preset = "minimal",
            })
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
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
                mode = { "n", "t", "i", "x" },
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
})

-- Settings
local opt = vim.opt
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
opt.shiftwidth = 4
opt.scrolloff = 4
opt.termguicolors = true
opt.signcolumn = "yes"
opt.smartindent = true
opt.wrap = true
opt.updatetime = 50
opt.list = true
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
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Keymaps
local keymap = vim.keymap.set

-- File & Buffer Operations
keymap("n", "<leader>w", "<CMD>write<CR>", { desc = "Save file", silent = true })
keymap("n", "<leader>c", "<CMD>nohlsearch<CR>", { desc = "Clear highlights", silent = true })
keymap("n", "<leader>n", "<CMD>bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<leader>p", "<CMD>bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "<leader>x", "<CMD>bdelete<CR>", { desc = "Close buffer", silent = true })
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard", silent = true })

-- Commenting
keymap("n", "<leader>/", "gcc", { desc = "Toggle Line Comment", remap = true, silent = true })
keymap("v", "<leader>/", "gc", { desc = "Toggle Comment Selection", remap = true, silent = true })
keymap({ "n", "i", "v" }, "<C-_>", "<C-/>", { desc = "Toggle Comment", remap = true, silent = true })

-- Formatting
keymap({ "n", "v" }, "<leader>=", function()
    require("conform").format({ async = true }, function(err)
        if not err then
            local mode = vim.api.nvim_get_mode().mode
            if vim.startswith(string.lower(mode), "v") then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
            end
        end
    end)
end, { desc = "Format code" })

-- Auto Commands
local autocmd = vim.api.nvim_create_autocmd

-- Typst Preview
autocmd("FileType", {
    pattern = "typst",
    callback = function()
        vim.keymap.set("n", "<leader>o", "<CMD>TypstPreviewToggle<CR>", { noremap = true, silent = true })
    end,
})

-- Markdown Preview
autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "<leader>o", "<CMD>MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
    end,
})

-- Highlight Yank
autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Restore cursor position
autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Check for file changes
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

-- LSP Keymaps
autocmd("LspAttach", {
    callback = function(event)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
        end
        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "<leader>r", vim.lsp.buf.rename, "Rename Symbol")

        map("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Next Diagnostic")
        map("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Prev Diagnostic")

        map("n", "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", "Code Actions")
        map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "Go to Definition")
        map("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "Go to Declaration")
        map("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "Go to Implementation")
        map("n", "gr", "<cmd>FzfLua lsp_references<cr>", "Go to References")
        map("n", "gs", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "Go to Symbols")
    end,
})

-- Java
autocmd("FileType", {
    group = vim.api.nvim_create_augroup("jdtls_setup", { clear = true }),
    pattern = "java",
    callback = function()
        -- Determine the root directory for the multi modules project
        local root_dir = vim.fs.root(0, { { ".git/" }, "mvnw", "gradlew" }) or vim.fn.getcwd()
        local jdtls = require("jdtls")

        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = vim.fn.expand("~/.cache/jdtls/") .. project_name

        local lombok_path = "/usr/share/java/lombok/lombok.jar"

        if vim.fn.isdirectory(workspace_dir) == 0 then
            vim.fn.mkdir(workspace_dir, "p")
        end

        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
        end

        map("n", "<A-o>", jdtls.organize_imports, "Organize Imports")

        vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-graalvm-ee"
        vim.env.PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH

        local capabilities = require("blink.cmp").get_lsp_capabilities()

        jdtls.start_or_attach({
            name = "jdtls",
            capabilities = capabilities,
            cmd = {
                "jdtls",
                "-data",
                workspace_dir,
                "--jvm-arg=-javaagent:" .. lombok_path,

                -- JVMCI
                "--jvm-arg=-XX:+UnlockExperimentalVMOptions",
                "--jvm-arg=-XX:+UseJVMCICompiler",

                -- ZGC
                "--jvm-arg=-XX:+UseZGC",
                "--jvm-arg=-XX:+ZGenerational",

                -- Memory
                "--jvm-arg=-Xmx4G",

                -- Tuning
                "--jvm-arg=-XX:ZUncommitDelay=60",
                "--jvm-arg=-XX:ZAllocationSpikeTolerance=5",

                -- Disable AWT
                "--jvm-arg=-Djava.awt.headless=true",

                -- JFR
                "--jvm-arg=-Xrs",
            },
            root_dir = root_dir,
            settings = {
                java = {
                    signatureHelp = { enabled = true },
                    contentProvider = { preferred = "fernflower" },
                    sources = {
                        organizeImports = {
                            starThreshold = 9999,
                            staticStarThreshold = 9999,
                        },
                    },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                        },
                        hashCodeEquals = {
                            useJava7Objects = true,
                        },
                        useBlocks = true,
                    },
                    project = {
                        referencedLibraries = {
                            "**/lib/*.jar",
                        },
                    },
                    configuration = {
                        runtimes = {
                            { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/", default = true },
                            { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk/" },
                        },
                    },
                },
            },
        })

        local jdtls_ui = require("jdtls.ui")
        local fzf = require("fzf-lua")

        function jdtls_ui.pick_many(items, prompt, label_fn)
            local co = coroutine.running()

            if not co then
                print("❌ Error: pick_many must be run in a coroutine")
                return {}
            end

            local choices = {}
            for i, item in ipairs(items) do
                local text = label_fn(item)
                table.insert(choices, string.format("%d|%s", i, text))
            end

            -- 🏳️ 状态标志位：标记是否已经完成选择
            local is_picked = false

            fzf.fzf_exec(choices, {
                prompt = prompt .. "> ",
                fzf_opts = {
                    ["--multi"] = true,
                    ["--delimiter"] = "|",
                    ["--with-nth"] = "2..",
                    -- alt-a toggle all
                    ["--bind"] = "alt-a:select-all",
                },
                actions = {
                    ["default"] = function(selected, opts)
                        -- ⚡ 1. 标记为已选择，阻止 on_close 误判
                        is_picked = true

                        vim.schedule(function()
                            local result = {}
                            if selected then
                                for _, text in ipairs(selected) do
                                    local index_str = text:match("^(%d+)|")
                                    local index = tonumber(index_str)
                                    if index and items[index] then
                                        table.insert(result, items[index])
                                    end
                                end
                            end

                            -- 正常恢复协程
                            if coroutine.status(co) == "suspended" then
                                coroutine.resume(co, result)
                            end
                        end)
                    end,
                },
                winopts = {
                    height = 0.6,
                    width = 0.6,
                    on_close = function()
                        -- ⚡ 2. 延迟 20ms 执行，给 action 一点时间去设置 is_picked
                        vim.defer_fn(function()
                            -- 只有当 is_picked 为 false 时，才认为是取消操作
                            if not is_picked and coroutine.status(co) == "suspended" then
                                -- print("Debug: 检测到窗口关闭且未选择，发送空表取消")
                                coroutine.resume(co, {})
                            end
                        end, 20) -- 20ms 延迟足以解决竞争问题
                    end,
                },
            })

            return coroutine.yield()
        end
    end,
})
