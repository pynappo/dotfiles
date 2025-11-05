import { createBinding, For, This } from "ags";
import app from "ags/gtk4/app";
import style from "./main.scss";
import Bar from "./Bar";
import SampleBar from "./widget/SampleBar";
import NotificationPopups from "./NotificationPopups";

app.start({
	css: style,
	gtkTheme: "adw-gtk3-dark",
	main() {},
});

app.start({
	css: style,
	// It's usually best to go with the default Adwaita theme
	// and built off of it, instead of allowing the system theme
	// to potentially mess something up when it is changed.
	// Note: `* { all:unset }` in css is not recommended.
	gtkTheme: "Adwaita",
	requestHandler: (argv, res: (response: any) => void) => {
		if (argv[0] == "myfunction") {
			res("hello");
		}
		res("unknown command");
	},
	main: () => {
		const monitors = createBinding(app, "monitors");
		NotificationPopups();

		return (
			<For each={monitors}>
				{(monitor, i) => {
					var stickies = [1, 2, 3, 4, 5, 6, 7, 8];
					if (monitors.length == 2) {
						if (i.get() === 0) {
							stickies = [1, 3, 5, 7];
						} else {
							stickies = [2, 4, 6, 8];
						}
					}
					return (
						<This this={app}>
							<Bar gdkmonitor={monitor} sticky_workspace_ids={stickies} />
						</This>
					);
				}}
			</For>
		);
	},
});
