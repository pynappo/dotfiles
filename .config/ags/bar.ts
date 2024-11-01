const hyprland = await Service.import("hyprland");
const applications = await Service.import("applications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");
const network = await Service.import("network");

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
// console.log(icon_names, icon_binaries);

let cache = {};
// wine classes are not reliable so we don't index by classname
let wine_cache = {};
function escapePath(path: string) {
  return path.replaceAll("\\", "/").replaceAll(" ", "\\ ");
}
function isWindowsExe(pid: number) {
  // full cmd/args
  const cmd = Utils.exec(`ps -q ${pid} -o args=`);
  const cwd = Utils.exec(`readlink -e /proc/${pid}/cwd/`);
  if (cmd.match(/^\w:[\\]/)) {
    const matches = cmd.match(/\\.*\\(.+?\.exe)/);
    return matches ? escapePath(matches[0]) : false;
  }
  const matches = (cwd + "/" + cmd).match(/[\\\/].*[\\\/](.+?\.exe)/);
  return matches ? escapePath(matches[0]) : false;
}

const icons_path = "/tmp/ags/icons/";
Utils.exec(`mkdir ${icons_path} -p`);

function getIcon(client: Client) {
  const clientClass = client.class || client.initialClass;
  if (!clientClass) return "";

  // check cache
  let icon = cache[clientClass] || wine_cache[client.pid];
  if (icon) return icon;

  // check exe icon file
  const exe = isWindowsExe(client.pid);
  if (exe) {
    // steam games have consistent class names so we use those
    if (clientClass.match(/^steam/) && clientClass !== "steam_app_0") {
      cache[clientClass] = clientClass;
      return clientClass;
    }

    // fetch icon from cmd
    const extracted_icon_path = escapePath(
      `${icons_path}${client.initialTitle.replaceAll(" ", "_") || client.pid}.ico`,
    );
    const extract_cmd = `bash -c "wrestool -x -t 14 ${exe} > ${extracted_icon_path}"`;
    Utils.exec(extract_cmd);
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
  const query_result = applications.query(clientClass)[0];
  if (query_result) {
    console.log(`query for ${client.initialClass}: ${query_result}`);
    icon = query_result["icon-name"];
    cache[clientClass] = icon;
    return icon;
  }
  console.log(client);

  console.log("couldn't find class for " + client);
  // const icon = Utils.lookUpIcon(clientClass);
  cache[clientClass] = clientClass;
  return clientClass;
}

function Workspaces(workspace_ids: number[]) {
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
          attribute: { id, urgent: false },
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: "workspace",
          setup: (self) => {
            self.hook(hyprland.active, () => {
              //unset urgent if ws gets focus
              if (hyprland.active.workspace.id === id)
                self.attribute.urgent = false;
              self.toggleClassName(
                "active",
                Boolean(
                  active_workspaces.find((ws) => {
                    return id == ws.id;
                  }),
                ),
              );
              self.toggleClassName(
                "focused",
                Boolean(
                  active_workspaces.find((ws) => {
                    return id == ws.id && ws.focused;
                  }),
                ),
              );
              self.toggleClassName(
                "occupied",
                (hyprland.getWorkspace(id)?.windows || 0) > 0,
              );
              self.toggleClassName("urgent", self.attribute.urgent);
            });
            self.hook(
              hyprland,
              (_, address) => {
                //set urgent on ws containing the urgent window
                if (
                  hyprland.getClient(address)?.workspace.id == self.attribute.id
                ) {
                  self.attribute.urgent = true;
                  self.toggleClassName("urgent", self.attribute.urgent);
                }
              },
              "urgent-window",
            );
          },
        }),
      );
    },
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}

