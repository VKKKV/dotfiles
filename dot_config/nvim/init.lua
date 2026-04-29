if vim.loader then
    vim.loader.enable()
end

vim.g.mapleader = " " -- leader key must be set before mappings
vim.opt.signcolumn = "yes:2"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- spaces instead of tabs
vim.opt.ignorecase = true
vim.opt.smartcase = true -- case‑sensitive if uppercase is used
vim.opt.termguicolors = true -- 24‑bit color
vim.opt.colorcolumn = "80,120"
vim.opt.list = true -- show invisible characters (tab, eol, etc.)
vim.opt.splitbelow = true -- horizontal splits open below
vim.opt.splitright = true -- vertical splits open to the right
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.timeoutlen = 200 -- faster response for mapped sequences
vim.opt.shell = "/bin/bash" -- avoids issues with fish or exotic shells

vim.pack.add({
    -- UI & Theme
    "https://github.com/rebelot/kanagawa.nvim",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/RRethy/vim-illuminate",
    "https://github.com/brenoprata10/nvim-highlight-colors",
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/shrynx/line-numbers.nvim",

    -- Navigation & Editing
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/folke/flash.nvim",
    "https://github.com/numToStr/Comment.nvim",
    "https://github.com/chentoast/marks.nvim",

    -- Tools & LSP
    { src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("*") },
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/folke/lazydev.nvim",
    "https://github.com/Exafunction/windsurf.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/toppair/peek.nvim",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/williamboman/mason-lspconfig.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mfussenegger/nvim-jdtls",
    "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    "https://github.com/CRAG666/code_runner.nvim",
    { src = "https://github.com/jake-stewart/multicursor.nvim", version = "1.0" },
})

-- [[ PLUGIN CONFIGS ]]

-- Theme
require("kanagawa").setup({ functionStyle = { italic = true } })
vim.cmd.colorscheme("kanagawa-dragon")

-- UI Components
require("fidget").setup({})
require("line-numbers").setup({})

require("lualine").setup({
    options = {
        theme = "auto",
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
                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    if #clients == 0 then
                        return "No Active Lsp"
                    end
                    local names = {}
                    for _, client in ipairs(clients) do
                        table.insert(names, client.name)
                    end
                    return table.concat(names, ", ")
                end,
            },
        },
        lualine_z = { "location" },
    },
})

require("ibl").setup()
require("nvim-highlight-colors").setup({})

require("nvim-treesitter").install({
    "bash",
    "css",
    "html",
    "javascript",
    "json",
    "python",
    "rust",
    "toml",
    "typescript",
    "yaml",
    "zig",
})

-- File Explorer
require("oil").setup({
    delete_to_trash = true,
    view_options = { show_hidden = true },
    keymaps = { ["q"] = "actions.close" },
    float = {
        max_width = 0.9,
        max_height = 0.9,
        border = "rounded",
        win_options = { winblend = 10 },
    },
    lsp_file_methods = {
        enabled = true,
        timeout_ms = 1000,
        autosave_changes = true,
    },
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
})

-- Fuzzy Finder
require("fzf-lua").setup({
    winopts = {
        height = 0.9527,
        width = 0.666,
        preview = { layout = "vertical", vertical = "up:40%" },
        backdrop = 100,
    },
    files = { formatter = "path.filename_first" },
    grep = { formatter = "path.filename_first" },
})
require("fzf-lua").register_ui_select()

-- Editing Tools
require("flash").setup({ modes = { search = { enabled = true } } })
require("Comment").setup()
require("marks").setup({
    builtin_marks = { "<", ">", "^", "'", '"' },
})
require("multicursor-nvim").setup()

local hl = vim.api.nvim_set_hl
hl(0, "MultiCursorCursor", { link = "Cursor" })
hl(0, "MultiCursorVisual", { link = "Visual" })
hl(0, "MultiCursorSign", { link = "SignColumn" })
hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })

-- LSP & Completion
require("lazydev").setup({
    library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
})

require("codeium").setup({
    enable_cmp_source = false,
    virtual_text = {
        enabled = true,
        key_bindings = { accept = "<c-a>", accept_line = "<c-f>" },
    },
})

require("blink.cmp").setup({
    enabled = function()
        return vim.bo.filetype ~= "oil"
    end,
    keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
        list = { selection = { preselect = true, auto_insert = false } },
        menu = { max_height = 99, auto_show = true },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 50,
            window = { max_width = 99, max_height = 99 },
        },
    },
    snippets = { preset = "luasnip" },
    appearance = { nerd_font_variant = "mono" },
    sources = {
        default = { "lazydev", "snippets", "lsp", "path", "buffer", "codeium" },
        providers = {
            codeium = { name = "Codeium", module = "codeium.blink", async = true },
            lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
        },
    },
    signature = { enabled = true },
})

