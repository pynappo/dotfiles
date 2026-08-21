maki.setup({
	always_yolo = true,
	ui = {
		theme = "ayu_mirage",
	},
})
maki.keymap.set("n", "<C-f>", function()
	maki.ui.action("file_picker")
end)
