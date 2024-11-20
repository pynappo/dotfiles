import { App } from "astal/gtk3";
import { Variable, GLib, bind, execAsync } from "astal";
import { Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";
import { coordinateEquals, Coordinates } from "../util";

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
  const hypr = Hyprland.get_default();

  return (
    <box className="Workspaces">
      {bind(hypr, "workspaces").as((workspaces) =>
        workspaces
          .filter((ws) => {
            return coordinateEquals(gdkmonitor.geometry, ws.monitor);
          })
          .sort((a, b) => a.id - b.id)
          .map((ws) => {
            var has_urgent_client = false;
            return (
              <button
                className={"Workspace"}
                onClicked={() => ws.focus()}
                setup={(self) => {
                  bind(hypr, "monitors").subscribe((monitors) => {
                    self.toggleClassName(
                      "visible",
                      Boolean(
                        monitors.find((m) => {
                          return m.get_active_workspace().id === ws.id;
                        }),
                      ),
                    );
                  });
                  bind(hypr, "focusedWorkspace").subscribe((fw) => {
                    self.toggleClassName("focused", ws === fw);
                    if (ws === fw) {
                      has_urgent_client = false;
                      self.toggleClassName("urgent", has_urgent_client);
                    }
                  });
                  hypr.connect("urgent", (_, client) => {
                    if (client.workspace == ws) has_urgent_client = true;
                    self.toggleClassName("urgent", has_urgent_client);
                  });
                }}
              >
                {ws.id}
              </button>
            );
          }),
      )}
    </box>
  );
}

const cache: { [key: number]: string } = {};
const wine_cache: { [key: number]: string } = {};
function getIcon(client: Hyprland.Client) {
  return client.class;
}

function Clients({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  const hypr = Hyprland.get_default();
  const clientsBinding = bind(hypr, "clients");

  return (
    <box className="clients">
      {clientsBinding.as((clients) => {
        return clients
          .filter((client) =>
            coordinateEquals(client.monitor, gdkmonitor.geometry),
          )
          .sort((a, b) => a.workspace.id - b.workspace.id)
          .map((client) => {
            var visible = bind(hypr, "monitors").as((monitors) => {
              return Boolean(
                monitors.find(
                  (m) => m.get_active_workspace().id == client.workspace.id,
                ),
              );
            });
            var urgent = false;
            var focusedClient = bind(hypr, "focusedClient");
            return (
              <button
                onClick={() => {
                  hypr.dispatch("workspace", `${client.workspace.id}`);
                }}
                setup={(self) => {
                  hypr.connect("urgent", (_, urgent_client) => {
                    if (client == urgent_client) urgent = true;
                    self.toggleClassName("urgent", urgent);
                  });
                  bind(focusedClient).as((focused) => {
                    self.toggleClassName("focused", client === focused);
                  });
                }}
              >
                <box>
                  <icon icon={getIcon(client)} />
                  <label
                    maxWidthChars={bind(visible).as((val) => {
                      return val ? 20 : 10;
                    })}
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
  const anchor =
    Astal.WindowAnchor.BOTTOM |
    Astal.WindowAnchor.LEFT |
    Astal.WindowAnchor.RIGHT;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
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
