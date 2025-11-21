local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>pp", ':lua require("yacp").yacp()<CR>', { noremap = true })
vim.keymap.set("n", "<Leader>pr", ":Telescope yacp replay<CR>", { noremap = true })

vim.keymap.set("n", "<Leader>t", ":TestFile<CR>", opts)
vim.keymap.set("n", "<Leader>ts", ":TestSuite<CR>", opts)
vim.keymap.set("n", "<Leader>tv", ":TestVisit<CR>", opts)

vim.keymap.set("n", "<Leader>ga", "<cmd>Git add . -p<CR>")
vim.keymap.set("n", "<Leader>gc", "<cmd>Git diff<CR>")
vim.keymap.set("n", "<Leader>gb", "<cmd>Git blame<CR>")

vim.keymap.set("n", "<Leader>d", ":Telescope file_browser<CR>", { noremap = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

vim.keymap.set("n", "<C-p>", "<C-^>", { noremap = true })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

-- Disable arrow keys to enforce hjkl movement
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
