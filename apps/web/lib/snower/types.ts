export type Monitor = {
	lat: number;
	lng: number;
	name: string;
	temperature: string;
	snowDepth: string;
};

export type MonitorLocation = {
	lat: number;
	lng: number;
};

export type BoundingBox = {
	minLat: number;
	minLng: number;
	maxLat: number;
	maxLng: number;
};

export type SnowerAPIConfig = {
	bounds?: [[number, number], [number, number]];
	area?: string;
};

export type ReadingData = {
	probe_temperature?: {
		value: number;
		unit: string;
	};
	snow_depth?: {
		value: number;
		unit: string;
	};
};
