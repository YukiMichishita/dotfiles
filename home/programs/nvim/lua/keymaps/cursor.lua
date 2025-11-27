-- カーソルの画面内相対位置を保ったまま cmd を実行する
local function keep_rel_pos(cmd)
	local before = vim.fn.winsaveview()
	local offset = before.lnum - before.topline

	if type(cmd) == "string" then
		-- 通常のノーマルモードキー列（"n", "gd" など）
		vim.cmd.normal({ cmd, bang = true })
	elseif type(cmd) == "function" then
		-- LSP など、Lua の関数そのものを渡す場合
		cmd()
	end

	local after = vim.fn.winsaveview()
	local new_top = after.lnum - offset

	local winh = vim.api.nvim_win_get_height(0)
	local last = vim.fn.line("$")

	if new_top < 1 then
		new_top = 1
	end

	local max_top = last - winh + 1
	if max_top < 1 then
		max_top = 1
	end
	if new_top > max_top then
		new_top = max_top
	end

	after.topline = new_top
	vim.fn.winrestview(after)
end

local keep_rel_pos = keep_rel_pos

local function map_rpos(mode, lhs, rhs, opts)
	if type(rhs) == "string" then
		-- normal コマンドとして wrap する
		rhs = function()
			keep_rel_pos(rhs)
		end
	elseif type(rhs) == "function" then
		-- 関数（例：vim.lsp.buf.definition）ならそのまま call して wrap
		local original = rhs
		rhs = function()
			keep_rel_pos(original)
		end
	else
		error("rhs must be string or function")
	end

	return vim.keymap.set(mode, lhs, rhs, opts or {})
end

return map_rpos