function Windows(monitor = 0) {
  const windows = hyprland.bind("clients").as((clients) => {
    return clients
      .filter(
        (client) =>
          client.monitor === monitor &&
          !client.hidden &&
          !client.tags.includes("hidden*"),
      )
      .sort((a, b) => {
        return a.workspace.id - b.workspace.id;
      })
      .map((client) => {
        const windowtitle =
          client.title ||
          client.initialTitle ||
          client.class ||
          client.initialClass ||
          `(PID ${client.pid})`;

        const menu = Widget.Menu({
          children: [
            Widget.MenuItem({
              label: "Close window",
            }),
            Widget.MenuItem({
              label: "Close window",
              onActivate: () => {
                hyprland.messageAsync(`dispatch closewindow pid:${client.pid}`);
              },
            }),
          ],
        });
        const label = Widget.Label({
          className: "windowtitle",
          truncate: "end",
          maxWidthChars: 30,
          label: windowtitle,
        });

        return Widget.Button({
          onPrimaryClick: () => {
            hyprland.messageAsync(`dispatch workspace ${client.workspace.id}`);
          },
          onMiddleClick: () => {
            hyprland.messageAsync(`dispatch closewindow pid:${client.pid}`);
          },
          onSecondaryClick: (_, event) => {
            menu.popup_at_pointer(event);
          },
          className: "window",
          child: Widget.Box({
            children: [
              Widget.Icon({
                className: "windowicon",
                icon: getIcon(client),
              }),
              label,
            ],
          }),
          setup: (self) => {
            self.hook(hyprland, () => {
              const visible = Boolean(
                hyprland.monitors.find(
                  (monitor) =>
                    client.workspace.id === monitor.activeWorkspace.id,
                ),
              );
              label.set_max_width_chars(visible ? 40 : 15);
              self.toggleClassName("visible", visible);
              self.toggleClassName(
                "focused",
                hyprland.active.monitor.id === client.monitor,
              );
            });
          },
        });
      });
  });
  return Widget.Box({
    class_name: "windows",
    children: windows,
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

function Media(monitor = 0) {
  function format_track_artist_and_label(mpris) {
    if (mpris.players[0]?.track_title) {
      const { track_artists, track_title } = mpris.players[0];
      console.log(track_artists, track_title);
      return `${track_artists[0] ? track_artists.join(", ") + " - " : ""}${track_title}`;
    } else {
      return "Nothing is playing";
    }
  }
  const label = Utils.watch(
    format_track_artist_and_label(mpris),
    mpris,
    "player-changed",
    () => {
      return format_track_artist_and_label(mpris);
    },
  );

  return Widget.Button({
    class_name: "media",
    // on_primary_click: () => mpris.getPlayer("")?.playPause(),
    on_primary_click: () => App.toggleWindow(`media-popup-${monitor}`),
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

  // const slider = Widget.Slider({
  //   hexpand: true,
  //   draw_value: false,
  //   on_change: ({ value }) => (audio.speaker.volume = value),
  //   setup: (self) =>
  //     self.hook(audio.speaker, () => {
  //       self.value = audio.speaker.volume || 0;
  //     }),
  // });
  const circle = Widget.CircularProgress({
    value: audio.speaker.bind("volume").as((v) => {
      return v;
    }),
  });

  const label = Widget.Label({
    label: audio.speaker
      .bind("volume")
      .as((volume_percent) => `${Math.trunc(volume_percent * 100)}%`),
  });

  return Widget.Box({
    class_name: "volume",
    children: [circle, label, icon],
  });
}

function Battery() {
  const value = battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0));
  const icon = battery
    .bind("percent")
    .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`);

  return Widget.Box({
    class_name: "battery",
    visible: battery.bind("available"),
    children: [
      // Widget.Icon({ icon }),
      Widget.Label({
        label: battery.bind("percent").as((p) => `${p}%`),
      }),
      Widget.CircularProgress({
        visible: battery.bind("available"),
        value: battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0)),
        class_name: "batterycircle",
        setup: (self) => {
          self.hook(battery, () => {
            self.toggleClassName("charging", battery.charging);
          });
        },
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
    class_name: "systray",
    children: items,
  });
}

const WifiIndicator = () =>
  Widget.Box({
    children: [
      Widget.Icon({
        icon: network.wifi.bind("icon_name"),
      }),
      Widget.Label({
        label: network.wifi.bind("ssid").as((ssid) => ssid || "Unknown"),
      }),
    ],
  });

const WiredIndicator = () =>
  Widget.Icon({
    icon: network.wired.bind("icon_name"),
  });

const Network = () =>
  Widget.Stack({
    children: {
      wifi: WifiIndicator(),
      wired: WiredIndicator(),
    },
    shown: network.bind("primary").as((p) => p || "wifi"),
  });

export function Bar(monitor = 0, workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) {
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
        children: [
          SysTray(),
          Network(),
          Battery(),
          Volume(),
          Media(monitor),
          Clock(),
        ],
      }),
    }),
  });
}
