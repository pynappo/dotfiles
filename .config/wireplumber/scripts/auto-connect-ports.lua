-- yoinked from bennetthardwick/dotfiles:

-- As explained on: https://bennett.dev/auto-link-pipewire-ports-wireplumber/
--
-- This script keeps my stereo-null-sink connected to whatever output I'm currently using.
-- I do this so Pulseaudio (and Wine) always sees a stereo output plus I can swap the output
-- without needing to reconnect everything.

-- Link two ports together
function link_port(output_port, input_port)
	if not input_port or not output_port then
		return false
	end

	local link_args = {
		["link.input.node"] = input_port.properties["node.id"],
		["link.input.port"] = input_port.properties["object.id"],

		["link.output.node"] = output_port.properties["node.id"],
		["link.output.port"] = output_port.properties["object.id"],

		-- The node never got created if it didn't have this field set to something
		["object.id"] = nil,

		-- I was running into issues when I didn't have this set
		["object.linger"] = true,

		["node.description"] = "Link created by auto_connect_ports",
	}

	local link = Link("link-factory", link_args)
	link:activate(1)

	return true
end

-- Automatically link ports together by their specific audio channels.
--
-- ┌──────────────────┐         ┌───────────────────┐
-- │                  │         │                   │
-- │               FL ├────────►│ AUX0              │
-- │      OUTPUT      │         │                   │
-- │               FR ├────────►│ AUX1  INPUT       │
-- │                  │         │                   │
-- └──────────────────┘         │ AUX2              │
--                              │                   │
--                              └───────────────────┘
--
-- -- Call this method inside a script in global scope
--
-- auto_connect_ports {
--
--   -- A constraint for all the required ports of the output device
--   output = Constraint { "node.name"}
--
--   -- A constraint for all the required ports of the input device
--   input = Constraint { .. }
--
--   -- A mapping of output audio channels to input audio channels
--
--   connections = {
--     ["FL"] = "AUX0"
--     ["FR"] = "AUX1"
--   }
--
-- }
--
function auto_connect_ports(args)
	local output_om = ObjectManager({
		Interest({
			type = "port",
			args.output,
			Constraint({ "port.direction", "equals", "out" }),
		}),
	})

	local input_om = ObjectManager({
		Interest({
			type = "port",
			args.input,
			Constraint({ "port.direction", "equals", "in" }),
		}),
	})

	local all_links = ObjectManager({
		Interest({
			type = "link",
		}),
	})

	function _connect()
		for output_name, input_name in pairs(args.connect) do
			local output = output_om:lookup({ Constraint({ "audio.channel", "equals", output_name }) })
			local input = input_om:lookup({ Constraint({ "audio.channel", "equals", input_name }) })

			link_port(output, input)
		end
	end

	output_om:connect("object-added", _connect)
	input_om:connect("object-added", _connect)
	all_links:connect("object-added", _connect)

	output_om:activate()
	input_om:activate()
	all_links:activate()
end

-- Auto connect SC3 to Q2U
auto_connect_ports({
	output = Constraint({ "object.path", "matches", "alsa:pcm:SC3*capture*" }),
	input = Constraint({ "port.alias", "matches", "Q2U Filters*" }),
	connect = {
		["FL"] = "FL",
		["FR"] = "FL",
	},
})

-- -- Auto connect the stereo null sink to the jack_sink for when the jack server gets started
-- auto_connect_ports({
-- 	output = Constraint({ "object.path", "matches", "stereo-null-sink:*" }),
-- 	input = Constraint({ "object.path", "matches", "jack_sink:*" }),
-- 	connect = {
-- 		["FL"] = "FL",
-- 		["FR"] = "FR",
-- 	},
-- })
--
-- -- Auto connect the stereo null sink to the jack_sink for when the jack server gets started
-- auto_connect_ports({
-- 	output = Constraint({ "object.path", "matches", "stereo-null-sink:*" }),
-- 	input = Constraint({ "object.path", "matches", "alsa:pcm:*" }),
-- 	connect = {
-- 		["FL"] = "FL",
-- 		["FR"] = "FR",
-- 	},
--
-- 	-- Don't connect to speakers if there are bluetooth headphones plugged in
-- 	unless = Constraint({ "object.path", "matches", "bluez_output.*" }),
-- })
--
-- -- Auto connect the stereo null sink to bluetooth headphones
-- auto_connect_ports({
-- 	output = Constraint({ "object.path", "matches", "stereo-null-sink:*" }),
-- 	input = Constraint({ "object.path", "matches", "bluez_output.*" }),
-- 	connect = {
-- 		["FL"] = "FL",
-- 		["FR"] = "FR",
-- 	},
-- })
