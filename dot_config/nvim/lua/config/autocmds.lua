-- Auto Commands
local autocmd = vim.api.nvim_create_autocmd

local auto_save_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })
local save_timer = nil
local delay = 1145.14

-- Auto Save
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
    group = auto_save_group,
    pattern = "*",
    callback = function()
        if save_timer then
            vim.uv.timer_stop(save_timer)
        end

        save_timer = vim.uv.new_timer()
        vim.uv.timer_start(
            save_timer,
            delay,
            0,
            vim.schedule_wrap(function()
                if vim.bo.modified and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
                    vim.cmd("silent! write")
                end
                save_timer = nil
            end)
        )
    end,
})

-- Auto Highlight
autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("auto-hlsearch", { clear = true }),
    callback = function()
        if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
            vim.schedule(function()
                vim.cmd.nohlsearch()
            end)
        end
    end,
})

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

        map("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
        end, "Next Diagnostic")
        map("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
        end, "Prev Diagnostic")

        map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        map("n", "<leader>r", vim.lsp.buf.rename, "Rename Symbol")
        map("n", "<leader>la", "<cmd>FzfLua lsp_code_actions<cr>", "Code Actions")
        map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", "Go to Definition")
        map("n", "gD", "<cmd>FzfLua lsp_declarations<cr>", "Go to Declaration")
        map("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", "Go to Implementation")
        map("n", "gr", "<cmd>FzfLua lsp_references<cr>", "Go to References")
        map("n", "gs", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "Go to Symbols")

        -- Inlay hints
        map("n", "<leader>li", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, "Inlay Hints")
    end,
})

-- Java
-- Are you sure? Why not use IntelliJ?
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
                    inlayHints = { parameterNames = { enabled = "all" } },
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

        -- Override pick_many to use fzf-lua for multi-selection
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
                    ["default"] = function(selected, _)
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
                        -- Defer execution to allow the default action to set is_picked first
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
