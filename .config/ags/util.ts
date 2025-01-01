import { type Subscribable } from "astal/binding";
import Gtk from "gi://Gtk?version=3.0";

export type Coordinates = {
	x: number;
	y: number;
};
export function coordinateEquals(a: Coordinates, b: Coordinates) {
	return a.x == b.x && a.y == b.y;
}

export class VarMap<K, T = Gtk.Widget> implements Subscribable {
	#subs = new Set<(v: Array<[K, T]>) => void>();
	#map: Map<K, T>;

	#notify() {
		const value = this.get();
		for (const sub of this.#subs) {
			sub(value);
		}
	}

	#delete(key: K) {
		const v = this.#map.get(key);

		if (v instanceof Gtk.Widget) {
			v.destroy();
		}

		this.#map.delete(key);
	}

	constructor(initial?: Iterable<[K, T]>) {
		this.#map = new Map(initial);
	}

	set(key: K, value: T) {
		this.#delete(key);
		this.#map.set(key, value);
		this.#notify();
	}

	delete(key: K) {
		this.#delete(key);
		this.#notify();
	}

	get() {
		return [...this.#map.entries()];
	}

	subscribe(callback: (v: Array<[K, T]>) => void) {
		this.#subs.add(callback);
		return () => this.#subs.delete(callback);
	}
}
//
// const shell_map: { [key: string]: string[] } = {
// 	["bash"]: ["bash", "-c"],
// 	["fish"]: ["fish", "-c"],
// };
//
// export function shell(
// 	shell: "bash" | "fish",
// 	cmd: string | string[],
// ): string[] {
// 	const final_cmd = shell_map[shell];
// 	cmd = typeof cmd == "string" ? cmd : cmd.join(" ");
// 	cmd = cmd.replaceAll('"', '\\"');
// 	cmd = `"${cmd}"`;
// 	return final_cmd.concat([cmd]);
// }
