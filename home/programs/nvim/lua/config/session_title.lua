local M = {}

local function basename(p)
	return vim.fn.fnamemodify(p, ":t")
end

local function project_name()
	local top = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
	if top ~= "" and vim.v.shell_error == 0 then
		return basename(top)
	end
	return basename(vim.fn.getcwd())
end

function M.compute()
	local arg0 = vim.fn.argv(0) or ""
	if arg0 ~= "" then
		if vim.fn.isdirectory(arg0) == 1 then
			return basename(arg0)
		elseif vim.fn.filereadable(arg0) == 1 then
			return basename(arg0)
		end
	end
	return project_name()
end

return M
