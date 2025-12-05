require("claudecode").setup({
	window = {
		type = "float",
		border = "rounded",
		enter_insert = false,
	},
})

require("glow").setup({
	style = "dark",
	width = 120,
})

-- persisted
require("persisted").setup({
	autosave = true,
	autoload = true,
	follow_cwd = true,
	use_git_branch = false,
})

-- harpoon
require("harpoon").setup()

-- dbee
require("dbee").setup({})

-- swagger-preview
require("swagger-preview").setup({
	port = 8000,
	host = "localhost",
})

-- render-markdown
require("render-markdown").setup({})

