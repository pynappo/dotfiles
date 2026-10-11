-- Start of translated config by hyprlang-to-lua.nvim on 2026-05-24T13:33:12
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "nvim")
hl.env("TERMINAL", "kitty")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("HYPRCURSOR_THEME", "catppuccin-macchiato-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-macchiato-dark-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("PROTON_ENABLE_HDR", "1")
hl.env("PROTON_FSR4_UPGRADE", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("RADV_PERFTEST", "gpl")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("TERM", "kitty")
-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor catppuccin-macchiato-dark-cursors 24")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("swayosd-server")
end)
-- Execute your favorite apps at launch
hl.on("hyprland.start", function()
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	hl.exec_cmd("quickshell -c pynappo")
	hl.exec_cmd("imwheel")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprpm update -n")
	hl.exec_cmd("wljoywake")
	hl.exec_cmd("sleep 1; bash $HOME/.config/hypr/scripts/systemd.sh")
	hl.exec_cmd("gtk-launch discord-canary", { workspace = "1 silent" })
	hl.exec_cmd("kitty", { workspace = "3 silent" })
	hl.exec_cmd("kitty", { workspace = "4 silent" })
end)
-- exec-once = [workspace 6 silent] steam-runtime
hl.on("hyprland.start", function()
	hl.exec_cmd("easyeffects --gapplication-service")
	hl.exec_cmd("fish $HOME/.config/hypr/scripts/swww.sh")
end)
-- bind = SUPER,page_down,pass,vesktop
-- bind = SUPER,page_up,pass,vesktop
-- source = ~/.config/hypr/myColors.conf
pcall(require, "local")
hl.window_rule({
	name = "steammonitor",
	match = {
		class = "^(steam)",
	},
	workspace = "6 silent",
})
hl.window_rule({
	name = "hidden",
	match = {
		tag = "hidden",
	},
	no_anim = true,
	no_focus = true,
	opacity = 0,
})
-- hyprlang-to-lua: excluding match.class = steam_app.* from below, as Lua does not allow duplicate keys
hl.window_rule({
	name = "games",
	match = {
		class = "Barotrauma",
	},
	content = "game",
	render_unfocused = true,
})
hl.window_rule({
	name = "fullscreen",
	match = {
		fullscreen = true,
	},
	idle_inhibit = "always",
})
-- make some dialogs float
hl.window_rule({
	name = "floats",
	match = {
		title = "SteamTinkerLaunch",
	},
	float = true,
})
hl.window_rule({
	name = "dim-permission-popups",
	match = {
		class = "org\\.kde\\.polkit.*",
	},
	dim_around = true,
})
-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 2,
		touchpad = {
			natural_scroll = true,
			scroll_factor = 0.2,
			tap_to_click = true,
		},
		sensitivity = 0,
		accel_profile = "flat",
	},
	general = {
		gaps_in = 2,
		gaps_out = 0,
		border_size = 2,
		col = {
			active_border = "rgba(9999ffee)",
			inactive_border = "rgba(595959aa)",
		},
		layout = "dwindle",
		resize_on_border = true,
		extend_border_grab_area = 2,
	},
	decoration = {
		rounding = 5,
		blur = {
			enabled = true,
			new_optimizations = true,
			passes = 1,
			size = 3,
		},
		shadow = {
			range = 4,
			render_power = 3,
		},
	},
	misc = {
		initial_workspace_tracking = 2,
	},
	-- https://wiki.hyprland.org/Configuring/Animations/
	animations = {
		enabled = true,
	},
	quirks = {
		-- prefer_hdr = true,
	},
})
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "default", style = "popin 60%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "default", style = "slidefadevert" })
hl.config({
	dwindle = {
		preserve_split = true,
	},
})
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_in = 0, gaps_out = 0 })
hl.window_rule({ border_size = 0, match = { float = "0", workspace = "w[tv1]" } })
hl.window_rule({ match = { float = "0", workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ border_size = 0, match = { float = "0", workspace = "f[1]" } })
hl.window_rule({ match = { float = "0", workspace = "f[1]" }, rounding = 0 })
hl.config({
	debug = {
		disable_logs = true,
		enable_stdout_logs = false,
	},
})
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})
hl.config({
	misc = {
		vrr = 1,
		mouse_move_focuses_monitor = false,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = false,
		render_unfocused_fps = 60,
	},
})
hl.config({
	render = {
		-- direct_scanout = 2,
		cm_auto_hdr = 2,
		non_shader_cm = 3,
		non_shader_cm_interop = 1,
	},
})
hl.config({
	group = {
		groupbar = {
			blur = true,
			col = {
				active = "rgba(222222ff)",
				inactive = "rgba(666666ff)",
			},
			font_size = 12,
			text_color = "rgba(8888ffff)",
		},
	},
})

