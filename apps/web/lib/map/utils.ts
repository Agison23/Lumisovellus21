// takes in {lat: number, lng: number}[] and returns area
export function calculatePolygonArea(
  points: { lat: number; lng: number }[]
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
