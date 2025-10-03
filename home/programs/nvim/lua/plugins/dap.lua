-- dap
local dap, dapui = require("dap"), require("dapui")
dapui.setup({})
require("nvim-dap-virtual-text").setup({})
dap.listeners.after.event_initialized["dapui"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
	dapui.close()
end

require("dap-go").setup()
dap.adapters.delve = {
	type = "server",
	port = "${port}",
	executable = {
		command = "dlv",
		args = { "dap", "-l", "127.0.0.1:${port}", "--log" },
	},
}
dap.configurations.go = {
	{
		type = "delve",
		name = "Debug current file",
		request = "launch",
		program = "${file}",
		cwd = "${fileDirname}",
	},
	{
		type = "delve",
		name = "Debug file",
		request = "launch",
		program = "${file}",
	},
}

dap.adapters.python = {
	type = "executable",
	command = vim.fn.exepath("python3"),
	args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = dap.configurations.python or {}
require("dap.ext.vscode").load_launchjs(nil, {
	python = { "python" },
})

dap.adapters["pwa-node"] = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = { command = "js-debug-adapter", args = { "${port}" } },
}
dap.configurations.javascript = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch file",
		program = "${file}",
		cwd = "${workspaceFolder}",
	},
}
dap.configurations.typescript = dap.configurations.javascript

-- lldb-vscode (LLDB付属) を使う場合
dap.adapters.lldb = {
	type = "executable",
	command = vim.fn.exepath("lldb-vscode"),
	name = "lldb",
}
dap.configurations.cpp = {
	{
		name = "Debug",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.c = dap.configurations.cpp

local function write_launch_json(lang)
	local templates = {
		python = [[
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal",
      "pythonPath": "${workspaceFolder}/.venv/bin/python"
    }
  ]
}
]],
		go = [[
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Go: Debug",
      "type": "go",
      "request": "launch",
      "program": "${fileDirname}",
      "dlvToolPath": "${workspaceFolder}/bin/dlv"
    }
  ]
}
]],
	}

	local path = vim.fn.getcwd() .. "/.vscode/launch.json"
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
	local f = io.open(path, "w")
	f:write(templates[lang] or "{}")
	f:close()
	print("Created " .. path)
end

vim.api.nvim_create_user_command("MakeLaunchJson", function(opts)
	write_launch_json(opts.args)
end, {
	nargs = 1,
	complete = function()
		return { "python", "go" }
	end,
})

