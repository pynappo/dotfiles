import { Gtk, Gdk } from "ags/gtk4";
import Hyprland from "gi://AstalHyprland";

export interface Coordinates {
	x: number;
	y: number;
}
export function coordinateEquals(a: Coordinates, b: Coordinates): boolean {
	return a.x == b.x && a.y == b.y;
}

export function wsOnMonitor(a: Hyprland.Workspace, b: Gdk.Monitor): boolean {
	if (!b.model) {
		return false;
	}
	return coordinateEquals(a.monitor, b.geometry);
}

export function toggleclass(
	widget: Gtk.Widget,
	css_class: string,
	force: boolean | null,
): void {
	var should_add_css_class =
		force != null ? force : !widget.has_css_class(css_class);
	should_add_css_class
		? widget.add_css_class(css_class)
		: widget.remove_css_class(css_class);
}
