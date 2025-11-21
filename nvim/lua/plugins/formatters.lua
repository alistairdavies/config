return {
	"stevearc/conform.nvim",
	opts = {
		notify_on_error = false,
		format_on_save = true,
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black", "ruff_fix", "ruff_format" },
			rust = { "rustfmt" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			go = { "gofmt" },
			["_"] = { "trim_whitespace" },
		},
	},
}
