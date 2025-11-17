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
					return (
						<This this={app}>
							<Bar gdkmonitor={monitor} />
						</This>
					);
				}}
			</For>
		);
	},
});
