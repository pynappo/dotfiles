table.insert(alsa_monitor.rules, {
        matches = {
                {
                        -- This matches all cards.
                        { "device.name", "matches", "alsa_card.*" },
                }, },
        -- Apply properties on the matched object.
        apply_properties = {
                -- Do not use the hardware mixer for volume control. It
                -- will only use software volume. The mixer is still used
                -- to mute unused paths based on the selected port.
                ["api.alsa.soft-mixer"] = true,
        }
})
