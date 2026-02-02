return {
    -- THEME: Kanagawa Dragon
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                functionStyle = { italic = true },
                variablebuiltinStyle = { italic = true },
            })
            vim.cmd("colorscheme kanagawa-dragon")
            -- vim.cmd("colorscheme kanagawa-wave")
            -- vim.cmd("colorscheme kanagawa-lotus")
        end,
    },
}
