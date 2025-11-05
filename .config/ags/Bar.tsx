import {
	Accessor,
	For,
	createBinding,
	createComputed,
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
import { toggleclass, wsOnMonitor } from "./util";
import { createPoll } from "ags/time";
import { execAsync } from "ags/process";
import GLib from "gi://GLib";
import app from "ags/gtk4/app";
const apps = new AstalApps.Apps({
	nameMultiplier: 2,
	entryMultiplier: 2,
	executableMultiplier: 2,
});
let class_to_icon: { [key: string]: string } = {};
for (const app of apps.list) {
	class_to_icon[app.wm_class] = app.icon_name;
}

const hyprland = AstalHyprland.get_default();
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

	return (
		<image
			tooltipText={createBinding(wifi, "ssid").as(String)}
			class="Wifi"
			iconName={createBinding(wifi, "iconName")}
		/>
	);
}

function AudioSlider() {
	const speaker = AstalWp.get_default()?.audio.defaultSpeaker!;

	return (
		<box class="AudioSlider" css="min-width: 140px">
			<image iconName={createBinding(speaker, "volumeIcon")} />
			<slider
				hexpand
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

let [urgentClients, setUrgentClients] = createState<{ [key: string]: boolean }>(
	{},
);
let [urgentWorkspaces, setUrgentWorkspaces] = createState<{
	[key: number]: number;
}>({});
hyprland.connect("urgent", (_, client) => {
	let c = urgentClients.get();
	let w = urgentWorkspaces.get();
	c[client.address] = true;
	if (w[client.workspace.id] == null) {
		w[client.workspace.id] = 0;
	}
	w[client.workspace.id]++;
	setUrgentClients(c);
	setUrgentWorkspaces(w);
});

hyprland.connect("client-removed", (_, client) => {
	let c = urgentClients.get();
	delete c[client];
	setUrgentClients(c);
});
hyprland.connect("workspace-removed", (_, id) => {
	let w = urgentWorkspaces.get();
	delete w[id];
	setUrgentWorkspaces(w);
});

const monitors = createBinding(app, "monitors");
const sticky_workspace_ids_per_monitor_count: number[][][] = [
	[],
	[[1, 2, 3, 4, 5, 6, 7, 8]],
	[
		[1, 3, 5, 7],
		[2, 4, 6, 8],
	],
];

function Workspaces({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const real_workspace_ids = createBinding(hyprland, "workspaces").as(
		(workspaces) => {
			return workspaces
				.filter((ws) => wsOnMonitor(ws, gdkmonitor))
				.map((ws) => ws.id);
		},
	);

	const sticky_workspace_ids = monitors((ms) => {
		let idx = -1;
		for (let i = 0; i < ms.length; i++) {
			const m = ms[i];
			if (m.connector == gdkmonitor.connector) {
				idx = i;
				break;
			}
		}
		const ids = sticky_workspace_ids_per_monitor_count[ms.length];
		return ids[idx];
	});
	const ids = createComputed(
		[real_workspace_ids, sticky_workspace_ids],
		(r, s) => {
			return [...new Set([...r, ...s])].sort((a, b) => a - b);
		},
	);
	return (
		<box class="Workspaces">
			<For each={ids}>
				{(id) => {
					const workspace = hyprland.get_workspace(id);
					if (!workspace) {
						return (
							<button
								class={"Workspace"}
								onClicked={() => hyprland.dispatch("workspace", String(id))}
							>
								<box>
									<image />
									{id}
								</box>
							</button>
						);
					}
					const on_focused_workspace = createBinding(
						hyprland,
						"focusedWorkspace",
					).as(() => {
						return workspace.id == workspace.monitor.activeWorkspace.id;
					});
					return (
						<button
							class={"Workspace"}
							onClicked={() => workspace.focus()}
							$={(self) => {
								toggleclass(
									self,
									"focused",
									hyprland.focused_workspace.id == workspace.id,
								);
								toggleclass(self, "visible", on_focused_workspace.get());
							}}
						>
							<box>
								<image
									iconName={createBinding(workspace, "last_client").as(
										(client) => {
											return getClientIcon(client);
										},
									)}
								/>
								{workspace.name}
							</box>
						</button>
					);
				}}
			</For>
		</box>
	);
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
	let visible = createBinding(hyprland, "focusedWorkspace").as(() => {
		return client.workspace.id == client.monitor.activeWorkspace.id;
	});
	if (!client.title) {
		return <></>;
	}
	return (
		<button
			// onDestroy={() => {
			// 	connections.forEach((n) => hyprland.disconnect(n));
			// 	disconnectors.forEach((d) => d());
			// }}
			class={"Client"}
		>
			<box>
				<image iconName={getClientIcon(client)} />
				<label
					maxWidthChars={visible.as((v) => (v ? 20 : 10))}
					label={createBinding(client, "title")}
				/>
			</box>
		</button>
	);
}
function Clients({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
	const workspaces = createBinding(hyprland, "workspaces").as((workspaces) => {
		return workspaces.sort((a, b) => a.id - b.id);
	});
	return (
		<box class="Clients">
			<For each={workspaces}>
				{(workspace) => {
					const clients = createBinding(workspace, "clients");
					return (
						<box
							class={"WorkspaceClients"}
							visible={wsOnMonitor(workspace, gdkmonitor)}
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

const idle_inhibited = createPoll(false, 2000, inhibitList, (stdout, prev) => {
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
					let inhibited = idle_inhibited.get();
					if (!inhibited) {
						execAsync(inhibitCmd).catch(console.error);
					} else {
						execAsync(`pkill ${inhibitCmd[0]}`).catch(console.error);
					}
				}}
			>
				<image iconName={inhibited_icon} />
			</button>
		</box>
	);
}

export default function Bar({
	gdkmonitor,
	sticky_workspace_ids,
}: {
	gdkmonitor: Gdk.Monitor;
	sticky_workspace_ids: number[];
}) {
	let win: Astal.Window;
	const { BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;
	const { EXCLUSIVE } = Astal.Exclusivity;

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
