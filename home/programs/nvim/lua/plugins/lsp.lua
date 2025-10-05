-- ここに LSP と補完を集約（フラット構成向け）
local lspconfig = require("lspconfig")

local on_attach = function(client, bufnr)
	-- documentHighlight に対応している場合のみ
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			buffer = bufnr,
			group = group,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			buffer = bufnr,
			group = group,
			callback = vim.lsp.buf.clear_references,
		})
	end
end

-- mason
require("mason").setup()
require("mason-lspconfig").setup({})

-- cmp
local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = { { name = "nvim_lsp" } },
})

-- cmp連携capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Go
lspconfig.gopls.setup({
	capabilities = capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = require("lspconfig.util").root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			staticcheck = true,
			gofumpt = true,
			analyses = { unusedparams = true, nilness = true, shadow = true },
		},
	},
	on_attach = on_attach,
})

-- Python
lspconfig.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- C/C++
lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Lean
require("lean").setup({})

-- Rust
lspconfig.rust_analyzer.setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	cmd = { "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
		},
	},
	on_attach = on_attach,
})

-- SQL
lspconfig.sqls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- Nix
lspconfig.nil_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		["nil"] = {
			formatting = {
				command = { "alejandra" },
			},
		},
	},
})

-- Lua
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})

-- Java
lspconfig.jdtls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_dir = require("lspconfig.util").root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
})
