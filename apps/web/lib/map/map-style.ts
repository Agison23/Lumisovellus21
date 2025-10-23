import type {
	FillLayerSpecification,
	HillshadeLayerSpecification,
	LineLayerSpecification,
	StyleSpecification,
	SymbolLayerSpecification,
} from "mapbox-gl";

export const MAP_STYLE: StyleSpecification = {
	version: 8,
	glyphs: "https://fonts.openmaptiles.org/{fontstack}/{range}.pbf",
	sources: {
		"mapbox-streets": {
			type: "vector",
			url: "mapbox://mapbox.mapbox-streets-v8",
		},
		terrainSource: {
			type: "raster-dem",
			url: "mapbox://mapbox.mapbox-terrain-dem-v1",
			tileSize: 512,
			maxzoom: 14,
		},
	},
	layers: [
		{
			id: "background",
			type: "background",
			paint: {
				"background-color": "#f5f5f5",
			},
		},
		{
			id: "water",
			type: "fill",
			source: "mapbox-streets",
			"source-layer": "water",
			paint: {
				"fill-color": "#b0d4ff",
			},
		},
		{
			id: "landuse",
			type: "fill",
			source: "mapbox-streets",
			"source-layer": "landuse",
			paint: {
				"fill-color": "#e0ddd9",
				"fill-opacity": 0.5,
			},
		},
		{
			id: "roads",
			type: "line",
			source: "mapbox-streets",
			"source-layer": "road",
			paint: {
				"line-color": "#fff",
				"line-width": 1,
			},
		},
	],
	terrain: {
		source: "terrainSource",
		exaggeration: 1.5,
	},
};

export const MAP_STYLE_NO_HILLSIDE: StyleSpecification = {
	version: 8,
	glyphs: "https://fonts.openmaptiles.org/{fontstack}/{range}.pbf",
	sources: {
		"mapbox-streets": {
			type: "vector",
			url: "mapbox://mapbox.mapbox-streets-v8",
		},
	},
	layers: [
		{
			id: "background",
			type: "background",
			paint: {
				"background-color": "#f5f5f5",
			},
		},
		{
			id: "water",
			type: "fill",
			source: "mapbox-streets",
			"source-layer": "water",
			paint: {
				"fill-color": "#b0d4ff",
			},
		},
		{
			id: "landuse",
			type: "fill",
			source: "mapbox-streets",
			"source-layer": "landuse",
			paint: {
				"fill-color": "#e0ddd9",
				"fill-opacity": 0.5,
			},
		},
		{
			id: "roads",
			type: "line",
			source: "mapbox-streets",
			"source-layer": "road",
			paint: {
				"line-color": "#fff",
				"line-width": 1,
			},
		},
	],
};

/**
 * Mapbox satellite style with terrain data source for use with react-map-gl.
 * The satellite basemap is loaded via the mapStyle prop on the Map component,
 * but the terrain source configuration needs to be added separately.
 *
 * Usage:
 * 1. Pass "mapbox://styles/mapbox/{style}" as the mapStyle prop
 * 2. Add a Source component with id="mapbox-dem" and type="raster-dem"
 * 3. Pass terrain configuration to the Map component
 *
 * For a fully declarative approach with react-map-gl, use the Source component
 * to add the terrain data source.
 */
export const TERRAIN_SOURCE_CONFIG = {
	id: "mapbox-dem",
	type: "raster-dem" as const,
	url: "mapbox://mapbox.mapbox-terrain-dem-v1",
	tileSize: 512,
	maxzoom: 14,
};

export const TERRAIN_CONFIG = {
	source: "mapbox-dem",
	exaggeration: 1.5,
};
export const areaFillLayer: FillLayerSpecification = {
	id: "areas-fill",
	type: "fill",
	source: "areas",
	paint: {
		"fill-color": "#ffffff",
		"fill-opacity": 0.1,
	},
};

export const areaHoverLayer: FillLayerSpecification = {
	id: "areas-hover",
	type: "fill",
	source: "areas",
	paint: {
		"fill-color": "#ffffff",
		"fill-opacity": 0.3,
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
		"line-opacity": 0.5,
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
		"fill-color": "#000000",
		"fill-opacity": 0.2,
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

export const hillshadeLayer: HillshadeLayerSpecification = {
	id: "hillshade",
	source: "mapbox-dem",
	type: "hillshade",
	paint: {
		"hillshade-exaggeration": 0.5,
	},
};
