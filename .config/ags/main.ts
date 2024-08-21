import { NotificationPopups } from "./notifications";
import { Bar } from "./bar";
import { Media } from "./widgets/media";
const hyprland = await Service.import("hyprland");

App.config({
  style: App.configDir + "/main.css",
  windows: () => {
    if (hyprland.monitors.length > 1) {
      return [
        NotificationPopups(0),
        NotificationPopups(1),
        Bar(0, [1, 3, 5, 7, 9]),
        Bar(1, [2, 4, 6, 8, 10]),
        Media(0),
        Media(1),
      ];
    }
    return [NotificationPopups(), Bar(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])];
  },
});
