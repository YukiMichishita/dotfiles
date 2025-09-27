-- treesitter
require("nvim-treesitter.configs").setup({
	highlight = { enable = true },
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

-- spectre
require("gitsigns").setup({})
require("hlslens").setup({})
require("spectre").setup({})

-- scrollbar
require("scrollbar").setup({
	show = true,
	-- 気になるなら幅やハイライトをここで調整可能
	-- handle = { color = "#3b4252" },
	-- marks で診断の色を好みに合わせて上書きできる
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

		javascript = { "prettier" },
		typescript = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },

		nix = { "alejandra" },
	},
})