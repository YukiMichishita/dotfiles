vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local title = require("config.session_title").compute()
		vim.opt.titlestring = title
		vim.opt.titleold = title
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		vim.opt.titleold = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end,
})

-- ========== Type Hierarchy → Telescope ピッカー（autocmds.lua 直書き版） ==========
local has_telescope, telescope = pcall(require, "telescope")
if has_telescope then
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local function to_item(node)
		local uri = node.uri or (node.data and node.data.uri)
		local range = node.selectionRange or node.range
		if not (uri and range) then
			return nil
		end
		local fname = vim.uri_to_fname(uri)
		return {
			display = string.format("%s  —  %s:%d", node.name or "(anonymous)", fname, (range.start.line or 0) + 1),
			ordinal = (node.name or "") .. " " .. fname,
			filename = fname,
			lnum = (range.start.line or 0) + 1,
			col = (range.start.character or 0) + 1,
		}
	end

	local function type_hierarchy(kind) -- "supertypes" | "subtypes"
		local params = vim.lsp.util.make_position_params()
		vim.lsp.buf_request(0, "textDocument/prepareTypeHierarchy", params, function(err, res)
			if err or not res or #res == 0 then
				vim.notify("TypeHierarchy not supported here", vim.log.levels.WARN)
				return
			end
			local item = res[1]
			vim.lsp.buf_request(0, "typeHierarchy/" .. kind, { item = item }, function(_, nodes)
				if not nodes or #nodes == 0 then
					vim.notify("No " .. kind .. " found", vim.log.levels.INFO)
					return
				end
				local entries = {}
				for _, n in ipairs(nodes) do
					local it = to_item(n)
					if it then
						table.insert(entries, it)
					end
				end
				pickers
					.new({}, {
						prompt_title = "Type Hierarchy • " .. kind,
						finder = finders.new_table({
							results = entries,
							entry_maker = function(e)
								return {
									value = e,
									display = e.display,
									ordinal = e.ordinal,
									filename = e.filename,
									lnum = e.lnum,
									col = e.col,
								}
							end,
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(prompt_bufnr, _)
							actions.select_default:replace(function()
								actions.close(prompt_bufnr)
								local entry = action_state.get_selected_entry()
								if entry and entry.filename then
									vim.cmd(("edit %s"):format(vim.fn.fnameescape(entry.filename)))
									vim.api.nvim_win_set_cursor(0, { entry.lnum, math.max(0, entry.col - 1) })
								end
							end)
							return true
						end,
					})
					:find()
			end)
		end)
	end

	-- キーマップ（好きに変更可）
	vim.keymap.set("n", "<leader>su", function()
		type_hierarchy("supertypes")
	end, { desc = "Type Hierarchy: supertypes" })
	vim.keymap.set("n", "<leader>sd", function()
		type_hierarchy("subtypes")
	end, { desc = "Type Hierarchy: subtypes" })
else
	vim.notify("telescope.nvim not found (Type Hierarchy picker disabled)", vim.log.levels.WARN)
end

local M = {}

local buf_nr = nil
local win_id = nil

local function build_ls_lines()
	local buflist = vim.fn.getbufinfo({ buflisted = 1 })
	local lines = {}
	for _, buf in ipairs(buflist) do
		local flag = buf.changed == 1 and "+" or " "
		table.insert(lines, string.format(" %3d %s %s", buf.bufnr, flag, buf.name))
	end
	return lines
end
