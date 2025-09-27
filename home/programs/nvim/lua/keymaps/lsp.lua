local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LSP navigation
map("n", "<F12>", "<cmd>Telescope lsp_definitions<CR>", opts)
map("n", "<F24>", "<cmd>Telescope lsp_implementations<CR>", opts)
map("n", "<leader>r", "<cmd>Telescope lsp_references<CR>", { desc = "Find usages", noremap = true, silent = true })
map("n", "<leader>h", vim.lsp.buf.hover, { desc = "LSP Hover (type/signature/docs)" })

-- LSP actions
map("n", "<F2>", function()
	vim.lsp.buf.rename()
end, { desc = "LSP Rename" })

map("n", "<leader>ca", function()
	vim.lsp.buf.code_action()
end, { desc = "LSP Code Actions" })

map("n", "<leader>su", function()
	require("type_hierarchy_picker").supertypes()
end, { desc = "Type Hierarchy: supertypes" })

-- Diagnostics
map("n", "gl", function()
	vim.diagnostic.open_float(nil, { focus = false })
end, { desc = "Show diagnostics (float)" })

map("n", "<leader>dq", function()
	vim.diagnostic.setqflist({ open = true })
end, { desc = "Diagnostics → Quickfix (all buffers)" })

map("n", "<leader>dv", function()
	local cfg = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not (cfg and (cfg == true or cfg.prefix ~= nil)) })
end, { desc = "Diagnostics: toggle virtual text" })

-- Format
map({ "n", "v" }, "<leader>fm", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer/selection (Conform)" })

