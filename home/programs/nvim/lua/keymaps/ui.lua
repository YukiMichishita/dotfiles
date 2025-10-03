local map = vim.keymap.set

-- File management
map("n", "<leader>df", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })

-- Neo-tree
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "NeoTree toggle" })
map("n", "<leader><C-e>", "<cmd>Neotree reveal_force_cwd<CR>", { desc = "NeoTree reveal & set root" })
map("n", "<leader>o", ":Neotree float buffers<CR>", { desc = "NeoTree buffer toggle", nowait = true })
map("n", "gd", ":Neotree float reveal_file=<cfile>")

-- Telescope
map("n", "<leader>p", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>P", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")

-- fzf
map("n", "<leader><C-p>", function()
	require("fzf-lua").builtin()
end, { desc = "Command palette (fzf-lua builtin)" })

-- Git blame
map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git: blame file" })

-- Fold/unfold
local function vsel_lines()
	local s = vim.fn.getpos("v")[2]
	local e = vim.fn.getpos(".")[2]
	if s > e then
		s, e = e, s
	end
	return s, e
end

-- Normal mode folding
map("n", "<leader>fo", "zo", { silent = true, desc = "Fold: open at cursor (one level)" })
map("n", "<leader>fc", "zc", { silent = true, desc = "Fold: close at cursor (one level)" })
map("n", "<leader>fO", require("ufo").openAllFolds, { silent = true, desc = "Fold: open ALL" })
map("n", "<leader>fC", require("ufo").closeAllFolds, { silent = true, desc = "Fold: close ALL" })

-- Visual mode folding
map("v", "<leader>fo", function()
	local s, e = vsel_lines()
	vim.cmd(("silent! keepjumps %d,%dnormal! zo"):format(s, e))
end, { silent = true, desc = "Fold: open selection (one level)" })

map("v", "<leader>fc", function()
	local s, e = vsel_lines()
	vim.cmd(("silent! keepjumps %d,%dnormal! zc"):format(s, e))
end, { silent = true, desc = "Fold: close selection (one level)" })

map("v", "<leader>fO", function()
	local s, e = vsel_lines()
	vim.cmd(("silent! keepjumps %d,%dnormal! zO"):format(s, e))
end, { silent = true, desc = "Fold: recursively open selection" })

map("v", "<leader>fC", function()
	local s, e = vsel_lines()
	vim.cmd(("silent! keepjumps %d,%dnormal! zC"):format(s, e))
end, { silent = true, desc = "Fold: recursively close selection" })

-- Search & Replace
map("n", "<leader>S", function()
	require("spectre").open() -- プロジェクト全体を対象
end, { desc = "Spectre: Search & Replace (project)" })

-- Claude Code
map("v", "<leader>ab", "<cmd>ClaudeCodeSend<CR>", { desc = "Claude: send selection", silent = true })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>", { desc = "Claude: add current buffer", silent = true })
map("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "Claude: toggle", silent = true })

-- Snacks
local S = require("snacks")
S.setup({
	scratch = { enabled = true },
	lazygit = { enabled = true },
})

map("n", "<leader>.", function()
	S.scratch.open()
end, { desc = "Scratch: open" })

map("n", "<leader>S", function()
	S.scratch.select()
end, { desc = "Scratch: select" })

map("n", "<leader>sn", function()
	S.scratch.open()
end, { desc = "Scratch: open" })

map("n", "<leader>st", function()
	S.scratch.open({ ft = "text", new = true })
end, { desc = "Scratch: new (text)" })

-- Markdown
map("n", "<leader>mp", "<cmd>Glow<CR>", { desc = "Markdown Preview" })

-- Harpoon
local harpoon = require("harpoon")

map("n", "<leader>mk", function()
	harpoon:list():add()
end, { desc = "Harpoon: Add file" })

map("n", "<leader>hp", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Menu" })

-- Harpoon file navigation
for i = 1, 5 do
	map("n", "<leader>" .. i, function()
		harpoon:list():select(i)
	end, { desc = "Harpoon: Go to file " .. i })
end

-- neo test
map("n", "<leader>tf", function()
	require("neotest").run.run(vim.fn.expand("%"))
end)
map("n", "<leader>tc", function()
	require("neotest").run.run(vim.fn.getcwd())
end)
map("n", "<leader>ts", function()
	require("neotest").summary.toggle()
end)
map("n", "<leader>to", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end)
map("n", "<leader>tw", function()
	require("neotest").watch.toggle(vim.fn.expand("%"))
end)
map("n", "]t", function()
	require("neotest").jump.next({ status = "failed" })
end)
map("n", "[t", function()
	require("neotest").jump.prev({ status = "failed" })
end)
map("n", "<leader>tS", function()
	require("neotest").run.stop()
end)
map("n", "<leader>tR", function()
	require("neotest").run.run_last()
end)
vim.keymap.set("n", "<leader>td", function()
	require("neotest").run.run({ strategy = "dap" })
end, { desc = "neotest: debug nearest" })
