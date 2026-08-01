hl.monitor({
	output = "DP-3",
	mode = "2560x1440@170",
	position = "-2560x0",
	bitdepth = 10,
	cm = "srgb",
	scale = "1",
	vrr = 3,
})

hl.monitor({
	output = "DP-2",
	mode = "highrr",
	position = "0x0",
	scale = "1.5",
	bitdepth = 10,
	cm = "srgb",
	sdr_max_luminance = 200,
	sdr_min_luminance = 0.005,
	vrr = 2,
})

hl.env("PROTON_WAYLAND_MONITOR", "DP-2")
hl.workspace_rule({ workspace = "1", monitor = "DP-3" })
hl.workspace_rule({ workspace = "2", monitor = "DP-2" })
hl.workspace_rule({ workspace = "3", monitor = "DP-3" })
hl.workspace_rule({ workspace = "4", monitor = "DP-2" })
hl.workspace_rule({ workspace = "5", monitor = "DP-3" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
hl.workspace_rule({ workspace = "7", monitor = "DP-3" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
hl.workspace_rule({ workspace = "9", monitor = "DP-3" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })
