local renderer = require("neo-tree.ui.renderer")
local fs = require("neo-tree.sources.filesystem")

require("neo-tree").setup({
	sources = { "filesystem", "buffers", "git_status" },
	open_files_do_not_replace_types = {
		--"terminal",
		"trouble",
		"qf",
	},
	window = {
		position = "right",
		width = 50,
		mappings = {
			["P"] = function(state)
				local node = state.tree:get_node()
				require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
			end,
		},
		open_in_split = false,
	},
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
	source_selector = {
		winbar = false,
		statusline = false,
	},
	buffers = {},
	mappings = {
		["<space>"] = {
			"toggle_node",
			nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
		},
		["<q>"] = "cancel", -- close preview or floating neo-tree window
		["P"] = {
			"toggle_preview",
			config = {
				use_float = true,
				use_snacks_image = true,
				use_image_nvim = true,
			},
		},
		-- Read `# Preview Mode` for more information
		["l"] = "focus_preview",
		["S"] = "open_split",
		["s"] = "open_vsplit",
		-- ["S"] = "split_with_window_picker",
		-- ["s"] = "vsplit_with_window_picker",
		["t"] = "open_tabnew",
		["<cr>"] = "open_drop",
		-- ["t"] = "open_tab_drop",
		["w"] = "open_with_window_picker",
		--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
		["C"] = "close_node",
		-- ['C'] = 'close_all_subnodes',
		["z"] = "close_all_nodes",
		--["Z"] = "expand_all_nodes",
		--["Z"] = "expand_all_subnodes",
		["a"] = {
			"add",
			-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
			-- some commands may take optional config options, see `:h neo-tree-mappings` for details
			config = {
				show_path = "none", -- "none", "relative", "absolute"
			},
		},
		["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
		["d"] = "delete",
		["r"] = "rename",
		["b"] = "rename_basename",
		["y"] = "copy_to_clipboard",
		["x"] = "cut_to_clipboard",
		["p"] = "paste_from_clipboard",
		["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
		["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
		["q"] = "close_window",
		["R"] = "refresh",
		["<"] = "prev_source",
		[">"] = "next_source",
		["i"] = "show_file_details",
	},
})

-- diffview
require("diffview").setup({
	-- 自動起動を防ぐ設定
	enhanced_diff_hl = false,
	view = {
		-- デフォルトレイアウトの設定
		default = {
			layout = "diff2_horizontal",
		},
		-- ファイル履歴のレイアウト
		file_history = {
			layout = "diff2_horizontal",
		},
	},
	-- キーマップ設定（diffview内での操作）
	keymaps = {
		view = {
			-- q で簡単に閉じられるようにする
			["q"] = "<Cmd>DiffviewClose<CR>",
		},
		file_panel = {
			["q"] = "<Cmd>DiffviewClose<CR>",
		},
		file_history_panel = {
			["q"] = "<Cmd>DiffviewClose<CR>",
		},
	},
})

-- telescope
require("telescope").setup({
	defaults = {
		path_display = {
			"truncate",
			"absolute",
		},
	},
	extensions = {
		["ui-select"] = require("telescope.themes").get_dropdown({}),
		live_grep_args = {
			auto_quoting = true,
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})
require("telescope").load_extension("ui-select")
require("telescope").load_extension("live_grep_args")

require("vimade").setup({
	recipe = { "default", { animate = false } },
	ncmode = "buffers",
	fadelevel = 0.8,
	basebg = "",
	tint = { fg = { rgb = { 0, 200, 0 }, intensity = 0.3 } },
})

require("treesitter-context").setup({
	enable = true,
	max_lines = 0, -- 0 = unlimited
	trim_scope = "outer",
	mode = "cursor",
	separator = nil,
})

-- vim-wintabs
vim.g.wintabs_autoclose = 2 -- ウィンドウごとの最後のバッファを閉じたときの動作
vim.g.wintabs_autoclose_vim = 1 -- Vimの最後のバッファを閉じたときにVimを終了
vim.g.wintabs_display = "tabline" -- タブライン（画面最上部）に表示
vim.g.wintabs_switchbuf = "" -- バッファ切り替え動作のカスタマイズ
vim.g.wintabs_ui_show_vimtab = 0 -- Vimタブ表示を無効化

-- vim-wintabs カラー設定（アクティブタブを目立たせる）
vim.api.nvim_set_hl(0, "WintabsActive", { fg = "#FFD700", bg = "#3a3a3a", bold = true }) -- アクティブタブ: 金色、太字
vim.api.nvim_set_hl(0, "WintabsInactive", { fg = "#808080", bg = "#1a1a1a" }) -- 非アクティブタブ: グレー
vim.api.nvim_set_hl(0, "WintabsActiveNC", { fg = "#B8860B", bg = "#2a2a2a", bold = true }) -- アクティブタブ（非カレントウィンドウ）
vim.api.nvim_set_hl(0, "WintabsInactiveNC", { fg = "#606060", bg = "#1a1a1a" }) -- 非アクティブタブ（非カレントウィンドウ）
