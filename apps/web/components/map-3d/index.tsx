"use client"
import { useQuery } from "@tanstack/react-query";
import { FeatureCollection, Polygon } from "geojson";

import maplibregl, { FillLayerSpecification, LineLayerSpecification, MapLayerMouseEvent, SymbolLayerSpecification, type FilterSpecification } from "maplibre-gl";
import { useCallback, useMemo, useRef, useState } from "react";
import Map, {
	Layer,
	NavigationControl,
	Source,
	TerrainControl,

} from "react-map-gl/maplibre";
import { MAP_STYLE } from "@/lib/map/map-style";
import "maplibre-gl/dist/maplibre-gl.css";
import { InteractiveAreaFeature, InteractiveAreaProperties, mapAreas2 } from "@/lib/map/mock-data";

type MapProps = {
  areas: InteractiveAreaFeature[];
}


const areaFillLayer: FillLayerSpecification = {
  id: "areas-fill",
  type: "fill",
  source: "areas",
  paint: {
    'fill-color': "#4ecdc4",
    'fill-opacity': 0.4,
  }
}

const areaHoverLayer: FillLayerSpecification = {
	id: "areas-hover",
	type: "fill",
	source: "areas",
	paint: {
		"fill-color": "#ff4500",
		"fill-opacity": 0.2,
	},
	filter: ["==", ["get", "id"], ""],
};

const areaOutlineLayer: LineLayerSpecification = {
	id: "areas-outline",
	type: "line",
	source: "areas",
	paint: {
		"line-color": "#2c3e50",
		"line-width": 2,
	},
};

const areaLabelLayer: SymbolLayerSpecification = {
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

const areaSelectedLayer: FillLayerSpecification = {
    id: "areas-selected",
    type: "fill",
    source: "areas",
    paint: {
        "fill-color": "#ffd700",
        "fill-opacity": 0.4,
    },
    filter: ["==", ["get", "id"], ""],
};

const areaAvalancheDangerOutlineLayer: LineLayerSpecification = {
    id: "areas-avalanche-danger-outline",
    type: "line",
    source: "areas",
    paint: {
        "line-color": "#ff0000",
        "line-width": 3,
    },
    filter: ["==", ["get", "avalancheDanger"], true],
};

// for now, mock fetching areas from the API
const fetchAreas = async (): Promise<InteractiveAreaFeature[]> => {
  await new Promise(resolve => setTimeout(resolve, 500))
  return mapAreas2
}

function calculatePolygonArea(coordinates: number[][]): number {
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

export default function Map3d() {
  const [hoveredAreaId, setHoveredAreaId] = useState<string | null>(null)
  const [selectedArea, setSelectedArea] = useState<InteractiveAreaProperties | null>(null)
  const [isLoading, setIsLoading] = useState(true);
  const [showLoading, setShowLoading] = useState(true);
  const hasLoadedRef = useRef(false);
  const [popupInfo, setPopupInfo] = useState<
    | {
      longtitude: number;
      latitude: number;
      name: string;
    }
    | null
  >(null);

  const { data: areas = [] } = useQuery({
    queryKey: ['mapaAreas'],
    queryFn: fetchAreas,
    refetchInterval: 10000,
    staleTime: 5000
  })

  const areasGeoJson = useMemo<FeatureCollection<Polygon, InteractiveAreaProperties>>(
    () => ({
      type: "FeatureCollection",
      features: [...areas].sort((a, b) => {
        const areaA = calculatePolygonArea(a.geometry.coordinates[0]);
        const areaB = calculatePolygonArea(b.geometry.coordinates[0]);
        return areaB - areaA; // Descending order
      })
    }),
    [areas]
  );

  const hoverFilter = useMemo<FilterSpecification>(
    () => ["==", ["get", "id"], hoveredAreaId ?? ""] as FilterSpecification,
    [hoveredAreaId]
  )

  const selectedFilter = useMemo<FilterSpecification>(
    () => ["==", ["get", "id"], selectedArea?.id ?? ""] as FilterSpecification,
    [selectedArea]
  )

  const handleMouseMove = useCallback((event: MapLayerMouseEvent) => {
    const hoveredFeature = event.features && event.features[0];
    event.target.getCanvas().style.cursor = hoveredFeature ? "pointer" : "";

    if (hoveredFeature) {
      const properties = hoveredFeature.properties as InteractiveAreaProperties;
      setHoveredAreaId(properties.id);
    } else {
      setHoveredAreaId(null);
    }
  }, []);

  const handleMouseLeave = useCallback((event: MapLayerMouseEvent) => {
    event.target.getCanvas().style.cursor = "";
    setHoveredAreaId(null);
  }, []);

  const handleClick = useCallback((event: MapLayerMouseEvent) => {
    const feature = event.features && event.features[0];
    if (!feature) {
      setSelectedArea(null);
      setPopupInfo(null);
      return;
    }

    const properties = feature.properties as InteractiveAreaProperties;
    setSelectedArea(properties);
    setPopupInfo({
      longtitude: event.lngLat.lng,
      latitude: event.lngLat.lat,
      name: properties.name,
    });
  }, []);

  const handleMapLoad = useCallback(() => {
    if (!hasLoadedRef.current) {
      hasLoadedRef.current = true;
      setTimeout(() => {
        setIsLoading(false); // Trigger fade out
        // Remove from DOM after fade completes
        setTimeout(() => setShowLoading(false), 500); // Match transition duration
      }, 1500);
    }
  }, []);

  return (
    <div className="relative w-full h-full">
			{showLoading && (
				<div
					className={`absolute inset-0 z-50 flex items-center justify-center bg-background backdrop-blur-sm transition-opacity duration-500 ${
						isLoading ? 'opacity-100' : 'opacity-0'
					}`}
				>
					<div className="flex flex-col items-center gap-4">
						<p className="text-primary text-lg font-medium animate-pulse">Loading map...</p>
					</div>
				</div>
			)}
			<Map
				mapLib={maplibregl}
				initialViewState={{
					longitude: 24.05,
					latitude: 68.05,
					zoom: 13,
					pitch: 60,
					bearing: 0,
				}}
				style={{ width: "100%", height: "100%" }}
				mapStyle={MAP_STYLE}
				maxTileCacheSize={500}
				onMouseMove={handleMouseMove}
				onMouseLeave={handleMouseLeave}
				onClick={handleClick}
				onLoad={handleMapLoad}
				interactiveLayerIds={["areas-fill"]}
			>
				<NavigationControl
					position="top-right"
					visualizePitch
					showCompass
					showZoom
				/>
				<TerrainControl
					position="top-right"
					source="terrainSource"
				/>
				<Source id="areas" type="geojson" data={areasGeoJson} promoteId="id">
					<Layer {...areaFillLayer} />
					<Layer {...areaOutlineLayer} />
          <Layer {...areaAvalancheDangerOutlineLayer} />
					<Layer {...areaHoverLayer} filter={hoverFilter} />
          <Layer {...areaSelectedLayer} filter={selectedFilter} />
					<Layer {...areaLabelLayer} />
				</Source>

			</Map>
			<div className="absolute top-12 left-2 bg-background p-2 rounded-lg shadow-lg text-sm">
				<h3>
					Selected: {selectedArea === null ? "nothing" : selectedArea.name}
				</h3>
        {selectedArea && (
          <div className="flex gap-2 flex-col">
            <p>
              Terrain: {selectedArea.terrain}
            </p>
            <p>
              {selectedArea.avalancheDanger ? "Has avalanche danger" : "No avalanche danger"}
            </p>
            </div>
        )}
			</div>
		</div>
  )
}
