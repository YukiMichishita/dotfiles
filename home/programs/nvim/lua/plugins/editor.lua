-- treesitter
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
		},
	},
})

-- ufo
require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		-- 1) LSP が foldingRange を出せるなら LSP 優先
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
			local cap = client.server_capabilities
			if
				cap and (cap.foldingRangeProvider or (cap.foldingRange and cap.foldingRange.dynamicRegistration ~= nil))
			then
				return { "lsp", "indent" } -- フォールバックは必ず 'indent' を指定
			end
		end
		-- 2) Treesitter パーサがあるなら TS → indent
		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok and parsers.has_parser(filetype) then
			return { "treesitter", "indent" }
		end
		-- 3) どれも無理なら indent のみ
		return { "indent" }
	end,
})
vim.o.foldcolumn = "0" -- ufoがfoldcolumnを設定するので、ここで無効化

-- spectre
require("gitsigns").setup({})
require("hlslens").setup({})
require("spectre").setup({})

-- scrollbar
require("scrollbar").setup({
	show = true,
})
require("scrollbar.handlers.search").setup()
pcall(function()
	require("scrollbar.handlers.gitsigns").setup()
end)
pcall(function()
	require("scrollbar.handlers.diagnostic").setup()
end)

-- conform
require("conform").setup({
	-- 保存時に自動フォーマット
	format_on_save = function(bufnr)
		-- LSPが対応していればフォールバックに使う
		return { lsp_fallback = true, timeout_ms = 2000 }
	end,

	-- 言語ごとのフォーマッタ優先度
	formatters_by_ft = {
		lua = { "stylua" },

		go = { "gofumpt", "goimports" },
		python = { "black" },
		rust = { "rustfmt" },

		javascript = { "prettier" },
		typescript = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },

		nix = { "alejandra" },
	},
})

-- neotest
require("neotest").setup({
	adapters = {
		require("neotest-go")({
			experimental = {
				test_table = true,
			},
			args = { "-count=1", "-timeout=60s" },
		}),
		recursive_run = true,
	},

	require("neotest-python")({
		-- venv 自動検出（.venv/venv を優先）
		python = function()
			local cwd = vim.fn.getcwd()
			for _, p in ipairs({ "/.venv/bin/python", "/venv/bin/python" }) do
				if vim.fn.executable(cwd .. p) == 1 then
					return cwd .. p
				end
			end
			return "python3"
		end,
		args = { "-q" },
		runner = "pytest",
	}),

	require("neotest-jest")({
		jestCommand = "npm test --", -- pnpm/yarn なら置換
		env = { CI = "1" },
		cwd = function(_)
			return vim.fn.getcwd()
		end,
		jestConfigFile = function()
			for _, f in ipairs({ "jest.config.ts", "jest.config.js" }) do
				if vim.fn.filereadable(f) == 1 then
					return f
				end
			end
		end,
	}),
})

require("ssr").setup({
	border = "rounded",
	min_width = 200,
	min_height = 80,
})
