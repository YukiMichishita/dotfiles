-- leaderは最初に
vim.g.mapleader = " "

-- 速くなるやつ（0.9+）
pcall(function()
	vim.loader.enable()
end)

-- モジュラー構成でrequire
require("config")
require("plugins")
require("keymaps.main")
