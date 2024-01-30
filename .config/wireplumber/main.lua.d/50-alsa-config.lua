table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "device.name", "matches", "alsa_card.*" },
		},
	},
	apply_properties = {
		["api.alsa.headroom"] = 1024,
		["api.alsa.soft-mixer"] = true,
	},
})
