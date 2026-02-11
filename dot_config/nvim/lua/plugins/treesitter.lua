return {
    -- CORE: Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            { "nvim-treesitter/nvim-treesitter-context", config = true },
        },
        opts = {
            ensure_installed = { "all" },
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
}
