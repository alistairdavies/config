vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.hlsearch = false 
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
vim.opt.updatetime = 50
vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.opt.wildignore = {"*/node_modules/*", "*/static/*", "*/tmp/*", "*/.mypy_cache/*"}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

plugins = {
  'neovim/nvim-lspconfig',
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-context',
  'nvim-treesitter/nvim-treesitter-textobjects',
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'muchzill4/telescope-yacp.nvim',
  'Vimjas/vim-python-pep8-indent',
  'janko-m/vim-test',
  'muchzill4/doubletrouble',
  'pappasam/papercolor-theme-slim',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-nvim-lsp-signature-help',
  'jose-elias-alvarez/null-ls.nvim',
  'folke/trouble.nvim',
  'kyazdani42/nvim-web-devicons',
  'dcampos/nvim-snippy',
  'dcampos/cmp-snippy',
  'tpope/vim-fugitive',
}
require("lazy").setup(plugins, opts)


function format()
  vim.lsp.buf.format {async = true}
end

local opts = {noremap=true, silent=true}

vim.keymap.set('n', '<Leader>ff', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fg', ':Telescope live_grep<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fb', ':Telescope buffers<CR>', { noremap = true })
vim.keymap.set('n', '<leader>fu', ':Telescope resume<CR>', { noremap = true})
vim.keymap.set('n', '<Leader>fd', ':Telescope file_browser<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>fh', ':Telescope help_tags<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>pp', ':lua require("yacp").yacp()<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>pr', ':Telescope yacp replay<CR>', { noremap = true })
vim.keymap.set('n', '<Leader>tt', ':TestFile<CR>', opts)
vim.keymap.set('n', '<Leader>ts', ':TestSuite<CR>', opts)
vim.keymap.set('n', '<Leader>tv', ':TestVisit<CR>', opts)
vim.keymap.set('n', '<Leader>m', ':lua format()<CR>")', opts)
vim.keymap.set('n', '<Leader>ww', ':TroubleToggle document_diagnostics<CR>', opts)
vim.keymap.set('n', '<Leader>o', ':Project<space>', { noremap = true})
vim.keymap.set('n', '<Leader>ga', '<cmd>Git add . -p<CR>')
vim.keymap.set('n', '<Leader>gc', '<cmd>Git diff<CR>')
vim.keymap.set('n', '<Leader>gb', '<cmd>Git blame<CR>')
vim.keymap.set('n', '<Leader>gg', '<cmd>Git <CR>')
vim.keymap.set('n', '<Leader>s', ':w<CR>', { noremap = true })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('n', '<C-p>', '<C-^>', { noremap = true })
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')


vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

local on_attach = function(client, bufnr)
  vim.keymap.set('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set('n', '<Leader>gh', ':lua vim.lsp.buf.hover()<CR>', opts)
end


-- Color Scheme
vim.api.nvim_command("colorscheme doubletrouble")  
-- vim.api.nvim_command("colorscheme PaperColorSlim")  

vim.api.nvim_create_user_command(
    'Project',
    function(opts)
      vim.api.nvim_command(string.format("lcd `z -e %s`", opts.args))
    end, 
    { nargs = 1, complete="dir"}
)


-- janko-m/vimtest
vim.g['test#python#runner'] = 'pytest'
vim.g['test#go#runner'] = 'richgo'
vim.g['test#strategy'] = 'neovim'


-- Telescope file browser
local telescope = require("telescope")
telescope.load_extension "file_browser"

-- Command Line Palette
require("yacp").setup {
  provider = "telescope", -- or "fzf"
  palette = {
    { name = "help", cmd = "Telescope help_tags" },
     { name = "set working dir to current file", cmd = ":cd %:p:h" },
     { name = "clear buffers", cmd = ":%bd|edit#|bd#"},
     { name = "new tab", cmd = ":tabnew"},
     { name = "open files with conflicts", cmd = "args `git diff --name-only --diff-filter=U`"},
     { name = "mypy", cmd = "sp | term pipenv run python -m mypy ."},
     { name = "pre-commit", cmd = "sp | term pre-commit run --all-files"},
     { name = "golangci lint", cmd = "sp | term golangci-lint run --fix"},
     { name = "git commit", cmd = ":Git commit"},
     { name = "git push", cmd = ":Git push origin head"},
  },
}


telescope.setup{}

local ok, lspconfig = pcall(require, "lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'typescript', 'rust', 'python', 'yaml', 'markdown', 'lua', 'go'},
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "v",
      node_incremental = "v",
      node_decremental = "V",
    },
  },
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}


local context = require "treesitter-context"
if context then
  context.setup {
    max_lines = 1,
    trim_scope = "inner",
    mode = "topline",
  }
end


-- Python - pyright (npm install -g pyright)
lspconfig.pyright.setup{
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      venvPath = ".venv",
      analysis = {
        -- mypy does the type checking
        typeCheckingMode = "off"
      }
    },
  }
}

-- CSS - cssls (npm i -g vscode-langservers-extracted)
-- Go - gopls (go install golang.org/x/tools/gopls@latest)
-- Protobuf - bufls (go install go install github.com/bufbuild/buf-language-server/cmd/bufls@latest)
-- Typescript - tsserver - (npm install -g typescript typescript-language-server)
-- Rust - rust_analyzer (brew install rust-analyzer)
-- TailwindCss - (npm install -g @tailwindcss/language-server)

local servers = {'cssls', 'gopls', 'tsserver', 'rust_analyzer', 'bufls', 'tailwindcss'}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end


-- null-ls
local ls = require('null-ls')
ls.setup({
  sources = {
    ls.builtins.diagnostics.mypy,
    ls.builtins.formatting.black,
    ls.builtins.diagnostics.ruff,
    ls.builtins.formatting.ruff,
    ls.builtins.formatting.prettier,
    ls.builtins.diagnostics.golangci_lint,
    ls.builtins.diagnostics.write_good
  },
})

-- Snippy
local snippy = require('snippy')
snippy.setup({
    mappings = {
        is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
        },
        nx = {
            ['<leader>x'] = 'cut_text',
        },
    },
})

-- Trouble
require('trouble').setup{}

local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'snippy' },
    { name = 'nvim_lsp_signature_help' },
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
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snippy.can_expand_or_advance() then
        snippy.expand_or_advance()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snippy.can_jump(-1) then
        snippy.previous()
      else
        fallback()
      end
    end, { "i", "s" }),
  }
}
