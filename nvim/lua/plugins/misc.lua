return {
	{ "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
	{ "tpope/vim-surround", event = "VeryLazy" },
	{
		"janko-m/vim-test",
		cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
		config = function()
			vim.g["test#python#runner"] = "pytest"
			vim.g["test#go#runner"] = "gotest"
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
