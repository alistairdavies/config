vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.breakindent = true
vim.opt.background = "light"
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.inccommand = "split"
vim.opt.cursorline = true

vim.opt.wildignore = { "*/node_modules/*", "*/static/*", "*/tmp/*", "*/.mypy_cache/*" }

vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<Nop>")

vim.diagnostic.config({ virtual_text = true })
