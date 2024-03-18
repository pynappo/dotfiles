table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "node.name", "equals", "*" },
		},
	},
	apply_properties = {
		["api.alsa.headroom"] = 4096,
		["api.alsa.soft-mixer"] = true,
	},
})
