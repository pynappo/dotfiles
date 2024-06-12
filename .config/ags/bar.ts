const hyprland = await Service.import("hyprland");
const applications = await Service.import("applications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");
import { type Client } from "./types/service/hyprland";

const date = Variable("", {
  poll: [1000, 'date "+%H:%M:%S, %b %e"'],
});

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

// yoinked from https://github.com/mierak/dotfiles/blob/8493da8e3440a7bf96c1848aed3ddf60b4669cd9/.config/ags/src/utils.ts#L47
const { icon_names, icon_binaries } = applications.list.reduce(
  (acc, app) => {
    const name = app["icon-name"];
    if (name) {
      acc.icon_names.add(name);
      acc.icon_binaries[app.executable] = name;
    }
    return acc;
  },
  {
    icon_names: new Set(),
    icon_binaries: {},
  },
);
console.log(icon_names, icon_binaries);

let cache = {};
// wine classes are not reliable so we don't index by classname
let wine_cache = {};
function escapePath(path: string) {
  return path.replaceAll("\\", "/").replaceAll(" ", "\\ ");
}
function isWindowsExe(pid: number) {
  // full cmd/args
  const cmd = Utils.exec(`ps -q ${pid} -o args=`);
  const matches = cmd.match(/[\\].*[\\](\w+\.exe)/);
  console.log(matches);
  return matches ? escapePath(matches[0]) : false;
}

const icon_path = "/tmp/ags/icons/";
Utils.exec(`mkdir ${icon_path} -p`);
function getIcon(client: Client) {
  const clientClass = client.initialClass;
  if (!clientClass) return "";

  // check cache
  let icon = cache[clientClass];
  if (icon) return icon;

  // check if it's wine
  const exe = isWindowsExe(client.pid);
  if (exe) {
    if (wine_cache[client.pid]) return wine_cache[client.pid];
    // fetch icon from cmd
    const extracted_icon_path = escapePath(
      `${icon_path}${client.initialTitle.replaceAll(" ", "_") || client.pid}.ico`,
    );
    const extract_cmd = `bash -c "wrestool -x -t 14 ${exe} > ${extracted_icon_path}"`;
    console.log(extract_cmd);
    console.log(Utils.exec(extract_cmd));
    wine_cache[client.pid] = extracted_icon_path;
    return extracted_icon_path;
  }

  // search by icon name
  icon = icon_names.has(clientClass) ? clientClass : false;
  if (icon) {
    cache[clientClass] = icon;
    return icon;
  }

  // search by binary
  const binary_name = Utils.exec(`ps -p ${client.pid} -o comm=`);
  icon = icon_binaries[binary_name];
  if (icon) {
    cache[clientClass] = icon;
    return icon;
  }

  // query applications service
  const query_result = applications.query(client.initialClass)[0];
  if (query_result) {
    console.log(`query for ${client.initialClass}: ${query_result}`);
    icon = query_result["icon-name"];
    cache[clientClass] = icon;
    return icon;
  }

  console.log("couldn't find class for " + client);
  return client.initialClass;
}

function Workspaces(workspace_ids: Number[]) {
  const workspaces = Utils.merge(
    [Variable(workspace_ids).bind(), hyprland.bind("monitors")],
    (ids, monitors) => {
      const active_workspaces = monitors.map((monitor) => {
        return {
          id: monitor.activeWorkspace.id,
          focused: monitor.focused,
        };
      });
      return ids.map((id) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name:
            (active_workspaces.find((active_ws) => active_ws.id === id)
              ? "active"
              : "") +
            (active_workspaces.find(
              (active_ws) => active_ws.id === id && active_ws.focused,
            )
              ? " focused"
              : ""),
        }),
      );
    },
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}

// function ClientTitle() {
//   return Widget.Label({
//     class_name: "client-title",
//     label: hyprland.active.client.bind("title"),
//   });
// }

function Windows(monitor = 0) {
  const window_titles = hyprland.bind("clients").as((clients) => {
    return clients
      .filter((client) => client.monitor === monitor && !client.hidden)
      .map((client) => {
        return Widget.Button({
          on_clicked: () =>
            hyprland.messageAsync(`dispatch workspace ${client.workspace.id}`),
          child: Widget.Box({
            children: [
              Widget.Icon({
                className: "windowicon",
                icon: getIcon(client),
              }),
              Widget.Label({
                className: "windowtitle",
                truncate: "end",
                maxWidthChars: 30,
                label: client.title,
              }),
            ],
          }),
        });
      });
  });
  return Widget.Box({
    class_name: "windows",
    children: window_titles,
  });
}
function Clock() {
  return Widget.Button({
    class_name: "clock",
    child: Widget.Box({
      children: [
        Widget.Label({
          label: date.bind(),
        }),
      ],
    }),
  });
}

function Media() {
  const label = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0];
      return `${track_artists[0] ? track_artists.join(", ") + "- " : ""}${track_title}`;
    } else {
      return "Nothing is playing";
    }
  });

  return Widget.Button({
    class_name: "media",
    on_primary_click: () => mpris.getPlayer("")?.playPause(),
    on_scroll_up: () => mpris.getPlayer("")?.next(),
    on_scroll_down: () => mpris.getPlayer("")?.previous(),
    child: Widget.Label({
      truncate: "end",
      maxWidthChars: 40,
      label,
    }),
  });
}

function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  function getIcon() {
    const icon = audio.speaker.is_muted
      ? 0
      : [101, 67, 34, 1, 0].find(
          (threshold) => threshold <= audio.speaker.volume * 100,
        );

    return `audio-volume-${icons[icon!!]}-symbolic`;
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => (audio.speaker.volume = value),
    setup: (self) =>
      self.hook(audio.speaker, () => {
        self.value = audio.speaker.volume || 0;
      }),
  });

  const label = Widget.Label({
    label: audio.speaker
      .bind("volume")
      .as((volume_percent) => `${Math.trunc(volume_percent * 100)}%`),
  });

  return Widget.Box({
    class_name: "volume",
    css: "min-width: 140px",
    children: [icon, slider, label],
  });
}

function BatteryLabel() {
  const value = battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0));
  const icon = battery
    .bind("percent")
    .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`);

  return Widget.Box({
    class_name: "battery",
    visible: battery.bind("available"),
    children: [
      Widget.Icon({ icon }),
      Widget.LevelBar({
        widthRequest: 140,
        vpack: "center",
        value,
      }),
    ],
  });
}

function SysTray() {
  const items = systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon") }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      }),
    ),
  );

  return Widget.Box({
    children: items,
  });
}

// layout of the bar

function Bar(monitor = 0, workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) {
  return Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["bottom", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Widget.Box({
        spacing: 8,
        children: [Workspaces(workspaces)],
      }),
      center_widget: Widget.Box({
        spacing: 8,
        children: [Windows(monitor)],
      }),
      end_widget: Widget.Box({
        hpack: "end",
        spacing: 8,
        children: [SysTray(), Volume(), Media(), Clock()],
      }),
    }),
  });
}

export { Bar };
