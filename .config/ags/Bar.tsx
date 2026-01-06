import {
	Accessor,
	For,
	With,
	createBinding,
	createComputed,
	createEffect,
	createState,
	onCleanup,
} from "ags";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import AstalHyprland from "gi://AstalHyprland";
import AstalPowerProfiles from "gi://AstalPowerProfiles";
import AstalMpris from "gi://AstalMpris";
import AstalBattery from "gi://AstalBattery";
import AstalWp from "gi://AstalWp";
import AstalNetwork from "gi://AstalNetwork";
import AstalTray from "gi://AstalTray";
import AstalApps from "gi://AstalApps?version=0.1";
import { classNames } from "./util";
import { createPoll } from "ags/time";
import { execAsync } from "ags/process";
import GLib from "gi://GLib";
import app from "ags/gtk4/app";
import Pango from "gi://Pango?version=1.0";

const apps = new AstalApps.Apps({
	nameMultiplier: 2,
	entryMultiplier: 2,
	executableMultiplier: 2,
});

let [urgentClients, setUrgentClients] = createState(new Map<string, boolean>());
let [urgentWorkspaces, setUrgentWorkspaces] = createState(
	new Map<number, number>(),
);
// hyprland.connect("event", (_, event, args) => {
// 	console.log("[hyprland]:", event, args);
// });
function SysTray() {
	const tray = AstalTray.get_default();
	const items = createBinding(tray, "items");

	const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
		btn.menuModel = item.menuModel;
		btn.insert_action_group("dbusmenu", item.actionGroup);
		item.connect("notify::action-group", () => {
			btn.insert_action_group("dbusmenu", item.actionGroup);
		});
	};

	return (
		<box>
			<For each={items}>
				{(item) => (
					<menubutton $={(self) => init(self, item)}>
						<image gicon={createBinding(item, "gicon")} />
					</menubutton>
				)}
			</For>
		</box>
	);
}

function Wifi() {
	const { wifi } = AstalNetwork.get_default();

	return wifi ? (
		<image
			tooltipText={createBinding(wifi, "ssid").as(String)}
			class="Wifi"
			iconName={createBinding(wifi, "iconName")}
		/>
	) : (
		<box></box>
	);
}

function AudioSlider() {
	const speaker = AstalWp.get_default()?.audio.defaultSpeaker!;

	return (
		<box class="AudioSlider" widthRequest={100}>
			<image iconName={createBinding(speaker, "volumeIcon")} />
			<slider
				onChangeValue={({ value }) => speaker.set_volume(value)}
				value={createBinding(speaker, "volume")}
			/>
		</box>
	);
}

function BatteryLevel() {
	const battery = AstalBattery.get_default();
	const powerprofiles = AstalPowerProfiles.get_default();

	const percent = createBinding(
		battery,
		"percentage",
	)((p) => `${Math.floor(p * 100)}%`);

	const setProfile = (profile: string) => {
		powerprofiles.set_active_profile(profile);
	};

	return (
		<menubutton visible={createBinding(battery, "isPresent")}>
			<box>
				<image iconName={createBinding(battery, "iconName")} />
				<label label={percent} />
			</box>
			<popover>
				<box orientation={Gtk.Orientation.VERTICAL}>
					{powerprofiles.get_profiles().map(({ profile }) => (
						<button onClicked={() => setProfile(profile)}>
							<label label={profile} xalign={0} />
						</button>
					))}
				</box>
			</popover>
		</menubutton>
	);
}

