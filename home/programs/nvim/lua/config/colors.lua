local ok, vscode = pcall(require, "vscode")
if ok then
	vscode.setup({
		transparent = true,
		italic_comments = true,
		disable_nvimtree_bg = true,
	})
	vscode.load()
else
	vim.cmd("colorscheme codedark")
end

-- WinBarの境界を強調
vim.api.nvim_set_hl(0, "WinBar", { bg = "#2d3139", fg = "#ffffff", bold = true })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "#1e2127", fg = "#888888" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#61afef", bold = true })
