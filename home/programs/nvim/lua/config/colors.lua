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
