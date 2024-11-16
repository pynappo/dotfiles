import { App, Widget, Astal, Gdk } from "astal/gtk3";
import { exec, execAsync, Variable, bind } from "astal";

import Hyprland from "gi://AstalHyprland";

const hyprland = Hyprland.get_default();
import Battery from "gi://AstalBattery";

const battery = Battery.get_default();
import Apps from "gi://AstalApps";

const applications = new Apps.Apps({
  nameMultiplier: 2,
  entryMultiplier: 0,
  executableMultiplier: 2,
});
import Mpris from "gi://AstalMpris";
import Wp from "gi://AstalWp";

const audio = Wp.get_default()!.audio;
import Tray from "gi://AstalTray";

const systray = Tray.get_default();
import Network from "gi://AstalNetwork";

const network = Network.get_default();

const date = Variable("").poll(1000, 'date "+%H:%M:%S, %b %e"');

// yoinked from https://github.com/mierak/dotfiles/blob/8493da8e3440a7bf96c1848aed3ddf60b4669cd9/.config/ags/src/utils.ts#L47

function escapePath(path: string) {
  return path.replaceAll("\\", "/").replaceAll(" ", "\\ ");
}
function isWindowsExe(pid: number) {
  // full cmd/args
  const cmd = exec(`ps -q ${pid} -o args=`);
  const cwd = exec(`readlink -e /proc/${pid}/cwd/`);
  if (cmd.match(/^\w:[\\]/)) {
    const matches = cmd.match(/\\.*\\(.+?\.exe)/);
    return matches ? escapePath(matches[0]) : false;
  }
  const matches = (cwd + "/" + cmd).match(/[\\\/].*[\\\/](.+?\.exe)/);
  return matches ? escapePath(matches[0]) : false;
}

const icons_path = "/tmp/ags/icons/";
exec(`mkdir ${icons_path} -p`);

const icon_cache: { [key: string]: string } = {};
// wine classes are not reliable so we don't index by classname
const wine_cache: { [key: string]: string } = {};

function getIcon(client: Hyprland.Client, fallback?: string) {
  if (!Boolean(client) || client === undefined) return fallback;
  console.log({
    title: client.title,
    class: client.class,
  });
  const clientClass = client.class || client.initialClass;

  // check cache
  let icon = icon_cache[clientClass] || wine_cache[client.pid];
  if (icon) return icon;

  // check exe icon file
  const exe = isWindowsExe(client.pid);
  if (exe) {
    // steam games have consistent class names so we use those
    if (clientClass.match(/^steam/) && clientClass !== "steam_app_0") {
      icon_cache[clientClass] = clientClass;
      return clientClass;
    }

    // fetch icon from cmd
    const extracted_icon_path = escapePath(
      `${icons_path}${client.initialTitle.replaceAll(" ", "_") || client.pid}.ico`,
    );
    const extract_cmd = `bash -c "wrestool -x -t 14 ${exe} > ${extracted_icon_path}"`;
    exec(extract_cmd);
    wine_cache[client.pid] = extracted_icon_path;
    return extracted_icon_path;
  }

  // query applications service
  const query_result = applications.fuzzy_query(clientClass)[0];
  if (query_result) {
    console.log(`query for ${client.initialClass}: ${query_result}`);
    icon = query_result.iconName;
    icon_cache[clientClass] = icon;
    return icon;
  }
  console.log(client);

  console.log("couldn't find class for " + client);
  // const icon = Utils.lookUpIcon(clientClass);
  icon_cache[clientClass] = clientClass;
  return clientClass;
}

const workspace_fallback_icons = [
  "",
  "headset-symbolic", // 1
  "web-browser-symbolic",
  "terminal-symbolic",
  "terminal-symbolic",
  "totem-tv-symbolic",
  "xbox-controller-symbolic",
  "tool-circle-symbolic",
  "tool-circle-symbolic",
  "tool-circle-symbolic",
  "tool-circle-symbolic",
];

