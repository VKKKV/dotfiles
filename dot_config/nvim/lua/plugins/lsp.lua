return {
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
                    exclude = { "jdtls" },
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

                    ["rust_analyzer"] = function()
                        require("lspconfig").rust_analyzer.setup({
                            capabilities = capabilities,
                            settings = {
                                ["rust-analyzer"] = {
                                    inlayHints = {
                                        bindingModeHints = { enable = false },
                                        chainingHints = { enable = true }, -- 链式调用提示
                                        closingBraceHints = { enable = true, minLines = 25 }, -- 大括号跨度大时提示是哪个块结束
                                        closureReturnTypeHints = { enable = "always" }, -- 闭包返回类型
                                        lifetimeElisionHints = { enable = "always", useParameterNames = true },
                                        maxLength = 25,
                                        parameterHints = { enable = true }, -- 参数名提示
                                        reborrowHints = { enable = "always" },
                                        renderColons = true,
                                        typeHints = {
                                            enable = true,
                                            hideClosureInitialization = false,
                                            hideNamedConstructor = false,
                                        },
                                    },
                                },
                            },
                        })
                    end,
                },
            })
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
}