function Media() {
	const mpris = AstalMpris.get_default();
	const apps = new AstalApps.Apps();
	const players = createBinding(mpris, "players");

	return (
		<menubutton>
			<box>
				<For each={players}>
					{(player) => {
						const [app] = apps.exact_query(player.entry);
						return <image visible={!!app.iconName} iconName={app?.iconName} />;
					}}
				</For>
			</box>
			<popover>
				<box spacing={4} orientation={Gtk.Orientation.VERTICAL}>
					<For each={players}>
						{(player) => (
							<box spacing={4} widthRequest={200}>
								<box overflow={Gtk.Overflow.HIDDEN} css="border-radius: 8px;">
									<image
										pixelSize={64}
										file={createBinding(player, "coverArt")}
									/>
								</box>
								<box
									valign={Gtk.Align.CENTER}
									orientation={Gtk.Orientation.VERTICAL}
								>
									<label xalign={0} label={createBinding(player, "title")} />
									<label xalign={0} label={createBinding(player, "artist")} />
								</box>
								<box hexpand halign={Gtk.Align.END}>
									<button
										onClicked={() => player.previous()}
										visible={createBinding(player, "canGoPrevious")}
									>
										<image iconName="media-seek-backward-symbolic" />
									</button>
									<button
										onClicked={() => player.play_pause()}
										visible={createBinding(player, "canControl")}
									>
										<box>
											<image
												iconName="media-playback-start-symbolic"
												visible={createBinding(
													player,
													"playbackStatus",
												)((s) => s === AstalMpris.PlaybackStatus.PLAYING)}
											/>
											<image
												iconName="media-playback-pause-symbolic"
												visible={createBinding(
													player,
													"playbackStatus",
												)((s) => s !== AstalMpris.PlaybackStatus.PLAYING)}
											/>
										</box>
									</button>
									<button
										onClicked={() => player.next()}
										visible={createBinding(player, "canGoNext")}
									>
										<image iconName="media-seek-forward-symbolic" />
									</button>
								</box>
							</box>
						)}
					</For>
				</box>
			</popover>
		</menubutton>
	);
}

const sticky_workspace_ids_by_monitor_count: { [key: string]: number[] }[] = [
	{},
	{
		"DP-2": [1, 2, 3, 4, 5, 6, 7, 8],
	},
	{
		"DP-3": [2, 4, 6, 8],
		"DP-2": [1, 3, 5, 7],
	},
];

function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const hyprland = AstalHyprland.get_default();
	const hyprmonitor = createBinding(gdkmonitor, "connector").as((connector) => {
		const m = hyprland.get_monitors().find((m) => m.name === connector);
		return m;
	});
	const real_workspace_ids = createBinding(hyprland, "workspaces").as(
		(workspaces) => {
			return workspaces
				.filter((ws) => ws.monitor?.name === gdkmonitor.connector)
				.map((ws) => ws.id);
		},
	);

	const monitors = createBinding(app, "monitors");

	const sticky_workspace_ids = monitors((ms) => {
		const ids = sticky_workspace_ids_by_monitor_count[ms.length];
		return ids[gdkmonitor.connector];
	});
	const ids = createComputed(() =>
		[...new Set([...real_workspace_ids(), ...sticky_workspace_ids()])].sort(
			(a, b) => a - b,
		),
	);

	return (
		<box class="Workspaces">
			<For each={ids}>
				{(id) => {
					const workspace = createBinding(hyprland, "workspaces").as(() => {
						return hyprland.get_workspace(id) as
							| AstalHyprland.Workspace
							| undefined;
					});
					const on_focused_monitor = createBinding(
						hyprland,
						"focusedWorkspace",
					).as((focused) => focused && id === focused.id);
					const on_monitor = hyprmonitor.as(
						(hm) => hm && hm.active_workspace.id === id,
					);
					const sticky = sticky_workspace_ids.as((stickies) => {
						return stickies.includes(id);
					});
					const sticky_on_correct_monitor = createComputed(() => {
						if (!sticky()) {
							return false;
						}
						const ws = workspace();
						const hm = hyprmonitor();
						return ws && hm && ws.monitor.id == hm.id;
					});
					const urgent = urgentWorkspaces.as((urgents) => {
						const count = urgents.get(id);
						return count && count > 0;
					});
					return (
						<button
							class={createComputed(() => {
								return classNames("Workspace", {
									real: workspace(),
									visible: on_monitor(),
									sticky: sticky(),
									sticking_to_correct_monitor: sticky_on_correct_monitor(),
									focused: on_focused_monitor(),
									urgent: urgent(),
								});
							})}
							onClicked={() => {
								const ws = workspace();
								if (ws) {
									const hm = hyprmonitor();
									if (!hm) {
										throw new Error(
											`Could not find hyprmonitor for ${gdkmonitor.connector}`,
										);
									}
									if (ws.monitor.id !== hm.id) ws.move_to(hm);
									ws.focus();
								} else {
									hyprland.dispatch("workspace", String(id));
								}
							}}
						>
							<box>
								<box>
									<With value={workspace}>
										{(ws) => {
											if (!ws) {
												return <image />;
											}
											return (
												<image
													iconName={createBinding(ws, "last_client").as(
														getClientIcon,
													)}
												/>
											);
										}}
									</With>
								</box>
								{String(id)}
							</box>
						</button>
					);
				}}
			</For>
		</box>
	);
}

