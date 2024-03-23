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
vim.opt.background = "dark"
vim.opt.scrolloff = 8
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.keymap.set("n", "<Space>", "<Nop>")
vim.g.mapleader = " "

vim.opt.wildignore = { "*/node_modules/*", "*/static/*", "*/tmp/*", "*/.mypy_cache/*" }

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
	"neovim/nvim-lspconfig",
	{ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"typescript",
				"rust",
				"python",
				"yaml",
				"markdown",
				"lua",
				"go",
				"html",
				"vim",
				"vimdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "v",
					node_incremental = "v",
					node_decremental = "V",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			max_lines = 1,
			trim_scope = "inner",
			mode = "topline",
		},
	},
	"nvim-treesitter/nvim-treesitter-textobjects",
	"nvim-lua/plenary.nvim",
	"Vimjas/vim-python-pep8-indent",
	"janko-m/vim-test",
	{
		"muchzill4/doubletrouble",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("doubletrouble")
		end,
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	"nvim-tree/nvim-web-devicons",
	"tpope/vim-fugitive",
	{ "nvimdev/guard.nvim", dependencies = { "nvimdev/guard-collection" } },
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			{
				"muchzill4/telescope-yacp.nvim",
				opts = {
					provider = "telescope", -- or "fzf"
					palette = {
						{ name = "help", cmd = "Telescope help_tags" },
						{ name = "set working dir to current file", cmd = ":cd %:p:h" },
						{ name = "clear buffers", cmd = ":%bd|edit#|bd#" },
						{ name = "new tab", cmd = ":tabnew" },
						{
							name = "open files with conflicts",
							cmd = "args `git diff --name-only --diff-filter=U`",
						},
						{ name = "mypy", cmd = "sp | term pipenv run python -m mypy ." },
						{ name = "pre-commit", cmd = "sp | term pre-commit run --all-files" },
						{ name = "golangci lint", cmd = "sp | term golangci-lint run --fix" },
						{ name = "npm lint", cmd = "sp | term npm run lint-fix" },
						{ name = "git commit", cmd = ":Git commit" },
						{ name = "git push", cmd = ":Git push origin head" },
					},
				},
			},
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = true },
		},
		config = function()
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?

			require("telescope").setup({
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					["file-browser"] = {
						display_stat = { date = true },
						hidden = { file_browser = true, folder_browser = true },
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "file-browser")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			local extensions = require("telescope").extensions
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",

		opts = {
			notify_on_error = false,
			format_on_save = true,
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black", "ruff_fix", "ruff_format" },
				rust = { "rustfmt" },
				javascript = { "prettier" },
				["_"] = { "trim_whitespace" },
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",

		dependencies = {
			"dcampos/nvim-snippy",
			"dcampos/cmp-snippy",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		config = function()
			local cmp = require("cmp")
			local snippy = require("snippy")
			snippy.setup({
				mappings = {
					is = {
						["<Tab>"] = "expand_or_advance",
						["<S-Tab>"] = "previous",
					},
					nx = {
						["<leader>x"] = "cut_text",
					},
				},
			})
			cmp.setup({
				snippet = {
					expand = function(args)
						snippy.expand_snippet(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),

					["<C-Space>"] = cmp.mapping.complete({}),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "snippy" },
					{ name = "path" },
					{ name = "nvim_lsp_signature_help" },
				},
			})
		end,
	},

	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- gopls = {},
				cssls = {},
				tsserver = {},
				rust_analyzer = {},
				tailwindcss = {},
				pyright = {
					settings = {
						python = {
							venvPath = ".venv",
							analysis = {
								typeCheckingMode = "basic",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"black",
				"ruff",
				"rustfmt",
				"prettier",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}

require("lazy").setup(plugins, opts)

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Leader>pp", ':lua require("yacp").yacp()<CR>', { noremap = true })
vim.keymap.set("n", "<Leader>pr", ":Telescope yacp replay<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>t", ":TestFile<CR>", opts)
vim.keymap.set("n", "<Leader>ts", ":TestSuite<CR>", opts)
vim.keymap.set("n", "<Leader>tv", ":TestVisit<CR>", opts)
vim.keymap.set("n", "<Leader>ga", "<cmd>Git add . -p<CR>")
vim.keymap.set("n", "<Leader>gc", "<cmd>Git diff<CR>")
vim.keymap.set("n", "<Leader>gb", "<cmd>Git blame<CR>")
vim.keymap.set("n", "<Leader>s", ":w<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>d", ":Telescope file_browser<CR>", { noremap = true })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("n", "<C-p>", "<C-^>", { noremap = true })
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })

vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- janko-m/vimtest
vim.g["test#python#runner"] = "pytest"
vim.g["test#go#runner"] = "richgo"
vim.g["test#strategy"] = "neovim"
