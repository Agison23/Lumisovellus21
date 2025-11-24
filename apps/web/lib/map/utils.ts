export function calculatePolygonArea(coordinates: number[][]): number {
	// Shoelace formula for polygon area
	// Note: This gives area in "degree squares" - only useful for comparison
	let area = 0;
	const n = coordinates.length;

	for (let i = 0; i < n - 1; i++) {
		const [lon1, lat1] = coordinates[i];
		const [lon2, lat2] = coordinates[i + 1];
		area += (lon2 - lon1) * (lat2 + lat1);
	}

	return Math.abs(area) / 2;
}
