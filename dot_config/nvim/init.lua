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
    -- UI: Indent Guides
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", event = "BufReadPre", opts = {} },
    -- SAME WORD HIGHLIGHT
    { "RRethy/vim-illuminate", event = "BufReadPost" },
    -- EDITOR: Commenting
    { "numToStr/Comment.nvim", lazy = false, opts = {} },
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
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({ "n", "x" }, "<C-up>", function()
                mc.addCursor("k")
            end)
            set({ "n", "x" }, "<C-down>", function()
                mc.addCursor("j")
            end)
            -- Add a cursor and jump to the next word under cursor.
            vim.keymap.set({ "n", "v" }, "<c-n>", function()
                mc.addCursor("*")
            end)

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)
            set("n", "<c-leftdrag>", mc.handleMouseDrag)
            set("n", "<c-leftrelease>", mc.handleMouseRelease)

            -- Disable and enable cursors.
            set({ "n", "x" }, "<c-q>", mc.toggleCursor)

            -- Mappings defined in a keymap layer only apply when there are
            -- multiple cursors. This lets you have overlapping mappings.
            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- Delete the main cursor.
                layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { reverse = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end,
    },
    -- EDITOR: Auto Pairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    -- THEME: Gruvbox
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("gruvbox")
        end,
    },
    -- UI: Smooth Scrolling
    { "karb94/neoscroll.nvim", opts = {} },
    -- UI: Status Line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = { theme = "gruvbox" },
            tabline = { lualine_a = { "buffers" } },
            sections = { lualine_c = { "filename" } },
        },
    },
    -- UI: File Explorer
    {
        "stevearc/oil.nvim",
        main = "oil",
        lazy = false,
        priority = 900,
        opts = {
            delete_to_trash = true,
            view_options = { show_hidden = true },
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
        config = function()
            require("oil").setup({
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
            })
        end,
    },
    -- UI: Fuzzy Finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            "default-wide",
            winopts = {
                height = 0.85,
                width = 0.80,
                preview = {
                    layout = "vertical",
                    vertical = "up:45%",
                    scrollbar = false,
                },
            },
            files = {
                formatter = "path.filename_first",
                fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
            },
            grep = {
                formatter = "path.filename_first",
                rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
            },
            previewers = {
                codeaction = { toggle_behavior = "extend" },
                builtin = {
                    syntax_limit_b = 1024 * 100,
                },
            },
        },
        cmd = "FzfLua",
        config = function()
            require("fzf-lua").setup({
                files = { formatter = "path.filename_first" },
                grep = { formatter = "path.filename_first" },
            })
        end,
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
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    hover = {
                        enabled = true,
                        silent = false,
                        view = nil,
                        opts = {},
                    },
                    signature = {
                        enabled = true,
                        auto_open = {
                            enabled = true,
                            trigger = true,
                            luasnip = true,
                            throttle = 50,
                        },
                        view = nil,
                        opts = {},
                    },
                    message = {
                        enabled = true,
                        view = "notify",
                        opts = {},
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
            })
        end,
    },
    -- Git
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
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
    -- CORE: Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        opts = {
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
                "java",
                "json",
                "groovy",
                "html",
                "css",
                "yaml",
                "toml",
                "nix",
                "kotlin",
                "go",
                "javadoc",
                "regex",
                "markdown_inline",
            },
            sync_install = false,
            auto_install = true,
            indent = { enable = true },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    if lang == "html" then
                        return true
                    end
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
    -- LSP
    { "mfussenegger/nvim-jdtls" },
    -- FORMATTING: Conform
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                nix = { "alejandra" },
                lua = { "stylua" },
                python = { "ruff" },
                java = { "google-java-format" },
                groovy = { "npm-groovy-lint" },
                json = { "jq" },
                ["_"] = { "trim_whitespace" },
            },
            formatters = {
                stylua = {
                    prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
                },
                ["google-java-format"] = {
                    prepend_args = { "--aosp" },
                },
            },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    -- LINTING: nvim-lint
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                -- Shell
                bash = { "shellcheck" },
                sh = { "shellcheck" },
                nix = { "statix" },
                dockerfile = { "hadolint" },
                make = { "checkmake" },

                -- Web
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                vue = { "eslint_d" },
                css = { "stylelint" },
                html = { "tidy" },

                -- Programming Languages
                python = { "ruff" },
                go = { "golangcilint" },
                groovy = { "npm-groovy-lint" },
                kotlin = { "ktlint" },

                -- Documentation
                markdown = { "markdownlint" },
                text = { "vale" },
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- COMPLETION: blink.cmp (Modern, Fast, Rust-based)
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
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
    {
        "neovim/nvim-lspconfig",
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
                    "vale",
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
            require("tiny-inline-diagnostic").setup({
                options = {
                    multilines = { enabled = false },
                    show_source = { enabled = true },
                },
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
})

-- Settings
local opt = vim.opt
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20" -- Keymaps
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
local opts = { noremap = true, silent = true }

keymap("n", "<leader>w", "<CMD>write<CR>", opts)
keymap("n", "<leader>c", "<CMD>nohlsearch<CR>", opts)
keymap("n", "<leader>n", "<CMD>bnext<CR>", opts)
keymap("n", "<leader>p", "<CMD>bprevious<CR>", opts)
keymap("n", "<leader>x", "<CMD>bdelete<CR>", opts)
keymap({ "n", "v" }, "<leader>y", '"+y', opts)
keymap("t", "<C-t>", [[<C-\><C-n>]], opts)

-- Comment
keymap("n", "<leader>/", function()
    vim.api.nvim_feedkeys("gcc", "x", true)
end, { desc = "Toggle Line Comment" })

keymap("v", "<leader>/", function()
    vim.api.nvim_feedkeys("gb", "v", true)
end, { desc = "Toggle Line Comment" })

keymap({ "n", "i", "v" }, "<C-_>", "<C-/>", { remap = true, desc = "Terminal compat for Ctrl+/" })

keymap("", "<leader>=", function()
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

autocmd("BufWritePre", { pattern = "*", command = ":%s/\\s\\+$//e" })

autocmd("FileType", {
    pattern = "typst",
    callback = function()
        vim.keymap.set("n", "<leader>o", "<CMD>TypstPreviewToggle<CR>", { noremap = true, silent = true })
    end,
})
autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "<leader>o", "<CMD>MarkdownPreviewToggle<CR>", { noremap = true, silent = true })
    end,
})

autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    callback = function()
        vim.highlight.on_yank()
    end,
})

autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

autocmd("BufWritePre", {
    callback = function(event)
        if event.match:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

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

        map({ "n", "v" }, "<leader>la", require("fzf-lua").lsp_code_actions, "Code Actions")
        map({ "n", "v" }, "gd", require("fzf-lua").lsp_definitions, "Go to Definition")
        map({ "n", "v" }, "gD", require("fzf-lua").lsp_declarations, "Go to Declaration")
        map({ "n", "v" }, "gi", require("fzf-lua").lsp_implementations, "Go to Implementation")
        map({ "n", "v" }, "gr", require("fzf-lua").lsp_references, "Go to References")
        map("n", "gs", require("fzf-lua").lsp_live_workspace_symbols, "Go to Symbols")
    end,
})

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

        -- vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"
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
                "--jvm-arg=-Xmx8G",

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
    end,
})
