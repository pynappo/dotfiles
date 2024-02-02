table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "device.name", "matches", "alsa_card.*" },
		},
	},
	apply_properties = {
		["api.alsa.soft-mixer"] = true,
	},
})
