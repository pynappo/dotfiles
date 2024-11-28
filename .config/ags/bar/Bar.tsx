import { Variable, GLib, bind, execAsync, Binding, GObject } from "astal";
import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";
import AstalApps from "gi://AstalApps?version=0.1";
import { coordinateEquals, Coordinates } from "../util";
const apps = AstalApps.Apps.new();

const hyprland = Hyprland.get_default();
hyprland.connect("event", (_, event, args) => {
  console.log("[hyprland]:", event, args);
});
hyprland.connect("event", (_, event, args) => {
  if (event === "workspacev2") {
    hyprland.notify("monitors");
  }
  if (event === "activewindowv2") {
    hyprland.notify("workspaces");
  }
});
bind(hyprland, "monitors").as(() => {
  console.log("monitors updated");
});
bind(hyprland, "workspaces").as(() => {
  console.log("workspaces updated");
});
function SysTray() {
  const tray = Tray.get_default();

  return (
    <box>
      {bind(tray, "items").as((items) =>
        items.map((item) => {
          if (item.iconThemePath) App.add_icons(item.iconThemePath);

          const menu = item.create_menu();

          return (
            <button
              tooltipMarkup={bind(item, "tooltipMarkup")}
              onDestroy={() => menu?.destroy()}
              onClickRelease={(self) => {
                menu?.popup_at_widget(
                  self,
                  Gdk.Gravity.SOUTH,
                  Gdk.Gravity.NORTH,
                  null,
                );
              }}
            >
              <icon gIcon={bind(item, "gicon")} />
            </button>
          );
        }),
      )}
    </box>
  );
}

function Wifi() {
  const { wifi } = Network.get_default();

  return (
    <icon
      tooltipText={bind(wifi, "ssid").as(String)}
      className="Wifi"
      icon={bind(wifi, "iconName")}
    />
  );
}

function AudioSlider() {
  const speaker = Wp.get_default()?.audio.defaultSpeaker!;

  return (
    <box className="AudioSlider" css="min-width: 140px">
      <icon icon={bind(speaker, "volumeIcon")} />
      <slider
        hexpand
        onDragged={({ value }) => (speaker.volume = value)}
        value={bind(speaker, "volume")}
      />
    </box>
  );
}

function BatteryLevel() {
  const bat = Battery.get_default();

  return (
    <box className="Battery" visible={bind(bat, "isPresent")}>
      <icon icon={bind(bat, "batteryIconName")} />
      <label
        label={bind(bat, "percentage").as((p) => `${Math.floor(p * 100)} %`)}
      />
    </box>
  );
}

function Media() {
  const mpris = Mpris.get_default();

  return (
    <box className="Media">
      {bind(mpris, "players").as((ps) =>
        ps[0] ? (
          <box>
            <box
              className="Cover"
              valign={Gtk.Align.CENTER}
              css={bind(ps[0], "coverArt").as(
                (cover) => `background-image: url('${cover}');`,
              )}
            />
            <label
              label={bind(ps[0], "title").as(
                () => `${ps[0].title} - ${ps[0].artist}`,
              )}
              maxWidthChars={20}
              truncate={true}
            />
          </box>
        ) : (
          "Nothing Playing"
        ),
      )}
    </box>
  );
}

