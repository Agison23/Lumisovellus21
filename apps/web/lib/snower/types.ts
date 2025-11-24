export type Monitor = {
	lat: number;
	lng: number;
	name: string;
	temperatureString: string;
	temperature:
		| {
				value: number;
				unit: string;
		  }
		| "No Data";

	snowDepthString: string;
	snowDepth:
		| {
				value: number;
				unit: string;
		  }
		| "No Data";
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
