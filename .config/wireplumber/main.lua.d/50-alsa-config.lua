table.insert(alsa_monitor.rules, {
	matches = {
		{
			{ "node.name", "equals", "*" },
		},
	},
	apply_properties = {
		["api.alsa.headroom"] = 512,
		["api.alsa.soft-mixer"] = true,
	},
})