function Workspaces({
  gdkmonitor,
  sticky_workspace_ids,
}: {
  gdkmonitor: Gdk.Monitor;
  sticky_workspace_ids: number[];
}) {
  const ids = bind(hyprland, "workspaces").as((workspaces) => {
    return [
      ...new Set([...workspaces.map((ws) => ws.id), ...sticky_workspace_ids]),
    ];
  });
  return (
    <box className="Workspaces">
      {bind(ids).as((ids) => {
        return ids
          .sort((a, b) => a - b)
          .map((id) => {
            const ws = hyprland.get_workspace(id);
            if (ws === null)
              return (
                <button
                  className={"Workspace"}
                  onClicked={() => hyprland.dispatch("workspace", String(id))}
                >
                  <box>
                    <icon icon={""} />
                    {id}
                  </box>
                </button>
              );
            if (!coordinateEquals(ws.monitor, gdkmonitor.geometry))
              return <></>;
            var visible = bind(hyprland, "monitors").as((monitors) => {
              return Boolean(
                monitors.find((m) => m.active_workspace.id == ws.id),
              );
            });
            var urgent_handler = -1;
            var disconnect = () => {};
            return (
              <button
                className={"Workspace"}
                onClicked={() => ws.focus()}
                setup={(self) => {
                  urgent_handler = hyprland.connect("urgent", (_, client) => {
                    if (client.workspace.id == ws.id) {
                      self.toggleClassName("urgent", true);
                    }
                  });
                  self.hook(hyprland, "notify::focused-workspace", (self) => {
                    const currentFocused =
                      hyprland.focused_workspace.id === ws.id;
                    if (currentFocused) {
                      self.toggleClassName("urgent", false);
                    }
                    self.toggleClassName("focused", currentFocused);
                  });
                  disconnect = bind(visible).subscribe((v) => {
                    self.toggleClassName("visible", v);
                  });
                }}
                onDestroy={() => {
                  hyprland.disconnect(urgent_handler);
                  disconnect();
                }}
              >
                <box>
                  <icon icon={getClientIcon(ws.get_last_client())} />
                  {ws.name}
                </box>
              </button>
            );
          });
      })}
    </box>
  );
}

const cache: { [key: number]: string } = {};
function getClientIcon(client?: Hyprland.Client): string {
  if (client === undefined || !Boolean(client)) return "";
  if (cache[client.pid]) return cache[client.pid];
  const clientClass = client.class || client.initialClass;
  const results = apps.fuzzy_query(clientClass);
  const iconName = results?.[0]?.iconName || clientClass;
  cache[client.pid] = iconName;
  return iconName;
}

function Clients({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const bindings = Variable.derive([
    bind(hyprland, "clients"),
    bind(hyprland, "monitors"),
  ]);
  return (
    <box className="Clients">
      {bind(hyprland, "clients").as((clients) => {
        return clients
          .filter(
            (client) =>
              client && coordinateEquals(client.monitor, gdkmonitor.geometry),
          )
          .sort((a, b) => a.workspace.id - b.workspace.id)
          .map((client) => {
            const visible = bind(hyprland, "monitors").as((monitors) => {
              return Boolean(
                monitors.find(
                  (m) => m.activeWorkspace.id === client.workspace.id,
                ),
              );
            });
            var urgent_handler: number;
            return (
              <button
                onClick={() => {
                  client.workspace.focus();
                }}
                setup={(self) => {
                  urgent_handler = hyprland.connect(
                    "urgent",
                    (_, urgent_client) => {
                      if (client == urgent_client) {
                        self.toggleClassName("urgent", true);
                      }
                    },
                  );
                  self.hook(hyprland, "notify::focused-client", (self) => {
                    if (hyprland.focused_client?.pid === client.pid) {
                      self.toggleClassName("urgent", false);
                    }
                  });
                }}
                onDestroy={() => {
                  hyprland.disconnect(urgent_handler);
                }}
                className={"Client"}
              >
                <box>
                  <icon icon={getClientIcon(client)} />
                  <label
                    maxWidthChars={bind(visible).as((val) => (val ? 20 : 10))}
                    label={bind(client, "title")}
                    truncate={true}
                  />
                </box>
              </button>
            );
          });
      })}
    </box>
  );
}

function Time({ format = "%F %X" }) {
  const time = Variable<string>("").poll(
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );

  return (
    <label className="Time" onDestroy={() => time.drop()} label={time()} />
  );
}

export default function Bar(
  monitor: Gdk.Monitor,
  sticky_workspace_ids: number[] = [],
) {
  const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={BOTTOM | LEFT | RIGHT}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Workspaces
            gdkmonitor={monitor}
            sticky_workspace_ids={sticky_workspace_ids}
          />
        </box>
        <box>
          <Clients gdkmonitor={monitor} />
        </box>
        <box hexpand halign={Gtk.Align.END}>
          <Media />
          <SysTray />
          <Wifi />
          <AudioSlider />
          <BatteryLevel />
          <Time />
        </box>
      </centerbox>
    </window>
  );
}
