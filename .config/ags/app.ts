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
    const monitors = App.get_monitors();
    const bars = new Map<Gdk.Monitor, Gtk.Widget>();

    // initialize
    for (const gdkmonitor of App.get_monitors()) {
      bars.set(gdkmonitor, Bar(gdkmonitor));
      NotificationPopups(gdkmonitor);
    }

    App.connect("monitor-added", (_, gdkmonitor) => {
      bars.set(gdkmonitor, Bar(gdkmonitor));
    });

    App.connect("monitor-removed", (_, gdkmonitor) => {
      bars.get(gdkmonitor)?.destroy();
      bars.delete(gdkmonitor);
    });
  },
});
