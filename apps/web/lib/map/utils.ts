// takes in {lat: number, lng: number}[] and returns area
export function calculatePolygonArea(
  points: { lat: number; lng: number }[],
): number {
  let area = 0;
  const n = points.length;
  // Shoelace formula for polygon area
  // Note: This gives area in "degree squares" - only useful for comparison
  for (let i = 0; i < n; i++) {
    const [p1, p2] = [points[i], points[(i + 1) % n]];
    area += (p2.lng - p1.lng) * (p2.lat + p1.lat);
  }
  return Math.abs(area) / 2;
}

// Check if a point is inside a polygon using ray casting algorithm
export function isPointInPolygon(
  point: { lat: number; lng: number },
  polygon: { lat: number; lng: number }[],
): boolean {
  let inside = false;
  const n = polygon.length;

  for (let i = 0, j = n - 1; i < n; j = i++) {
    const xi = polygon[i].lng,
      yi = polygon[i].lat;
    const xj = polygon[j].lng,
      yj = polygon[j].lat;

    if (
      yi > point.lat !== yj > point.lat &&
      point.lng < ((xj - xi) * (point.lat - yi)) / (yj - yi) + xi
    ) {
      inside = !inside;
    }
  }

  return inside;
}

// Check if polygon A is completely inside polygon B
// Uses centroid check - assumes polygons don't partially overlap
export function isPolygonInsidePolygon(
  innerPolygon: { lat: number; lng: number }[],
  outerPolygon: { lat: number; lng: number }[],
): boolean {
  // Check if the centroid of the inner polygon is inside the outer polygon
  const centroid = {
    lat: innerPolygon.reduce((sum, p) => sum + p.lat, 0) / innerPolygon.length,
    lng: innerPolygon.reduce((sum, p) => sum + p.lng, 0) / innerPolygon.length,
  };

  return isPointInPolygon(centroid, outerPolygon);
}
