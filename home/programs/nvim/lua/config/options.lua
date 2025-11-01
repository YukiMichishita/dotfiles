vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.winbar = "%=%m %f"
vim.opt.shell = "zsh"
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFD700", bold = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	command = "checktime",
})
vim.o.timeoutlen = 1500
vim.o.ttimeoutlen = 30
vim.o.winbar = "%f%="

-- 背景透過（cmd版よりAPIのほうが速い）
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalSB", { bg = "none" })

-- インデント
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- スプリットの位置
vim.opt.splitbelow = true  -- 水平スプリットで新しいウィンドウを下に開く
vim.opt.splitright = true  -- 垂直スプリットで新しいウィンドウを右に開く

-- 補完UI
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- タイトルを使う（値はautocmdで固定）
vim.opt.title = true

-- ステータスラインを非表示（下のバーを消す）
vim.opt.laststatus = 0
vim.opt.cmdheight = 1  -- コマンドラインの高さは1行維持

-- netrw無効化
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- fold/unfold
vim.o.foldcolumn = "1" -- 左に折りたたみガイドを表示
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.foldopen = ""

-- lens的な
vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		severity = { min = vim.diagnostic.severity.WARN }, -- WARN以上だけ表示（好みで）
		prefix = function(diag)
			local icons = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
				[vim.diagnostic.severity.HINT] = "",
			}
			return icons[diag.severity] .. " "
		end,
	},
	underline = true,
	severity_sort = true,
	update_in_insert = false,
})
