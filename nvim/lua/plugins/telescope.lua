return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
		{
			"muchzill4/telescope-yacp.nvim",
			opts = {
				provider = "telescope",
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
					{ name = "npm lint", cmd = "sp | term npm run lint-fix -- --cache" },
					{ name = "npm watch tests", cmd = "sp | term npm run test-watch" },
					{ name = "git commit", cmd = ":Git commit" },
					{ name = "git push", cmd = ":Git push origin head" },
					{ name = "codex", cmd = "sp | term codex" },
					{ name = "claude", cmd = "sp | term claude" },
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
		require("telescope").setup({
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

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "file-browser")

		local builtin = require("telescope.builtin")
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

		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })
	end,
}
