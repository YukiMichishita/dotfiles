local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation (vim-tmux-navigator)
-- vim-tmux-navigatorがこれらのキーを処理し、tmuxとvimの境界を越えてナビゲート可能にする
map({ "n", "v" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true, desc = "Navigate left (tmux/vim)" })
map({ "n", "v" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true, desc = "Navigate down (tmux/vim)" })
map({ "n", "v" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true, desc = "Navigate up (tmux/vim)" })
map({ "n", "v" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>", { silent = true, desc = "Navigate right (tmux/vim)" })
map({ "n", "v" }, "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", { silent = true, desc = "Navigate to previous (tmux/vim)" })

-- Window resizing
map("n", "<M-h>", "<C-w>>", { desc = "Resize window left" })
map("n", "<M-l>", "<C-w><", { desc = "Resize window right" })
map("n", "<M-j>", "<C-w>+", { desc = "Resize window down" })
map("n", "<M-k>", "<C-w>-", { desc = "Resize window up" })

-- Buffer navigation
-- vim-bufsurfを無効化したためコメントアウト
-- map("n", "<C-,>", ":BufSurfBack<CR>", { noremap = true, desc = "Buffer surf back" })
-- map("n", "<C-.>", ":BufSurfForward<CR>", { noremap = true, desc = "Buffer surf forward" })
map("n", "<leader>w", "<cmd>bd<CR>", { desc = "Close buffer" })
map("n", "<leader>W", "<cmd>bd!<CR>", { desc = "Force close buffer" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Force close buffer" })
map("n", "<leader>Q", "<cmd>q!<CR>", { desc = "Force close buffer" })

-- Terminal
map("n", "<leader>t", function()
	vim.cmd("split")
	vim.cmd("resize " .. math.floor(vim.o.lines / 3))
	vim.cmd("wincmd J")
	vim.cmd("terminal")
end, { noremap = true, nowait = true, desc = "Open terminal in bottom split" })

-- Scrolling
map("n", "<C-y>", "2<C-y>", { noremap = true, silent = true, desc = "Scroll up (2 lines)" })
map("n", "<C-e>", "2<C-e>", { noremap = true, silent = true, desc = "Scroll down (2 lines)" })

-- Search navigation
map("n", "<leader>n", function()
	local word = vim.fn.expand("<cword>")
	vim.fn.setreg("/", "\\V\\<" .. word .. "\\>")
	vim.cmd("normal! N") -- 前方向にジャンプ
end, { desc = "Search word under cursor (backward)" })

-- System
map("n", "<leader>dr", "<cmd>!sudo darwin-rebuild switch<CR>", { desc = "Darwin rebuild switch" })

-- save
map("n", "<C-s>", "<cmd>update<CR>", { desc = "save" })

-- EasyMotion
map("n", "<leader>f", "<Plug>(easymotion-w)", { desc = "EasyMotion word forward" })
map("n", "<leader>b", "<Plug>(easymotion-b)", { desc = "EasyMotion word backward" })
map("n", "<leader>j", "<Plug>(easymotion-j)", { desc = "EasyMotion line down" })
map("n", "<leader>k", "<Plug>(easymotion-k)", { desc = "EasyMotion line up" })
map("n", "<leader>s", "<Plug>(easymotion-s2)", { desc = "EasyMotion 2-char search" })
