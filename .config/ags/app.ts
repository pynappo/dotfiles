import { App, Gdk, Gtk } from "astal/gtk3";
import { bind, GLib } from "astal";
import style from "./main.scss";
import barstyle from "./Bar.scss";
import Bar from "./Bar";
import NotificationPopups from "./NotificationPopups";

// https://specifications.freedesktop.org/icon-theme-spec/latest/#icon_lookup
const E = GLib.getenv;
// for (const dir of E("XDG_DATA_DIRS")?.split(" ") || []) {
//   App.add_icons(`${dir}/.icons`);
// }
// App.add_icons("/usr/share/pixmaps");

// https://www.reddit.com/r/archlinux/comments/10b8t89/question_how_to_set_a_fallback_icon_theme/
const path = `${E("XDG_DATA_HOME")}/icons/hicolor/32x32/apps`;
App.add_icons(path);
const a = Gtk.IconTheme.get_default();
const { FORCE_SYMBOLIC, GENERIC_FALLBACK, USE_BUILTIN } = Gtk.IconLookupFlags;
App.start({
	css: style,
	instanceName: "astal",
	requestHandler(request, res) {
		print(request);
		res("ok");
	},
	main: () => {
		const notifications = new Map<Gdk.Monitor, Gtk.Widget>();

		// initialize
		reset_bars();
		for (const gdkmonitor of App.get_monitors()) {
			notifications.set(gdkmonitor, NotificationPopups(gdkmonitor));
		}

		App.connect("monitor-added", (_, gdkmonitor) => {
			reset_bars();
			notifications.set(gdkmonitor, NotificationPopups(gdkmonitor));
		});

		App.connect("monitor-removed", (_, gdkmonitor) => {
			reset_bars();
			notifications.get(gdkmonitor)?.destroy();
			notifications.delete(gdkmonitor);
		});
	},
});

const bars = new Map<Gdk.Monitor, Gtk.Widget>();
function reset_bars() {
	const monitors = App.get_monitors();

	for (const bar of bars) {
		bar[1].destroy();
	}
	bars.clear();
	if (monitors.length == 2) {
		bars.set(monitors[0], Bar(monitors[0], [1, 3, 5, 7]));
		bars.set(monitors[1], Bar(monitors[1], [2, 4, 6, 8]));
	} else {
		bars.set(monitors[0], Bar(monitors[0], [1, 2, 3, 4, 5, 6, 7, 8]));
	}
}
