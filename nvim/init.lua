local Plug = vim.fn['plug#']


vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvm'
Plug 'nvim-telescope/telescope.nvim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'janko-m/vim-test'

vim.call('plug#end')


vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>t', ':TestFile<CR>', { noremap = true, silent = true })


vim.opt.ruler = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true


vim.api.nvim_command("colorscheme industry")

-- janko-m/vimtest
vim.g['test#python#runner'] = 'pytest'
