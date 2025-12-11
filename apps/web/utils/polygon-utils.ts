/**
 * Ensure a polygon ring is closed (first point equals last point)
 */
export function closePolygonRing(
  points: { lat: number; lng: number }[],
): [number, number][] {
  const ring: [number, number][] = points.map((p) => [p.lng, p.lat]);
  if (ring.length > 0) {
    const first = ring[0];
    const last = ring[ring.length - 1];
    if (first[0] !== last[0] || first[1] !== last[1]) {
      ring.push(first);
    }
  }
  return ring;
}

/**
 * Create a hole ring from polygon points with reversed winding order
 * Holes should be clockwise if outer ring is counter-clockwise
 */
export function createHoleRing(
  points: { lat: number; lng: number }[],
): [number, number][] {
  const ring = closePolygonRing(points);
  return ring.reverse();
}

/**
 * Build a GeoJSON Polygon with the outer ring and optional holes
 */
export function buildPolygonCoordinates(
  outerPoints: { lat: number; lng: number }[],
  holePointsArray: { lat: number; lng: number }[][],
): [number, number][][] {
  const outerRing = closePolygonRing(outerPoints);
  const holeRings = holePointsArray.map((holePoints) =>
    createHoleRing(holePoints),
  );
  return [outerRing, ...holeRings];
}