require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = vim.fn.stdpath("config") .. "/lua/snippets" })

require("conform").setup({
    formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        nix = { "alejandra" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        php = { "phpcbf" },
        java = { "google-java-format" },
        rust = { "rustfmt" },
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        ["_"] = { "trim_whitespace" },
    },
    formatters = {
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" } },
        prettier = {
            prepend_args = function(_, ctx)
                if ctx.filename:find("%.njk$") then
                    return { "--parser", "html" }
                end
                if ctx.filename:find("%.styl$") then
                    return { "--parser", "css" }
                end
                return {}
            end,
        },
    },
})

-- LSP Config
local capabilities = require("blink.cmp").get_lsp_capabilities()
require("mason").setup()
require("mason-lspconfig").setup({
    automatic_enable = { exclude = { "jdtls" } },
    ensure_installed = {
        "clangd",
        "ty",
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
        "yamlls",
    },
    handlers = {
        function(server)
            require("lspconfig")[server].setup({ capabilities = capabilities })
        end,
        ["rust_analyzer"] = function()
            require("lspconfig").rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        inlayHints = {
                            bindingModeHints = { enable = false },
                            chainingHints = { enable = true },
                            closingBraceHints = { enable = true, minLines = 25 },
                            closureReturnTypeHints = { enable = "always" },
                            lifetimeElisionHints = { enable = "always", useParameterNames = true },
                            maxLength = 25,
                            parameterHints = { enable = true },
                            reborrowHints = { enable = "always" },
                            renderColons = true,
                            typeHints = { enable = true },
                        },
                    },
                },
            })
        end,
    },
})

vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
})
require("tiny-inline-diagnostic").setup({ preset = "minimal" })

-- Tools
-- deno task --quiet build:fast
require("peek").setup({ app = "browser" })

vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})

require("code_runner").setup({
    mode = "term",
    focus = true,
    startinsert = true,
    term = { position = "bot", size = 40 },
    filetype = {
        c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        python = "python -u",
        sh = "bash",
        rust = "cargo run",
    },
})

-- [[ BUILT-IN LSP & ENV ]]
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

-- Java / jdtls
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("jdtls_setup", { clear = true }),
    pattern = "java",
    callback = function()
        local root_dir = vim.fs.root(0, { { "wtf", ".git/" }, "mvnw", "gradlew" }) or vim.fn.getcwd()
        local jdtls = require("jdtls")
        local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
        local workspace_dir = vim.fn.expand("~/.cache/jdtls/") .. project_name
        local lombok_path = "/usr/share/java/lombok/lombok.jar"

        if vim.fn.isdirectory(workspace_dir) == 0 then
            vim.fn.mkdir(workspace_dir, "p")
        end

        vim.keymap.set("n", "<A-o>", jdtls.organize_imports, { buffer = true, desc = "Organize Imports" })

        vim.env.JAVA_HOME = "/usr/lib/jvm/java-21-graalvm-ee"
        vim.env.PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH

        jdtls.start_or_attach({
            name = "jdtls",
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            cmd = {
                "jdtls",
                "-data",
                workspace_dir,
                "--jvm-arg=-javaagent:" .. lombok_path,
                "--jvm-arg=-XX:+UnlockExperimentalVMOptions",
                "--jvm-arg=-XX:+UseJVMCICompiler",
                "--jvm-arg=-XX:+UseZGC",
                "--jvm-arg=-XX:+ZGenerational",
                "--jvm-arg=-Xmx4G",
                "--jvm-arg=-XX:ZUncommitDelay=60",
                "--jvm-arg=-XX:ZAllocationSpikeTolerance=5",
                "--jvm-arg=-Djava.awt.headless=true",
                "--jvm-arg=-Xrs",
            },
            root_dir = root_dir,
            settings = {
                java = {
                    inlayHints = { parameterNames = { enabled = "all" } },
                    signatureHelp = { enabled = true },
                    contentProvider = { preferred = "fernflower" },
                    sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
                    codeGeneration = {
                        toString = {
                            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                        },
                        hashCodeEquals = { useJava7Objects = true },
                        useBlocks = true,
                    },
                    project = { referencedLibraries = { "**/lib/*.jar" } },
                    configuration = {
                        runtimes = {
                            { name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/", default = true },
                            { name = "JavaSE-21", path = "/usr/lib/jvm/java-21-openjdk/" },
                        },
                    },
                },
            },
        })

        -- Override pick_many to use fzf-lua
        local jdtls_ui = require("jdtls.ui")
        local fzf = require("fzf-lua")
        function jdtls_ui.pick_many(items, prompt, label_fn)
            local co = coroutine.running()
            if not co then
                return {}
            end
            local choices = {}
            for i, item in ipairs(items) do
                table.insert(choices, string.format("%d|%s", i, label_fn(item)))
            end

            local is_picked = false
            fzf.fzf_exec(choices, {
                prompt = prompt .. "> ",
                fzf_opts = {
                    ["--multi"] = true,
                    ["--delimiter"] = "|",
                    ["--with-nth"] = "2..",
                    ["--bind"] = "alt-a:select-all",
                },
                actions = {
                    ["default"] = function(selected)
                        is_picked = true
                        vim.schedule(function()
                            local result = {}
                            if selected then
                                for _, text in ipairs(selected) do
                                    local idx = tonumber(text:match("^(%d+)|"))
                                    if idx then
                                        table.insert(result, items[idx])
                                    end
                                end
                            end
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
                        vim.defer_fn(function()
                            if not is_picked and coroutine.status(co) == "suspended" then
                                coroutine.resume(co, {})
                            end
                        end, 20)
                    end,
                },
            })
            return coroutine.yield()
        end
    end,
})

