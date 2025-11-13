-- ここに LSP と補完を集約(フラット構成向け)
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
vim.lsp.config.gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	capabilities = capabilities,
	settings = {
		gopls = {
			staticcheck = true,
			gofumpt = true,
			analyses = { unusedparams = true, nilness = true, shadow = true },
		},
	},
	on_attach = on_attach,
}
vim.lsp.enable("gopls")

-- Python
vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("pyright")

-- C/C++
vim.lsp.config.clangd = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
		".git",
	},
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("clangd")

-- Lean
require("lean").setup({})

-- Rust
vim.lsp.config.rust_analyzer = {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", "rust-project.json" },
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			checkOnSave = { command = "clippy" },
		},
	},
	on_attach = on_attach,
}
vim.lsp.enable("rust_analyzer")

-- SQL
vim.lsp.config.sqls = {
	cmd = { "sqls" },
	filetypes = { "sql", "mysql" },
	root_markers = { ".git" },
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("sqls")

-- Nix
vim.lsp.config.nil_ls = {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" },
	capabilities = capabilities,
	settings = {
		["nil"] = {
			formatting = {
				command = { "alejandra" },
			},
		},
	},
	on_attach = on_attach,
}
vim.lsp.enable("nil_ls")

-- Lua
vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	capabilities = capabilities,
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
	on_attach = on_attach,
}
vim.lsp.enable("lua_ls")

-- Java
vim.lsp.config.jdtls = {
	cmd = { "jdtls" },
	filetypes = { "java" },
	root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("jdtls")

-- Haskell
vim.lsp.config.haskell_language_server = {
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	filetypes = { "haskell", "lhaskell" },
	root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml" },
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("haskell_language_server")

-- F#
vim.lsp.config.fsautocomplete = {
	cmd = { "fsautocomplete", "--background-service-enabled" },
	filetypes = { "fsharp" },
	root_markers = { "*.sln", "*.fsproj", ".git" },
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("fsautocomplete")

-- Copilot
require("copilot").setup({
	suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<m-l>" } },
	filetypes = {
		gitcommit = true,
	},
})
vim.lsp.enable("copilot")
