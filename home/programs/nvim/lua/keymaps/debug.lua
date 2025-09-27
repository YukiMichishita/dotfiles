local map = vim.keymap.set
local dap, dapui = require("dap"), require("dapui")

-- Debug controls
map("n", "<leader>bp", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
map("n", "<F5>", dap.continue, { desc = "DAP: Continue/Start" })
map("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
map("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
map("n", "<S-F11>", dap.step_out, { desc = "DAP: Step Out" })
map("n", "<F6>", dap.restart, { desc = "DAP: Restart" })
map("n", "<F17>", dap.terminate, { desc = "DAP: Terminate" }) -- Shift+F5

-- Debug UI
map("n", "<leader>dr", dap.repl.open, { desc = "DAP: REPL" })
map("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })

-- Conditional breakpoint
map("n", "<leader>db", function()
	dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP: Conditional BP" })

-- Telescope integration
pcall(function()
	require("telescope").load_extension("dap")
	map("n", "<leader>ds", "<cmd>Telescope dap frames<CR>", { desc = "DAP: Frames" })
	map("n", "<leader>dl", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "DAP: List BPs" })
end)