-- [[ KEYMAPS & AUTO ]]
local map = vim.keymap.set

-- Multicursor
local mc = require("multicursor-nvim")
map({ "n", "x" }, "<C-up>", function()
    mc.lineAddCursor(-1)
end, { desc = "Add cursor up" })
map({ "n", "x" }, "<C-down>", function()
    mc.lineAddCursor(1)
end, { desc = "Add cursor down" })
map({ "n", "x" }, "<C-n>", function()
    mc.matchAddCursor(1)
end, { desc = "Add cursor next match" })
map({ "n", "x" }, "<leader>s", function()
    mc.matchSkipCursor(1)
end, { desc = "Skip cursor next match" })
map({ "n", "x" }, "<leader>S", function()
    mc.matchSkipCursor(-1)
end, { desc = "Skip cursor previous match" })
map({ "n", "x" }, "<leader>a", function()
    mc.matchAllAddCursors()
end, { desc = "Add all matches" })
map("n", "<esc>", function()
    if not mc.cursorsEnabled() then
        mc.enableCursors()
        return ""
    elseif mc.hasCursors() then
        mc.clearCursors()
        return ""
    else
        return "<esc>"
    end
end, { desc = "Clear/Enable cursors", expr = true })

-- Flash
map({ "n", "x", "o" }, "s", function()
    require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "S", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
    require("flash").remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

-- General
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>e", function()
    require("oil").toggle_float()
end, { desc = "Oil" })
map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Fzf Files" })
map("n", "<leader>fr", "<cmd>FzfLua live_grep<cr>", { desc = "Fzf Live Grep" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Fzf Buffers" })
map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", { desc = "Fzf Keymaps" })
map("n", "<leader>fm", "<cmd>FzfLua marks<cr>", { desc = "Fzf Marks" })
map("n", "<leader>n", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>p", "<cmd>bprev<cr>", { desc = "Prev Buffer" })
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "Delete Buffer" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map({ "n", "v" }, "<leader>=", function()
    require("conform").format({ lsp_fallback = true })
end, { desc = "Format" })
map("n", "<leader>/", "gcc", { remap = true, desc = "Comment" })
map("v", "<leader>/", "gc`]", { remap = true, desc = "Comment Selection" })
map("v", "<leader>y", '"+y', { desc = "Yank to Clipboard" })
map("n", "<leader>o", ":RunCode<CR>", { desc = "Run Code" })

-- Autocmds
local au = vim.api.nvim_create_autocmd
local group = vim.api.nvim_create_augroup("ConfigGroup", { clear = true })

au("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

au("BufReadPost", {
    group = group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

au({ "FocusGained", "BufEnter", "CursorHold" }, {
    group = group,
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

vim.on_key(function(char)
    if vim.fn.mode() == "n" then
        vim.cmd.nohlsearch()
    end
end, vim.api.nvim_create_namespace("auto_nohl"))

au("LspAttach", {
    group = group,
    callback = function(ev)
        local bmap = function(m, l, r, d)
            map(m, l, r, { buffer = ev.buf, desc = d })
        end
        bmap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "Definition")
        bmap("n", "gr", "<cmd>FzfLua lsp_references<cr>", "References")
        bmap("n", "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", "Symbols")
        bmap("n", "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", "Action")
        bmap("n", "<leader>ld", "<cmd>FzfLua diagnostics_document<cr>", "Diagnostics")
        bmap("n", "K", vim.lsp.buf.hover, "Hover")
        bmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    end,
})

au("FileType", {
    pattern = { "yaml", "yml", "json" },
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
    end,
})

vim.filetype.add({
    extension = {
        njk = "html",
        styl = "css",
    },
})
