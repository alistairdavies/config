vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = "unnamed"
vim.opt.termguicolors = true
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wildignore = {"*/node_modules/*", "*/static/*", "*/tmp/*", "*/.mypy_cache/*"}

local Plug = vim.fn['plug#']


vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'janko-m/vim-test'
Plug 'muchzill4/doubletrouble'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'folke/trouble.nvim'
Plug 'kyazdani42/nvim-web-devicons'

vim.call('plug#end')



local opts = {noremap=true, silent=true}

vim.api.nvim_set_keymap('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fd', ':Telescope file_browser<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>tt', ':TestFile<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>ts', ':TestSuite<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>m', ':lua vim.lsp.buf.formatting()<CR>")', opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_set_keymap('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader>gh', ':lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<Leader><C-k>', ':lua vim.lsp.buf.signature_help()<CR>', opts)
end

-- Map jk to esc, courtesy of James
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true })

vim.api.nvim_command("colorscheme doubletrouble")

-- janko-m/vimtest
vim.g['test#python#runner'] = 'pytest'

-- Telescope file browser
require("telescope").load_extension "file_browser"

local ok, lspconfig = pcall(require, "lspconfig")

-- C and C++ lsp. brew install llvm
-- lspconfig.clangd.setup{}

-- Python lsp.
  -- pyright: npm install -g pyright
  -- lspconfig.pyright.setup{
  --  on_attach = on_attach,
  --  settings = {
  --    python = {
  --      venvPath = ".venv"
  --    }
  --  }
  --}

  -- jedi: pipx install jedi-language-server
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

lspconfig.jedi_language_server.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- null-ls
local ls = require('null-ls')
ls.setup({
  sources = {
    ls.builtins.diagnostics.mypy,
    ls.builtins.diagnostics.flake8,
    ls.builtins.formatting.black,
    ls.builtins.formatting.isort,
    ls.builtins.formatting.prettier,
  },

})

-- Trouble
require('trouble').setup{}

local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'vsnip' },
  }),
  mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  }
}
