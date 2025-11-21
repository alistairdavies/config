return {
	{ "numToStr/Comment.nvim", opts = {} },
	"tpope/vim-surround",
	"tpope/vim-fugitive",
	{
		"janko-m/vim-test",
		config = function()
			vim.g["test#python#runner"] = "pytest"
			vim.g["test#go#runner"] = "richgo"
			vim.g["test#strategy"] = "neovim"
		end,
	},
	{
		"github/copilot.vim",
		event = "InsertEnter",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
		end,
	},
}
