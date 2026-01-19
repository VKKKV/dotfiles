return {
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
}
