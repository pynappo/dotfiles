import { App } from "astal/gtk3";
import style from "./main.scss";
import Bar from "./examples/simple-bar/widget/Bar";
import NotificationPopups from "./examples/notifications/notifications/NotificationPopups";
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
    App.get_monitors().map(Bar);
    App.get_monitors().map(NotificationPopups);
  },
});
