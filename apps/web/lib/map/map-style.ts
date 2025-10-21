import type {
	FillLayerSpecification,
	LineLayerSpecification,
	StyleSpecification,
	SymbolLayerSpecification,
} from "maplibre-gl";

export const MAP_STYLE: StyleSpecification = {
	version: 8,
	glyphs: "https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf",
	sources: {
		osm: {
			type: "raster",
			tiles: ["https://a.tile.openstreetmap.org/{z}/{x}/{y}.png"],
			tileSize: 256,
			maxzoom: 19,
			attribution: "© OpenStreetMap contributors",
		},
		terrainSource: {
			type: "raster-dem",
			tiles: [
				"https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png",
			],
			tileSize: 256,
			maxzoom: 15,
			encoding: "terrarium",
			attribution: "Terrain data © AWS Terrain Tiles",
		},
		hillshadeSource: {
			type: "raster-dem",
			tiles: [
				"https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png",
			],
			tileSize: 256,
			maxzoom: 15,
			encoding: "terrarium",
			attribution: "Terrain data © AWS Terrain Tiles",
		},
	},
	layers: [
		{
			id: "osm",
			type: "raster",
			source: "osm",
		},
		{
			id: "hills",
			type: "hillshade",
			source: "hillshadeSource",
			layout: {
				visibility: "visible",
			},
			paint: {
				"hillshade-shadow-color": "#473B24",
			},
		},
	],
	terrain: {
		source: "terrainSource",
		exaggeration: 1,
	},
};

export const MAP_STYLE_NO_HILLSIDE: StyleSpecification = {
	version: 8,
	glyphs: "https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf",
	sources: {
		osm: {
			type: "raster",
			tiles: ["https://a.tile.openstreetmap.org/{z}/{x}/{y}.png"],
			tileSize: 256,
			maxzoom: 19,
			attribution: "© OpenStreetMap contributors",
		},
		terrainSource: {
			type: "raster-dem",
			tiles: [
				"https://s3.amazonaws.com/elevation-tiles-prod/terrarium/{z}/{x}/{y}.png",
			],
			tileSize: 256,
			maxzoom: 15,
			encoding: "terrarium",
			attribution: "Terrain data © AWS Terrain Tiles",
		},
	},
	layers: [
		{
			id: "osm",
			type: "raster",
			source: "osm",
		},
	],
	terrain: {
		source: "terrainSource",
		exaggeration: 1,
	},
};
export const areaFillLayer: FillLayerSpecification = {
	id: "areas-fill",
	type: "fill",
	source: "areas",
	paint: {
		"fill-color": "#4ecdc4",
		"fill-opacity": 0.4,
	},
};

export const areaHoverLayer: FillLayerSpecification = {
	id: "areas-hover",
	type: "fill",
	source: "areas",
	paint: {
		"fill-color": "#ff4500",
		"fill-opacity": 0.2,
	},
	filter: ["==", ["get", "id"], ""],
};

export const areaOutlineLayer: LineLayerSpecification = {
	id: "areas-outline",
	type: "line",
	source: "areas",
	paint: {
		"line-color": "#2c3e50",
		"line-width": 2,
	},
};

export const areaLabelLayer: SymbolLayerSpecification = {
	id: "areas-labels",
	type: "symbol",
	source: "areas",
	layout: {
		"text-field": ["get", "name"],
		"text-size": 14,
		"text-offset": [0, 0],
	},
	paint: {
		"text-color": "#ffffff",
		"text-halo-color": "#000000",
		"text-halo-width": 2,
	},
};

export const areaSelectedLayer: FillLayerSpecification = {
	id: "areas-selected",
	type: "fill",
	source: "areas",
	paint: {
		"fill-color": "#ffd700",
		"fill-opacity": 0.4,
	},
	filter: ["==", ["get", "id"], ""],
};

export const areaAvalancheDangerOutlineLayer: LineLayerSpecification = {
	id: "areas-avalanche-danger-outline",
	type: "line",
	source: "areas",
	paint: {
		"line-color": "#ff0000",
		"line-width": 3,
	},
	filter: ["==", ["get", "avalancheDanger"], true],
};
