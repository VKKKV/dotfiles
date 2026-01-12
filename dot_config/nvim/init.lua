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
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
    -- THEME: Gruvbox
    { "ellisonleao/gruvbox.nvim", priority = 1000, config = function() vim.cmd.colorscheme("gruvbox") end},
    { "karb94/neoscroll.nvim", opts = {}, },
    -- UI: Status Line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = { theme = "gruvbox" },
            tabline = { lualine_a = { "buffers" } },
            sections = {
                lualine_c = { { "filename" } },
            },
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
        keys = { { "<leader>e",function() require("oil").toggle_float() end, desc = "Open File Explorer" } },
        config =function()
            -- Declare a global function to retrieve the current directory
            function _G.get_oil_winbar()
                local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
                local dir = require("oil").get_current_dir(bufnr)
                if dir then
                    return vim.fn.fnamemodify(dir, ":~")
                else
                    -- If there is no current directory (e.g. over ssh), just show the buffer name
                    return vim.api.nvim_buf_get_name(0)
                end
            end
            require("oil").setup({
                float = {
                    padding = 2,
                    max_width = 0.8,
                    max_height = 0.8,
                    border = "rounded",
                    win_options = {
                        winblend = 10,
                    },
                },
                win_options = {
                    winbar = "%!v:lua.get_oil_winbar()",
                },
                default_file_explorer = true,
                columns = {
                    "icon",
                    "permissions",
                    "size",
                    "mtime",
                },
                skip_confirm_for_simple_edits = true,
            })
        end,
    },
    -- UI: Fuzzy Finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
            { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "Fzf Oldfiles" },
            { "<leader>fz", "<cmd>FzfLua zoxide<cr>", desc = "Fzf Zoxide" },
            -- LSP Mappings
            { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Go to Definition" },
            { "gi", "<cmd>FzfLua lsp_implementations<cr>", desc = "Go to Implementation" },
            { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "Go to References" },
            { "gs", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Go to Symbols" },
        },
    },
    -- UI ENHANCE
    -- useless but coollll
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        init = function ()
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
                presets = {
                    bottom_search = false,
                    command_palette = true,
                    long_message_to_split = true,
                    lsp_doc_border = true,
                },
                views = {
                    cmdline_popup = {
                        position = {
                            row = "40%",
                            col = "50%",
                        },
                        size = {
                            width = 60,
                            height = "auto",
                        },
                    },
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
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
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
            ensure_installed = { "bash", "c", "javascript", "lua", "markdown", "python", "rust", "typescript", "typst", "vim", "vue", "glsl", "java", "json", "groovy", "html", "css", "yaml", "toml", "nix", "kotlin", "go", "javadoc", "regex", "markdown_inline", },
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
    -- DOCS: Documentation generation
    { "danymat/neogen", config = true, },
    -- LSP
    { "mfussenegger/nvim-jdtls" },
    -- Gradle Support
    {
        "oclay1st/gradle.nvim",
        cmd = { "Gradle", "GradleExec", "GradleInit", "GradleFavorites" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim"
        },
        opts = {},
        keys = {
            { '<leader>g', '<cmd>Gradle<cr>', desc = 'Gradle Projects' },
        },
    },
    -- FORMATTING: Conform
    {
        "stevearc/conform.nvim",
        init = function ()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    nix = { "alejandra" },
                    lua = { "mylua" },
                    python = { "ruff" },
                    java = { "myjava" },
                    groovy = { "npm-groovy-lint" },
                    json = { "jq" },
                    ["_"] = { "trim_whitespace" },
                },
                formatters = {
                    mylua = {
                        command = vim.fn.stdpath("data") .. "/mason/bin/stylua",
                        args = { "--indent-type", "Spaces", "--indent-width", "4", "-" },
                    },
                    myjava = {
                        command = vim.fn.stdpath("data") .. "/mason/bin/google-java-format",
                        args = { "--aosp", "-" },
                    },
                },
            })
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
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                vue = { "eslint_d" },
                css = { "stylelint" },
                html = { "tidy" },

                -- Programming Languages
                python = { "ruff" },
                go = { "golangcilint" },
                lua = { "luacheck" },
                groovy = { "npm-groovy-lint" },
                kotlin = { "ktlint" },

                -- Documentation
                markdown = { "markdownlint" },
                text = { "vale" },
                typst = { "vale" },
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
    -- COMPLETION: blink.cmp (Modern, Fast, Rust-based)
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = { preset = "enter" },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            signature = { enabled = true },
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
                ensure_installed = { "nil_ls", "lua_ls", "lua", "ts_ls", "tinymist", "rust_analyzer", "marksman", "glsl_analyzer", "bashls", "gradle_ls", "gopls", "jsonls", "html", "cssls", "pyright", "yamlls", "kotlin_language_server", },
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
    -- Signature Help
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = { },
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
    -- SNIPPETS: LuaSnip
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        build = "make install_jsregexp",
        config = function()
            require("luasnip").setup({ enable_autosnippets = true })
            require("luasnip.loaders.from_lua").load({ paths = "./snippets" })
        end,
    },
    -- Trouble
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = "Trouble",
        keys = {
            { "<leader>ld", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project Diagnostics" },
            { "<leader>ls", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
            { "<leader>lq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List" },
        },
        opts = {
            focus = true,
            modes = {
                symbols = { win = { position = "right", size = 0.3, }, },
                lsp = { win = { position = "right", size = 0.3, }, },
            },
        }
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                options = {
                    multilines = { enabled = false, },
                    show_source = { enabled = true },
                },
            })
            vim.diagnostic.config({ virtual_text = false })
        end,
    },
    -- PREVIEW
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
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
            { "<leader>ao", function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end, desc = "Sidekick Toggle opencode" },
            { "<leader>ag", function() require("sidekick.cli").toggle({ name = "gemini", focus = true }) end, desc = "Sidekick Toggle gemini" },
            { "<leader>as", function() require("sidekick.cli").select() end, desc = "Select CLI" },
            { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, mode = { "x", "n" }, desc = "Send This" },
            { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send File" },
            { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = { "x" }, desc = "Send Visual Selection" },
            { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Sidekick Select Prompt" },
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
opt.undodir = vim.fn.stdpath("state") .. "/undo"

opt.foldopen = "mark,percent,quickfix,search,tag,undo"

-- Keymaps
local keymap = vim.keymap.set
keymap("n", "<leader>w", "<CMD>write<CR>", { silent = true })
keymap("n", "<leader>q", "<CMD>q<CR>")
keymap("n", "<C-L>", "<CMD>nohlsearch<CR>")

keymap("n", "<leader>n", "<CMD>bn<CR>")
keymap("n", "<leader>p", "<CMD>bp<CR>")
keymap("n", "<leader>x", "<CMD>bd<CR>")

keymap('n', '<leader>c', "<CMD>%bd|e#|bd#<CR>", { desc = 'Close all buffers except current' })

-- System clipboard
keymap({ "n", "v" }, "<leader>y", '"+y')

-- Comment
-- Use Ctrl+/ to toggle comments in normal and visual mode
keymap("n", "<C-_>", function() vim.api.nvim_feedkeys("gcc", "x", true) end, { desc = "Toggle Line Comment" })
keymap("v", "<C-_>", function() vim.api.nvim_feedkeys("gb", "v", true) end, { desc = "Toggle Line Comment" })

keymap('t', '<C-t>', [[<C-\><C-n>]])

-- Auto Commands
local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", { pattern = "*", command = ":%s/\\s\\+$//e", })

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

autocmd("TermOpen", {
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
    end,
})

autocmd("VimResized", {
    callback = function()
        local current_tab = vim.api.nvim_get_current_tabpage()
        vim.cmd("tabdo wincmd =")
        vim.api.nvim_set_current_tabpage(current_tab)
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
        local opts = { buffer = event.buf }
        vim.keymap.set({ "n", "i" }, "<C-k>", function() require("lsp_signature").toggle_float_win() end, { silent = true, noremap = true, desc = "toggle signature" })
        vim.keymap.set("", "<leader>=", function()
            require("conform").format({ async = true }, function(err)
                if not err then
                    local mode = vim.api.nvim_get_mode().mode
                    if vim.startswith(string.lower(mode), "v") then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                    end
                end
            end)
        end, { desc = "Format code" })

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, opts)

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "g]", '<cmd>lua vim.diagnostic.jump({count=1, float=true})<cr>', opts)
        vim.keymap.set("n", "g[", '<cmd>lua vim.diagnostic.jump({count=-1, float=true})<cr>', opts)

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == "jdtls" then
            vim.keymap.set("n", "<A-o>", function() require('jdtls').organize_imports() end, opts)
            vim.keymap.set("n", "crv", function() require('jdtls').extract_variable() end, opts)
            vim.keymap.set("v", "crv", [[<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>]], opts)
            vim.keymap.set("n", "crc", function() require('jdtls').extract_constant() end, opts)
            vim.keymap.set("v", "crc", [[<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>]], opts)
            vim.keymap.set("v", "crm", [[<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>]], opts)
        end
    end,
})

autocmd("FileType", {
    group = vim.api.nvim_create_augroup("jdtls_setup", { clear = true }),
    pattern = "java",
    callback = function()
        -- Determine the root directory for the multi modules project
        local root_dir = vim.fs.root(0, { { ".git/" }, "mvnw", "gradlew" }) or vim.fn.getcwd()

        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = vim.fn.expand("~/.cache/jdtls/") .. project_name

        if vim.fn.isdirectory(workspace_dir) == 0 then
            vim.fn.mkdir(workspace_dir, "p")
        end

        local lombok_path = "/usr/share/java/lombok/lombok.jar"
        vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-openjdk"
        vim.env.PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH

        require("jdtls").start_or_attach({
            name = "jdtls",
            cmd = {
                "jdtls", "-data", workspace_dir,
                "--jvm-arg=-javaagent:" .. lombok_path,
                "--jvm-arg=-Xmx2G",
            },
            root_dir = root_dir,
            settings = {
                java = {
                    configuration = {
                        runtimes = {
                            { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/", default = true, },
                            { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk/", }
                        },
                    },
                },
            },
        })
    end,
})
