"use client"
import { useMutation, useQuery } from "@tanstack/react-query";
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
import { InteractiveAreaFeature, InteractiveAreaProperties, mapAreas2, mockSnowData, mockUpdateData, SnowType } from "@/lib/map/mock-data";
import { Button } from "../ui/button";
import { Separator } from "../ui/separator";
import { useMultiStepForm } from "@/hooks/use-multi-step-form";
import { useTranslations } from "next-intl";

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


const fetchSnowTypes = async (): Promise<SnowType[]> => {
  await new Promise(resolve => setTimeout(resolve, 500))
  return mockSnowData
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

const submitObservation = async (data: {
  areaId: string | null;
  selectedSnowTypeId: number | null;
  snowTypeDetails: number[] | null;
  timestamp: Date | null;
}) => {
  if (!data.areaId || !data.selectedSnowTypeId || !data.timestamp || data.snowTypeDetails?.length === 0) {
    throw new Error('Invalid observation data');
  }
  const response = await fetch('/api/observations', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
  
  if (!response.ok) throw new Error('Failed to submit observation');
  return response.json();
};

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
  const [selectedSnowTypeId, setSelectedSnowTypeId] = useState<number | null>(null);
  const [selectedSnowTypeDetailsId, setSelectedSnowTypeDetailsId] = useState<number[] | null>(null);

  const t = useTranslations("MapPage")

  const { data: areas = [] } = useQuery({
    queryKey: ['mapAreas'],
    queryFn: fetchAreas,
    refetchInterval: 10000,
    staleTime: 5000
  })

  const { data: snowTypes = [] } = useQuery({
    queryKey: ['snowTypes'],
    queryFn: fetchSnowTypes,
    staleTime: Infinity
  })

  const submitMutation = useMutation({
    mutationFn: submitObservation,
    onSuccess: () => {
      setSelectedArea(null);
      form.reset();
      setSelectedSnowTypeDetailsId(null);
      setSelectedSnowTypeId(null);
    }
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
    form.reset();
    submitMutation.reset();
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

  const form = useMultiStepForm({
    areaId: selectedArea?.id || null,
    timestamp: new Date(),
    selectedSnowTypeId: selectedSnowTypeId,
  }, 3)

  return (
    <div className="relative w-full h-full">
			{showLoading && (
				<div
					className={`absolute inset-0 z-50 flex items-center justify-center bg-background backdrop-blur-sm transition-opacity duration-500 ${
						isLoading ? 'opacity-100' : 'opacity-0'
					}`}
				>
					<div className="flex flex-col items-center gap-4">
						<p className="text-primary text-lg font-medium animate-pulse">{t('loading')}</p>
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

			{selectedArea && (
			<div className="absolute top-12 left-2 bg-background p-2 rounded-lg shadow-lg text-sm flex flex-col gap-2">
			  <div className="flex flex-col">
  				<h3 className="font-medium">
  				  {selectedArea.name}
  				</h3>
  				<p>
            {selectedArea.terrain}
          </p>
				</div>
				<Separator />
          <div className="flex gap-2 flex-col">
            {form.currentStep === 0 && (
              <>
            <p>
              {selectedArea.avalancheDanger ? t('warnings.avalanche.danger') : t('warnings.avalance.noDanger')}
            </p>
            <div className="flex gap-2">
              <Button onClick={() => form.goToStep(1)}>
                {t('reportForm.buttons.addObservation')}
              </Button>
              <Button variant="secondary" onClick={() => setSelectedArea(null)}>
                {t('reportForm.buttons.close')}
              </Button>
            </div>
              </>
            )}
            {form.currentStep === 1 && (
              <>

                <div className="flex gap-4 flex-col items-center">
                  <p>{t('reportForm.steps.selectSnowType')}</p>
                  <div className="grid grid-cols-2 gap-2">
                  {snowTypes.filter(st => st.categoryId === null).map(snowType => (
                    <Button
                      key={snowType.id}
                      variant="outline"
                      onClick={() => {
                        setSelectedSnowTypeId(snowType.id);
                        form.updateFormData({ selectedSnowTypeId: snowType.id });
                        form.nextStep();
                      }}
                    >
                      {snowType.name}
                    </Button>
                  ))}
                  </div>
                  <div className="flex gap-2">
                    <Button variant="secondary" onClick={() => form.goToStep(0)}>
                      {t('reportForm.buttons.back')}
                    </Button>
                  </div>
                </div>
              </>
            )}
            {form.currentStep === 2 && (
              <>

                <div className="flex gap-4 flex-col items-center">
                  <p>{t('reportForm.steps.specifySnowType')}</p>
                  <div className="grid grid-cols-2 gap-2">
                  {snowTypes.filter(st => (st.categoryId === form.formData.selectedSnowTypeId || st.id === selectedSnowTypeId)).map(snowType => (
                    <Button
                      key={snowType.id}
                      variant="outline"
                      onClick={() => {
                        // append to selectedSnowTypeDetailsId
                        // or remove if already selected
                        if (selectedSnowTypeDetailsId?.includes(snowType.id)) {
                          setSelectedSnowTypeDetailsId(selectedSnowTypeDetailsId.filter(id => id !== snowType.id));
                        } else {
                          setSelectedSnowTypeDetailsId([...(selectedSnowTypeDetailsId || []), snowType.id]);
                        }
                      }}
                      className={selectedSnowTypeDetailsId?.includes(snowType.id) ? 'ring-green-500 ring-2' : ''}
                    >
                      {snowType.name}
                    </Button>
                  ))}
                  </div>
                  <div className="flex gap-2">
                    <Button variant="secondary" onClick={() => {
                      setSelectedSnowTypeDetailsId(null);
                      form.goToStep(1)}}>
                      {t('reportForm.buttons.back')}
                    </Button>
                    <Button
                                      onClick={() => submitMutation.mutate({
                  areaId: form.formData.areaId,
                  selectedSnowTypeId: form.formData.selectedSnowTypeId,
                  snowTypeDetails: selectedSnowTypeDetailsId,
                  timestamp: form.formData.timestamp,
                })}
                disabled={submitMutation.isPending || !selectedSnowTypeDetailsId || selectedSnowTypeDetailsId.length === 0}
                    >
                      {submitMutation.isPending ? t('reportForm.buttons.submitting') : t('reportForm.buttons.submit')}
                    </Button>
                  </div>
                  {
                    submitMutation.isError && (
                      <p className="text-red-500 text-sm">
                        {t('reportForm.errors.submitFailed')}
                      </p>
                    )
                  }
                </div>
              </>
            )}
            </div>
			</div>
			)}
		</div>
  )
}
