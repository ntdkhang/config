vim.g.mapleader = " "
-- open netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>u", ":UndotreeShow<CR>")


-- Move Block of code 
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


vim.keymap.set("n", "J", "mzJ`z") -- make the cursor when doing J stays the same place
-- center cursor when jumping up down and search
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "gd", "gdzz")


-- greatest remap ever: paste on a selected text and put the selected text to register
vim.keymap.set("x", "<leader>p", "\"_dP")

-- jump to end of line 
vim.keymap.set("i", "<C-a>", "<Esc>A")
-- Ctrl Enter to get new line and move down in insert mode
vim.keymap.set("i", "<C-o>", "<Esc>o")



-- yank / delete to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["*y]])
vim.keymap.set("n", "<leader>Y", [["*Y]])
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])


-- navigate windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")



-- navigate buffers
-- vim.keymap.set("n", "<S-l>", ":bnext<CR>")
-- vim.keymap.set("n", "<S-h>", ":bprevious<CR>")


-- indent and stay in visual mode
vim.keymap.set("v", "}", ">gv")
vim.keymap.set("v", "{", "<gv")


-- search replace all words under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")



vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle nvim tree
