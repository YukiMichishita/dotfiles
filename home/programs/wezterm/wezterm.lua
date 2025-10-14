local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.font_size = 14.0
config.use_ime = true
config.window_background_opacity = 0.75
config.macos_window_background_blur = 20

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Symbols Nerd Font",
})
config.harfbuzz_features = {
	"calt=0", -- contextual alternates
	"liga=0", -- standard ligatures
	"clig=0", -- contextual ligatures
}

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
	colors = { "#000000" },
}

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"
	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

config.underline_thickness = "1px"
config.underline_position = "-2px"
config.term = "wezterm"
config.use_ime = true

-- config.keys = {
--     {
--         key = ''
--         mod = ''
--         action = wezterm.action.
--     }
-- }

-- カーソルを当てたときだけタイトルバーを出す
function DisableWindowDecorations(window, interval)
	if interval then
		wezterm.sleep_ms(interval)
	end

	local overrides = window:get_config_overrides() or {}
	overrides.window_decorations = nil
	window:set_config_overrides(overrides)
end

wezterm.on("window-focus-changed", function(window, pane)
	if window:is_focused() then
		return
	end

	DisableWindowDecorations(window)
end)

local TITLE_BAR_DISPLAY_TIME = 3000

wezterm.on("show-title-bar", function(window, pane)
	local overrides = window:get_config_overrides() or {}

	overrides.window_decorations = "TITLE | RESIZE"
	window:set_config_overrides(overrides)

	-- これも追加する
	DisableWindowDecorations(window, TITLE_BAR_DISPLAY_TIME)
end)

return config
