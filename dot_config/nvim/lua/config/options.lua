-- Settings
local opt = vim.opt
opt.timeoutlen = 200
opt.ttimeoutlen=0
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
opt.shiftwidth = 4
opt.scrolloff = 4
opt.termguicolors = true
opt.smartindent = true
opt.wrap = true
opt.updatetime = 50
opt.list = true
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
opt.shell = "/bin/bash"
-- opt.conceallevel = 0
-- opt.cursorline = true

vim.g.markdown_syntax_conceal = 0
-- Markdown Codeblocks Syntax Highlight
vim.g.markdown_fenced_languages = {
    "ts=typescript",
    "js=javascript",
    "bash",
    "sh=bash",
    "lua",
    "python",
    "c",
    "rust",
    "go",
    "json",
    "yaml"
}