const class_to_icon: { [key: string]: string } = {};
for (const app of apps.list) {
	class_to_icon[app.wm_class] = app.icon_name;
}
const cache: { [key: number]: string } = {};
function getClientIcon(client?: AstalHyprland.Client): string {
	if (client === undefined || !Boolean(client)) return "";
	if (cache[client.pid]) return cache[client.pid];
	const clientClass = client.class || client.initialClass;
	const classIcon = class_to_icon[clientClass];
	if (classIcon) {
		cache[client.pid] = classIcon;
		return classIcon;
	}
	let results = apps.fuzzy_query(clientClass);
	if (results.length == 0) {
		results = apps.fuzzy_query(client.title);
	}
	const iconName = results?.[0]?.iconName || clientClass;
	cache[client.pid] = iconName;
	return iconName;
}

function Client(client: AstalHyprland.Client) {
	const hyprland = AstalHyprland.get_default();
	let on_monitor = createBinding(hyprland, "focusedWorkspace").as(() => {
		return client.workspace.id === client.monitor.activeWorkspace.id;
	});
	const on_focused_monitor = createBinding(hyprland, "focusedWorkspace").as(
		(ws) => {
			return ws.id == hyprland.focusedWorkspace.id;
		},
	);
	const urgent = urgentClients.as((urgents) =>
		Boolean(urgents.get(client.address)),
	);
	return (
		<button
			class={createComputed(() => {
				return classNames("Client", {
					urgent: urgent(),
					focused: on_focused_monitor(),
					visible: on_monitor(),
				});
			})}
			visible={createBinding(client, "title").as(Boolean)}
		>
			<box>
				<image iconName={getClientIcon(client)} />
				<label
					maxWidthChars={on_monitor.as((v) => (v ? 20 : 10))}
					ellipsize={Pango.EllipsizeMode.END}
					label={createBinding(client, "title")}
				/>
				<Gtk.GestureClick
					button={3}
					onPressed={() => {
						client.focus();
					}}
				/>
				<Gtk.GestureClick
					button={1}
					onPressed={() => {
						client.workspace.focus();
					}}
				/>
			</box>
		</button>
	);
}
function Clients({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const hyprland = AstalHyprland.get_default();
	const workspaces = createBinding(hyprland, "workspaces").as((workspaces) => {
		return workspaces.sort((a, b) => a.id - b.id);
	});
	const hyprmonitor = createBinding(gdkmonitor, "connector").as((connector) => {
		const m = hyprland.get_monitors().find((m) => m.name === connector);
		if (!m) {
			throw new Error(
				"Could not find corresponding hyprland monitor for " + connector,
			);
		}
		return m;
	});
	return (
		<box class="Clients">
			<For each={workspaces}>
				{(workspace) => {
					const clients = createBinding(workspace, "clients");
					return (
						<box
							class={"WorkspaceClients"}
							visible={createBinding(workspace, "monitor", "id").as((id) => {
								return id === hyprmonitor().id;
							})}
						>
							<For each={clients}>{Client}</For>
						</box>
					);
				}}
			</For>
		</box>
	);
}

function Time({ format = "%H:%M:%S" }) {
	const time = createPoll("", 1000, () => {
		return GLib.DateTime.new_now_local().format(format)!;
	});

	return (
		<menubutton>
			<label label={time} />
			<popover>
				<Gtk.Calendar />
			</popover>
		</menubutton>
	);
}

const inhibitList = ["bash", "-c", `./scripts/systemd-inhibit/list.sh`];
const inhibitCmd = ["bash", "-c", `./scripts/systemd-inhibit/inhibit.sh`];
const uninhibitCmd = ["bash", "-c", `./scripts/systemd-inhibit/uninhibit.sh`];

const idle_inhibited = createPoll(false, 5000, inhibitList, (stdout, _) => {
	try {
		const ags_inhibitor_found = stdout.indexOf("ags") > -1;
		return ags_inhibitor_found;
	} catch {
		return false;
	}
});
function Idle({}) {
	const inhibited_icon = idle_inhibited.as((inhibited) => {
		return inhibited ? "bed-symbolic" : "eye-open-negative-filled-symbolic";
	});
	return (
		<box class={"Idle"}>
			<button
				class={idle_inhibited.as((active) => {
					return active ? "test" : "";
				})}
				onClicked={() => {
					if (idle_inhibited()) {
						execAsync(uninhibitCmd).catch(console.error);
					} else {
						execAsync(inhibitCmd).catch(console.error);
					}
				}}
			>
				<image iconName={inhibited_icon} />
			</button>
		</box>
	);
}

let a = 0;
export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;
	const { EXCLUSIVE, NORMAL } = Astal.Exclusivity;
	const hyprland = AstalHyprland.get_default();
	const b = a++;
	console.log(`Bar ${b}`);
	hyprland.connect("urgent", (_, client) => {
		if (!client) return;
		{
			let c = urgentClients();
			console.log(client.address, "is urgent");
			c.set(client.address, true);
			setUrgentClients(c);
		}
		{
			let w = urgentWorkspaces();
			if (!w.has(client.workspace.id)) {
				w.set(client.workspace.id, 0);
			}

			const count = w.get(client.workspace.id);
			if (count) {
				w.set(client.workspace.id, count + 1);
			}
			setUrgentWorkspaces(w);
		}
	});

	const focusedClient = createBinding(hyprland, "focusedClient");
	createEffect(() => {
		const focused = focusedClient();
		if (focused) {
			{
				let c = urgentClients();
				c.set(focused.address, false);
				setUrgentClients(c);
			}
			{
				if (focused?.workspace?.id) {
					let w = urgentWorkspaces();

					const count = w.get(focused.workspace.id);
					if (count && count > 0) {
						w.set(focused.workspace.id, count - 1);
					}
					setUrgentWorkspaces(w);
				}
			}
		}
	});
	hyprland.connect("client-removed", (_, client_address) => {
		let c = urgentClients();
		c.delete(client_address);
		setUrgentClients(c);
	});
	hyprland.connect("workspace-removed", (_, id) => {
		let w = urgentWorkspaces();
		w.delete(id);
		setUrgentWorkspaces(w);
	});

	let win: Astal.Window;
	onCleanup(() => {
		// Root components (windows) are not automatically destroyed.
		// When the monitor is disconnected from the system, this callback
		// is run from the parent <For> which allows us to destroy the window
		win.destroy();
	});

	return (
		<window
			$={(self) => (win = self)}
			visible
			namespace="my-bar"
			name={`bar-${gdkmonitor.connector}`}
			class="Bar"
			gdkmonitor={gdkmonitor}
			exclusivity={EXCLUSIVE}
			anchor={BOTTOM | LEFT | RIGHT}
			heightRequest={30}
		>
			<centerbox>
				<box $type="start">
					<Workspaces gdkmonitor={gdkmonitor} />
				</box>
				<box $type="center">
					<Clients gdkmonitor={gdkmonitor} />
				</box>
				<box $type="end">
					<Media />
					<SysTray />
					<Idle />
					<Wifi />
					<AudioSlider />
					<BatteryLevel />
					<Time />
				</box>
			</centerbox>
		</window>
	);
}
