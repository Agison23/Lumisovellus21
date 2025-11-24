import { Monitor } from "./types";

export function formatValueToString(
	value: string | number | null | undefined,
	unit?: string
): string {
	if (value === null || value === undefined || value === "") {
		return "Not available";
	}

	const num = parseFloat(String(value));
	if (isNaN(num)) {
		return "Not available";
	}

	return unit ? `${num.toFixed(2)} ${unit}` : num.toFixed(2);
}

export function formatValueToObject(
	value: number | null | undefined,
	unit?: string
): { value: number; unit: string } | "No Data" {
	if (value === null || value === undefined) {
		return "No Data";
	}

	const num = parseFloat(String(value));
	if (isNaN(num)) {
		return "No Data";
	}

	return {
		value: num,
		unit: unit || "",
	};
}

export function mergeMonitors(
	defaults: Monitor[],
	fetched: Monitor[]
): Monitor[] {
	const merged = defaults.map((defaultMonitor) => {
		const match = fetched.find((f) => f.name === defaultMonitor.name);
		return match ? { ...defaultMonitor, ...match } : defaultMonitor;
	});

	fetched.forEach((fetchedMonitor) => {
		if (!merged.some((m) => m.name === fetchedMonitor.name)) {
			merged.push(fetchedMonitor);
		}
	});

	return merged;
}

export function isWithinBounds(
	lat: number,
	lng: number,
	bounds: [[number, number], [number, number]]
): boolean {
	const [minLng, minLat] = bounds[0];
	const [maxLng, maxLat] = bounds[1];
	return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
}
