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
		winbar = true,
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
require("diffview").setup()

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
			no_ignore = true,
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
	max_lines = 3,
	trim_scope = "outer",
})
