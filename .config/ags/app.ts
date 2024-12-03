import { App, Gdk, Gtk } from "astal/gtk3";
import { bind } from "astal";
import style from "./main.scss";
import barstyle from "./Bar.scss";
import Bar from "./Bar";
import NotificationPopups from "./NotificationPopups";

App.start({
  css: style,
  instanceName: "js",
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