-- Example windowrule v1
-- windowrule = float, ^(kitty)$ Example windowrule v2
-- windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill rofi || rofi -show combi -show-icons"))
hl.bind("SUPER + period", hl.dsp.exec_cmd("pkill rofi || rofimoji | wl-copy"))
hl.bind(
	"SUPER + CTRL + equal",
	hl.dsp.exec_cmd(
		[[hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 + 0.1}')"]]
	)
)
hl.bind(
	"SUPER + CTRL + minus",
	hl.dsp.exec_cmd(
		[[hyprctl keyword cursor:zoom_factor "$(hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2 - 0.1}')"]]
	)
)
hl.bind("SHIFT + SUPER + C", hl.dsp.exec_cmd("pkill wofi || wofi-calc | wl-copy"))
hl.bind("SHIFT + SUPER + period", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
-- screenshots
hl.bind("SUPER + SHIFT + s", hl.dsp.exec_cmd("grimblast --freeze copysave area"))
hl.bind(
	"SUPER + ALT + SHIFT + s",
	hl.dsp.exec_cmd('pkill wf-recorder || wf-recorder -g "$(slurp)" -f ~/Videos/$(date +"%Y%m%d-%H%M%S").mp4')
)
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("grimblast copysave output"))
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast copysave screen"))
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd('grim -g "$(slurp)" - | tesseract - - | wl-copy'))
-- audio binds
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume +5 --max-volume 150"),
	{ repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume -5 --max-volume 150"),
	{ repeating = true }
)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { repeating = true })
-- binde=, XF86MonBrightnessUp, exec, swayosd-client --brightness raise
-- binde=, XF86MonBrightnessDown, exec, swayosd-client --brightness lower
hl.bind("SUPER + page_down", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))
hl.bind("SUPER + page_up", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
-- see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + C", hl.dsp.window.close({ window = "activewindow" }))
hl.bind("SUPER + M", hl.dsp.exit())
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"))
hl.bind("SUPER + Z", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind("ALT + Return", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind("SUPER + w", hl.dsp.exec_cmd("pkill quickshell || quickshell -c pynappo"))
--Group binds
hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + SHIFT + P", hl.dsp.window.move({ out_of_group = "active" }))
hl.bind("SUPER + N", hl.dsp.group.next())
hl.bind("SUPER + P", hl.dsp.group.prev())
-- Move focus with mainMod + arrow/hjkl keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + h", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + l", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + k", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + j", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
-- Switch workspaces with mainMod + [0-9]
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10" }))
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = false }))
hl.bind("SUPER + ALT + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = false }))
hl.bind("SUPER + ALT + SHIFT + left", hl.dsp.workspace.move({ monitor = "-1" }))
hl.bind("SUPER + ALT + SHIFT + right", hl.dsp.workspace.move({ monitor = "+1" }))
-- Move/resize windows with mainMod + LMB/RMB and dragging&
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:274", hl.dsp.window.close({ window = "activewindow" }))
hl.bind("SUPER + mouse:274", hl.dsp.window.close({ window = "activewindow" }))
hl.bind("SUPER + T", hl.dsp.exec_cmd('hyprctl notify -1 5000 "rgb(00ff00)" "tagging on, g: game"'))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
-- Alt-tab
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({}))
hl.bind("ALT + Tab", hl.dsp.window.alter_zorder({ mode = "top" }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind("ALT + SHIFT + Tab", hl.dsp.window.alter_zorder({ mode = "top" }))
hl.layer_rule({ match = { class = "waybar" }, blur = true })
hl.bind("SUPER + CTRL + SHIFT + b", function() --[[hyprlang-to-lua: no equivalent for forcerendererreload]]
end)
hl.bind("SUPER + ALT + d", hl.dsp.exit())
hl.bind("SUPER + D", hl.dsp.exec_cmd("/usr/lib/hyprwhspr/config/hyprland/hyprwhspr-tray.sh record"), {
	description = "Speech-to-text",
})
-- End of translated config by hyprlang-to-lua.nvim on 2026-05-24T13:33:12
-- vim: backupcopy=yes
