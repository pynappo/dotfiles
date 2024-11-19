import { App } from "astal/gtk3";
import style from "./main.scss";
import Bar from "./bar/Bar";
import NotificationPopups from "./notifications/NotificationPopups";
// import Bar from "./bar/Bar";
// import NotificationPopups from "./notifications/NotificationPopups";
// import Hyprland from "gi://AstalHyprland";
//
// const hyprland = Hyprland.get_default();
//
// App.start({
//   css: style,
//   instanceName: "js",
//   requestHandler(request, res) {
//     print(request);
//     res("ok");
//   },
//   main: () => {
//     App.get_monitors().map((monitor) => Bar(monitor));
//     App.get_monitors().map(NotificationPopups);
//   },
// });

App.start({
  css: style,
  instanceName: "js",
  requestHandler(request, res) {
    print(request);
    res("ok");
  },
  main: () => {
    const monitors = App.get_monitors();
    monitors.map(NotificationPopups);
    if (monitors.length == 1) {
      Bar(monitors[0], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
    }
    if (monitors.length == 2) {
      Bar(monitors[0], [1, 3, 5, 7, 9]);
      Bar(monitors[1], [2, 4, 6, 8, 10]);
    }
  },
});