function Workspaces(monitor: Gdk.Monitor, sticky_workspaces: number[]) {
  const workspaces = <box className="workspaces">
    {
      
    }
  </box>


// function Workspaces(main_workspace_ids: number[]) {
//   const workspaces = 
//       bind(hyprland, "workspaces").as(
//         (workspaces) => new Map(workspaces.map((ws) => [ws.id, ws])),
//       );
//       const monitors = bind(hyprland, "monitors");
//     const WorkspaceSection = (workspaces, monitors) => {
//       const active_workspaces = monitors.map((monitor) => {
//         return {
//           id: monitor.activeWorkspace.id,
//           focused: monitor.focused,
//         };
//       });
//       console.log(icon_cache);
//       return main_workspace_ids.map((id) => {
//         const ws = workspaces.get(id);
//         return new Widget.Button({
//           attribute: { id, urgent: false },
//           on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
//           child: new Widget.Box({
//             children: [
//               new Widget.Icon({
//                 className: "windowicon",
//                 icon: getIcon(
//                   hyprland.get_client(ws?.lastwindow || ""),
//                   workspace_fallback_icons[id],
//                 ),
//               }),
//               new Widget.Label(`${id}`),
//             ],
//           }),
//           className: "workspace",
//           setup: (self) => {
//             self.hook(hyprland.active, () => {
//               //unset urgent if ws gets focus
//               if (hyprland.active.workspace.id === id)
//                 self.attribute.urgent = false;
//               self.toggleClassName(
//                 "active",
//                 Boolean(
//                   active_workspaces.find((ws) => {
//                     return id == ws.id;
//                   }),
//                 ),
//               );
//               self.toggleClassName(
//                 "focused",
//                 Boolean(
//                   active_workspaces.find((ws) => {
//                     return id == ws.id && ws.focused;
//                   }),
//                 ),
//               );
//               self.toggleClassName(
//                 "occupied",
//                 (hyprland.get_workspace(id)?.windows || 0) > 0,
//               );
//               self.toggleClassName("urgent", self.attribute.urgent);
//             });
//             self.hook(
//               hyprland,
//               (_, address) => {
//                 //set urgent on ws containing the urgent window
//                 if (
//                   hyprland.get_client(address)?.workspace.id ==
//                   self.attribute.id
//                 ) {
//                   self.attribute.urgent = true;
//                   self.toggleClassName("urgent", self.attribute.urgent);
//                 }
//               },
//               "urgent-window",
//             );
//           },
//         });
//       });
//     },
//   );
//
//   return new Widget.Box({
//     className: "workspaces",
//     children: workspaces,
//   });
}

function Windows(monitor = 0) {
  const windows = bind(hyprland,"clients").as((clients) => {
    console.log({ icon_cache });
    return clients
      .filter(
        (client) =>
          client.monitor.id === monitor &&
          // !client.hidden &&
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

        // const menu = Widget.Menu({
        //   children: [
        //     Widget.MenuItem({
        //       label: "Close window",
        //     }),
        //     Widget.MenuItem({
        //       label: "Close window",
        //       onActivate: () => {
        //         hyprland.message_async(
        //           `dispatch closewindow pid:${client.pid}`,
        //         );
        //       },
        //     }),
        //   ],
        // });
        const label = <label label={windowtitle} className="windowtitle" truncate={ true } maxWidthChars={40} />

        return <button className="client" setup={(self) => {

            self.hook(bind(hyprland, "clients"), () => {
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
                hyprland.get_focused_monitor().id === client.monitor.id,
              );
            });
                  }>
          <box>
            <icon icon={getIcon(client)}/>
          </box>
        </button>
      });
  });
  return new Widget.Box({
    className: "windows",
    children: windows,
  });
}
function Clock() {
  return new Widget.Button({
    className: "clock",
    child: new Widget.Box({
      children: [
        Widget.Label({
          label: date.bind(),
        }),
      ],
    }),
  });
}

