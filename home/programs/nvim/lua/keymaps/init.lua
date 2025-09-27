local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
map({ "n", "v" }, "<C-h>", "<C-w>h", { noremap = true })
map({ "n", "v" }, "<C-j>", "<C-w>j", { noremap = true })
map({ "n", "v" }, "<C-k>", "<C-w>k", { noremap = true })
map({ "n", "v" }, "<C-l>", "<C-w>l", { noremap = true })

-- Window resizing
map("n", "<M-h>", "<C-w>>", { desc = "Resize window left" })
map("n", "<M-l>", "<C-w><", { desc = "Resize window right" })
map("n", "<M-j>", "<C-w>+", { desc = "Resize window down" })
map("n", "<M-k>", "<C-w>-", { desc = "Resize window up" })

-- Buffer navigation
map("n", "<C-,>", ":BufSurfBack<CR>", { noremap = true })
map("n", "<C-.>", ":BufSurfForward<CR>", { noremap = true })
map("n", "<leader>w", "<cmd>bd<CR>", { desc = "Close buffer" })

-- Terminal
map("n", "<leader>t", ":terminal<CR>", { noremap = true, nowait = true })
map("t", "<C-[>", [[<C-\><C-n>]], opts)

-- Scrolling
map("n", "<C-y>", "2<C-y>", { noremap = true, silent = true })
map("n", "<C-e>", "2<C-e>", { noremap = true, silent = true })

-- Search navigation
map("n", "<leader>n", function()
	local word = vim.fn.expand("<cword>")
	vim.fn.setreg("/", "\\V\\<" .. word .. "\\>")
	vim.cmd("normal! N") -- 前方向にジャンプ
end, { desc = "Search word under cursor (backward)" })

-- System
map("n", "<leader>dr", "<cmd>!sudo darwin-rebuild switch<CR>", {})

