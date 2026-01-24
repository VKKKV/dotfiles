-- Keymaps
local keymap = vim.keymap.set

-- File & Buffer Operations
keymap("n", "<leader>n", "<CMD>bnext<CR>", { desc = "Next buffer", silent = true })
keymap("n", "<leader>p", "<CMD>bprevious<CR>", { desc = "Previous buffer", silent = true })
keymap("n", "<leader>x", "<CMD>bdelete<CR>", { desc = "Close buffer", silent = true })
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard", silent = true })
keymap('n', '<Leader><Tab>', '<C-^>', { noremap = true, silent = true, desc = 'Switch to last buffer' })

-- Commenting
keymap("n", "<leader>/", "gcc", { desc = "Toggle Line Comment", remap = true, silent = true })
keymap("v", "<leader>/", "gc", { desc = "Toggle Comment Selection", remap = true, silent = true })

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
