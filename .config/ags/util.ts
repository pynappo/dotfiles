export type Coordinates = {
  x: number;
  y: number;
};
export function coordinateEquals(a: Coordinates, b: Coordinates) {
  return a.x == b.x && a.y == b.y;
}