function Media(monitor = 0) {
  function format_track_artist_and_label(Mpris) {
    if (Mpris.players[0]?.track_title) {
      const { track_artists, track_title } = Mpris.players[0];
      console.log(track_artists, track_title);
      return `${track_artists[0] ? track_artists.join(", ") + " - " : ""}${track_title}`;
    } else {
      return "Nothing is playing";
    }
  }
  const label = Utils.watch(
    format_track_artist_and_label(Mpris),
    Mpris,
    "player-changed",
    () => {
      return format_track_artist_and_label(Mpris);
    },
  );

  return new Widget.Button({
    className: "media",
    // on_primary_click: () => Mpris.Player("")?.playPause(),
    on_primary_click: () => App.toggleWindow(`media-popup-${monitor}`),
    on_scroll_up: () => Mpris.Player("")?.next(),
    on_scroll_down: () => Mpris.Player("")?.previous(),
    child: new Widget.Label({
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

  const icon = new Widget.Icon({
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
  const circle = new Widget.CircularProgress({
    value: audio.speaker.bind("volume").as((v) => {
      return v;
    }),
  });

  const label = new Widget.Label({
    label: audio.speaker
      .bind("volume")
      .as((volume_percent) => `${Math.trunc(volume_percent * 100)}%`),
  });

  return new Widget.Box({
    className: "volume",
    children: [circle, label, icon],
  });
}

function BatteryIndicator() {
  const value = battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0));
  const icon = battery
    .bind("percent")
    .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`);

  return new Widget.Box({
    className: "battery",
    visible: battery.bind("available"),
    children: [
      // Widget.Icon({ icon }),
      new // Widget.Icon({ icon }),
      Widget.Label({
        label: battery.bind("percent").as((p) => `${p}%`),
      }),
      new Widget.CircularProgress({
        visible: battery.bind("available"),
        value: battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0)),
        className: "batterycircle",
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
  return <box>
        {bind(systray, "items").as(items => items.map(item => {
            if (item.iconThemePath)
                App.add_icons(item.iconThemePath)

            const menu = item.create_menu()

            return <button
                tooltipMarkup={bind(item, "tooltipMarkup")}
                onDestroy={() => menu?.destroy()}
                onClickRelease={self => {
                    menu?.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
                }}>
                <icon gIcon={bind(item, "gicon")} />
            </button>
        }))}
    </box>
}

    const { wifi, wired } = Network.get_default()
function Wifi() {

    return <icon
        tooltipText={bind(wifi, "ssid").as(String)}
        className="Wifi"
        icon={bind(wifi, "iconName")}
    />
}

const Wired= () =>
  <icon icon={bind(wired, "iconName")}/>

const NetworkIndicator = () =>
  new Widget.Stack({
    children: [ Wifi(), Wired() ],
  });

export default function Bar(monitor:Gdk.Monitor, workspaces = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) {
    const anchor = Astal.WindowAnchor.TOP
        | Astal.WindowAnchor.LEFT
        | Astal.WindowAnchor.RIGHT

    return <window
        className="Bar"
        gdkmonitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={anchor}>
        <centerbox>
            <box hexpand halign={Gtk.Align.START}>
                <Workspaces />
                <FocusedClient />
            </box>
            <box>
                <Media />
            </box>
            <box hexpand halign={Gtk.Align.END} >
                <SysTray />
                <Wifi />
                <AudioSlider />
                <BatteryLevel />
                <Time />
            </box>
        </centerbox>
    </window>
}
  return new Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    className: "bar",
    monitor,
    anchor: Astal.WindowAnchor.BOTTOM,
    exclusivity: Astal.Exclusivity.EXCLUSIVE,
    child: new Widget.CenterBox({
      start_widget: new Widget.Box({
        spacing: 8,
        children: [Workspaces(workspaces)],
      }),
      center_widget: new Widget.Box({
        spacing: 8,
        children: [Windows(monitor)],
      }),
      // end_widget: Widget.Box({
      //   hpack: "end",
        spacing: 8,
        children: [
          SysTray(),
          NetworkIndicator(),
          BatteryIndicator(),
          Volume(),
          Media(monitor),
          Clock(),
        ],
      }),
    }),
  });
}
