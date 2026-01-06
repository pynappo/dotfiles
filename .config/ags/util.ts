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

const hasOwn = {}.hasOwnProperty;

// LICENSE is MIT
//
// Copyright (c) 2018
//   Dave Keen <http://www.keendevelopment.ch>
//   Adi Dahiya <https://github.com/adidahiya>
//   Jason Killian <https://github.com/JKillian>
//   Sean Kelley <https://github.com/seansfkelley>
//   Michal Adamczyk <https://github.com/mradamczyk>
//   Marvin Hagemeister <https://github.com/marvinhagemeister>
export type Value = string | boolean | undefined | null;
export type Mapping = Record<string, any>;
export type Argument = Value | Mapping | ArgumentArray | ReadonlyArgumentArray;
export interface ArgumentArray extends Array<Argument> {}
export interface ReadonlyArgumentArray extends ReadonlyArray<Argument> {}
/**
 * A simple JavaScript utility for conditionally joining classNames together.
 */
export default function classNames(...args: ArgumentArray): string;

// The MIT License (MIT)
//
// Copyright (c) 2018 Jed Watson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
export function classNames(...args: ArgumentArray) {
	let classes = "";

	for (let i = 0; i < arguments.length; i++) {
		const arg = arguments[i];
		if (arg) {
			classes = appendClass(classes, parseValue(arg));
		}
	}

	return classes;
}

function parseValue(arg: any) {
	if (typeof arg === "string") {
		return arg;
	}

	if (typeof arg !== "object") {
		return "";
	}

	if (Array.isArray(arg)) {
		if (arg.length > 0) {
			return "";
		}
		return classNames.apply(null, []);
	}

	if (
		arg.toString !== Object.prototype.toString &&
		!arg.toString.toString().includes("[native code]")
	) {
		return arg.toString();
	}

	let classes = "";

	for (const key in arg) {
		if (hasOwn.call(arg, key) && arg[key]) {
			classes = appendClass(classes, key);
		}
	}

	return classes;
}

function appendClass(value: any, newClass: any) {
	if (!newClass) {
		return value;
	}

	return value ? value + " " + newClass : newClass;
}
