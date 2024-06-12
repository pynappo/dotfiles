import { NotificationPopups } from "./notifications";
import { Bar } from "./bar";
const hyprland = await Service.import("hyprland");

// Utils.timeout(100, () =>
//   Utils.notify({
//     summary: "Notification Popup Example",
//     iconName: "info-symbolic",
//     body:
//       "Lorem ipsum dolor sit amet, qui minim labore adipisicing " +
//       "minim sint cillum sint consectetur cupidatat.",
//     actions: {
//       Cool: () => print("pressed Cool"),
//     },
//   }),
// );

App.config({
  style: App.configDir + "/style.css",
  windows: () => {
    if (hyprland.monitors.length > 1) {
      return [
        NotificationPopups(0),
        NotificationPopups(1),
        Bar(0, [1, 3, 5, 7, 9]),
        Bar(1, [2, 4, 6, 8, 10]),
      ];
    }
    return [NotificationPopups(), Bar(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])];
  },
});
