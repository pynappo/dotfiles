import { Variable, GLib, bind, execAsync, Binding, GObject } from "astal";
import { App, Astal, Gtk, Gdk } from "astal/gtk3";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";
import AstalApps from "gi://AstalApps?version=0.1";
import { coordinateEquals } from "./util";
import { VarMap } from "./util";
const apps = new AstalApps.Apps({
	nameMultiplier: 2,
	entryMultiplier: 2,
	executableMultiplier: 2,
});
var class_to_icon: { [key: string]: string } = {};
for (const app of apps.list) {
	class_to_icon[app.wm_class] = app.icon_name;
}

const hyprland = Hyprland.get_default();
hyprland.connect("event", (_, event, args) => {
	console.log("[hyprland]:", event, args);
});
hyprland.connect("event", (_, event, args) => {});
bind(hyprland, "monitors").subscribe(() => {
	console.log("monitors updated");
});
bind(hyprland, "workspaces").subscribe(() => {
	console.log("workspaces updated");
});
bind(hyprland, "clients").subscribe(() => {
	console.log("clients updated");
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
		<box className="Battmery" visible={bind(bat, "isPresent")}>
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

var urgent_clients = new Variable<{ [key: string]: boolean }>({});
var urgent_workspaces = new Variable<{ [key: number]: number }>({});
hyprland.connect("urgent", (_, client) => {
	let c = urgent_clients.get();
	let w = urgent_workspaces.get();
	c[client.address] = true;
	if (w[client.workspace.id] == null) {
		w[client.workspace.id] = 0;
	}
	w[client.workspace.id]++;
	urgent_clients.set(c);
	urgent_workspaces.set(w);
});
bind(hyprland, "focused_client").subscribe((client) => {
	let c = urgent_clients.get();
	let w = urgent_workspaces.get();
	if (c[client.address]) {
		c[client.address] = false;
		w[client.workspace.id]--;
	}
	urgent_clients.set(c);
	urgent_workspaces.set(w);
});
hyprland.connect("client-removed", (_, client) => {
	let c = urgent_clients.get();
	delete c[client];
	urgent_clients.set(c);
});
hyprland.connect("workspace-removed", (_, id) => {
	let w = urgent_workspaces.get();
	delete w[id];
	urgent_workspaces.set(w);
});
urgent_workspaces.subscribe(() => {
	console.log("urgent workspaces updated");
});
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
									className={"Workspace empty"}
									onClicked={() => hyprland.dispatch("workspace", String(id))}
								>
									<box>
										<icon />
										{id}
									</box>
								</button>
							);
						const visible = bind(hyprland, "focusedWorkspace").as(() => {
							return ws.id == ws.monitor.activeWorkspace.id;
						});
						if (!coordinateEquals(ws.monitor, gdkmonitor.geometry))
							return <></>;
						var urgent_handler = -1;
						var disconnectors: { (): any }[] = [];
						return (
							<button
								className={"Workspace"}
								onClicked={() => ws.focus()}
								setup={(self) => {
									disconnectors.push(
										bind(hyprland, "focused_workspace").subscribe((focused) => {
											self.toggleClassName("focused", focused.id === ws.id);
										}),
									);
									disconnectors.push(
										urgent_workspaces.subscribe((urgent) => {
											self.toggleClassName("urgent", urgent[ws.id] > 0);
										}),
									);
									disconnectors.push(
										bind(visible).subscribe((v) => {
											self.toggleClassName("visible", v);
										}),
									);
									self.toggleClassName(
										"focused",
										hyprland.focused_workspace.id == ws.id,
									);
									self.toggleClassName("visible", visible.get());
								}}
								onDestroy={() => {
									hyprland.disconnect(urgent_handler);
									disconnectors.forEach((d) => {
										d();
									});
								}}
							>
								<box>
									<icon
										icon={bind(ws, "last_client").as((client) => {
											return getClientIcon(client);
										})}
									/>
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
	const classIcon = class_to_icon[clientClass];
	if (classIcon) {
		cache[client.pid] = classIcon;
		return classIcon;
	}
	var results = apps.fuzzy_query(clientClass);
	if (results.length == 0) {
		results = apps.fuzzy_query(client.title);
	}
	const iconName = results?.[0]?.iconName || clientClass;
	cache[client.pid] = iconName;
	return iconName;
}

function Client(client: Hyprland.Client) {
	var connections: number[] = [];
	var visible = bind(hyprland, "focusedWorkspace").as(() => {
		return client.workspace.id == client.monitor.activeWorkspace.id;
	});
	var disconnectors: { (): any }[] = [];
	return (
		<button
			onClick={() => {
				client.workspace.focus();
			}}
			setup={(self) => {
				self.hook(hyprland, "notify::focused-client", (self) => {
					if (hyprland.focused_client?.pid === client.pid) {
						self.toggleClassName("urgent", false);
					}
				});
				disconnectors.push(
					urgent_clients.subscribe((urgent) => {
						console.log("urgent clients:", urgent);
						self.toggleClassName("visible", urgent[client.address]);
					}),
				);
				disconnectors.push(
					bind(visible).subscribe((v) => {
						self.toggleClassName("visible", v);
					}),
				);
				disconnectors.push(
					bind(hyprland, "focused_client").subscribe((focused) => {
						self.toggleClassName("focused", client == focused);
					}),
				);
				self.toggleClassName("visible", visible.get());
				self.toggleClassName("focused", hyprland.focused_client == client);
			}}
			onDestroy={() => {
				connections.forEach((n) => hyprland.disconnect(n));
				disconnectors.forEach((d) => d());
				delete cache[client.pid];
			}}
			className={"Client"}
		>
			<box>
				<icon icon={getClientIcon(client)} />
				<label
					maxWidthChars={bind(visible).as((v) => (v ? 20 : 10))}
					label={bind(client, "title")}
					truncate={true}
				/>
			</box>
		</button>
	);
}
function Clients({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	return (
		<box className="Clients">
			{bind(hyprland, "workspaces").as((workspaces) => {
				return workspaces
					.sort((a, b) => a.id - b.id)
					.map((workspace) => {
						return (
							<box
								className={"WorkspaceClients"}
								visible={bind(workspace, "monitor").as((m) => {
									return coordinateEquals(m, gdkmonitor.geometry);
								})}
							>
								{bind(workspace, "clients").as((clients) => {
									return clients.map(Client);
								})}
							</box>
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
	const { START, END } = Gtk.Align;
	const { EXCLUSIVE } = Astal.Exclusivity;

	return (
		<window
			className="Bar"
			gdkmonitor={monitor}
			exclusivity={EXCLUSIVE}
			anchor={BOTTOM | LEFT | RIGHT}
			heightRequest={30}
		>
			<centerbox>
				<box hexpand halign={START}>
					<Workspaces
						gdkmonitor={monitor}
						sticky_workspace_ids={sticky_workspace_ids}
					/>
				</box>
				<box>
					<Clients gdkmonitor={monitor} />
				</box>
				<box hexpand halign={END}>
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
