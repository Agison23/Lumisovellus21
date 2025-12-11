"use client";

/* eslint-disable react/prop-types */
import { useQuery } from "@tanstack/react-query";
import type { FeatureCollection, Polygon } from "geojson";
import { Snowflake, ThermometerSnowflake } from "lucide-react";
import type { FilterSpecification, MapMouseEvent } from "mapbox-gl";
import { useTranslations } from "next-intl";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import Map, {
  Layer,
  Marker,
  NavigationControl,
  Source,
} from "react-map-gl/mapbox";
import "mapbox-gl/dist/mapbox-gl.css";
import { toast } from "sonner";

import { Button } from "../ui/button";
import { Separator } from "../ui/separator";
import { useSidebar } from "../ui/sidebar";

import { GuideForm } from "./guide-form";
import MapLoadingOverlay from "./map-loading";
import MonitorInfo from "./monitor-info";
import { ObservationForm } from "./observation-form";
import { SegmentReport } from "./segment-report";
import { VisibilityControls } from "./visibility-controls";
import { useAuth } from "@/hooks/use-auth";
import { useGuideUpdateMutation } from "@/hooks/use-guide-update-mutation";
import { useObservationMutation } from "@/hooks/use-observation-mutation";
import {
  CONTROL_STORAGE_KEYS,
  loadControlState,
} from "@/lib/map/control-state";
import {
  fetchAreas,
  fetchMonitorData,
  fetchSnowTypes,
  fetchUpdateData,
  type Segment,
} from "@/lib/map/loaders";
import {
  type CameraState,
  DEFAULT_VIEW_STATE,
  loadCameraState,
  saveCameraState,
} from "@/lib/map/map-camera";
import {
  areaAvalancheDangerOutlineLayer,
  areaFillLayer,
  areaHoverLayer,
  areaLabelLayer,
  areaOutlineLayer,
  areaSelectedLayer,
  hillshadeLayer,
  TERRAIN_CONFIG,
  TERRAIN_SOURCE_CONFIG,
} from "@/lib/map/map-style";
import type { InteractiveAreaProperties } from "@/lib/map/mock-data";
import { calculatePolygonArea, isPolygonInsidePolygon } from "@/lib/map/utils";
import type { Monitor } from "@/lib/snower/types";
import { getTranslationKeyForSnowTypeName } from "@/lib/utils";
import { buildPolygonCoordinates } from "@/utils/polygon-utils";

export default function Map3d() {
  const [hoveredAreaId, setHoveredAreaId] = useState<string | null>(null);
  const [selectedArea, setSelectedArea] = useState<Segment | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [showLoading, setShowLoading] = useState(true);
  const hasLoadedRef = useRef(false);
  const mapRef = useRef<mapboxgl.Map | null>(null);
  const [selectedMonitor, setSelectedMonitor] = useState<Monitor | null>(null);

  // Form step: 0 = info view, 1 = form view
  const [formStep, setFormStep] = useState<0 | 1>(0);

  const [viewState, setViewState] = useState<CameraState>(() => {
    if (typeof window === "undefined") return DEFAULT_VIEW_STATE;
    return loadCameraState() ?? DEFAULT_VIEW_STATE;
  });

  // map control states
  const [showAreas, setShowAreas] = useState(true);
  const [showMonitors, setShowMonitors] = useState(true);

  const t = useTranslations("MapPage");

  const user = useAuth().user;
  const userRole = user?.role;

  // Track sidebar state to resize map when it changes
  const { state: sidebarState } = useSidebar();

  useEffect(() => {
    setShowAreas(loadControlState(CONTROL_STORAGE_KEYS.SHOW_AREAS, true));
    setShowMonitors(loadControlState(CONTROL_STORAGE_KEYS.SHOW_MONITORS, true));
  }, []);

  // Resize map when sidebar state changes
  useEffect(() => {
    if (mapRef.current) {
      // Delay resize to allow CSS transition to complete
      const timer = setTimeout(() => {
        mapRef.current?.resize();
      }, 300);
      return () => clearTimeout(timer);
    }
  }, [sidebarState]);

  // DATA LOADERS:
  const {
    data: areas = [],
    isError: areasError,
    error: areasErrorMessage,
  } = useQuery({
    queryKey: ["mapAreas"],
    queryFn: fetchAreas,
    staleTime: Infinity,
  });

  const {
    data: snowTypes = [],
    isError: snowTypesError,
    isLoading: snowTypesLoading,
  } = useQuery({
    queryKey: ["snowTypes"],
    queryFn: fetchSnowTypes,
    staleTime: Infinity,
  });

  const {
    data: updateData = [],
    isError: updateError,
    isLoading: updateDataLoading,
    refetch: refetchUpdateData,
  } = useQuery({
    queryKey: ["updateData"],
    queryFn: fetchUpdateData,
    refetchInterval: 10000,
    staleTime: 5000,
  });

  const {
    data: monitors = [],
    isError: monitorsError,
    isLoading: monitorsLoading,
  } = useQuery({
    queryKey: ["monitors"],
    queryFn: fetchMonitorData,
    staleTime: Infinity,
  });

  // MUTATIONS:
  const submitGuideUpdateMutation = useGuideUpdateMutation({
    onSuccess: () => {
      toast.success(t("reportForm.messages.submitSuccess"));
      refetchUpdateData();
      setSelectedArea(null);
      setFormStep(0);
    },
    onError: (error) => {
      toast.error(
        t("reportForm.messages.submitError") +
          (error instanceof Error ? ` ${error.message}` : ""),
      );
    },
  });

  const submitObservationMutation = useObservationMutation({
    onSuccess: () => {
      setSelectedArea(null);
      setFormStep(0);
      toast.success(t("reportForm.messages.submitSuccess"));
      refetchUpdateData();
    },
    onError: (error) => {
      toast.error(
        t("reportForm.messages.submitError") +
          (error instanceof Error ? ` ${error.message}` : ""),
      );
    },
  });

  const snowTypeOptions = useMemo(() => {
    return snowTypes.map((st) => ({
      value: st.id,
      label: t(
        `reportForm.snowTypes.${getTranslationKeyForSnowTypeName(st.name)}.name`,
      ),
    }));
  }, [snowTypes, t]);

  // MEMOIZED GEOJSON DATA:
  const areasGeoJson = useMemo<FeatureCollection<Polygon, Segment>>(() => {
    // Sort areas by size descending (larger areas rendered first, smaller on top)
    const sortedAreas = [...areas].sort((a, b) => {
      const areaA = calculatePolygonArea(a.points);
      const areaB = calculatePolygonArea(b.points);
      return areaB - areaA;
    });

    // For each area, find inner areas that should be cut out as holes
    const areasWithHoles = sortedAreas.map((area) => {
      // Find all smaller polygons that are inside this one
      const innerAreas = sortedAreas.filter((otherArea) => {
        if (otherArea.id === area.id) return false;
        const otherSize = calculatePolygonArea(otherArea.points);
        const thisSize = calculatePolygonArea(area.points);
        // Only consider smaller polygons
        if (otherSize >= thisSize) return false;
        // Check if the other polygon is inside this one
        return isPolygonInsidePolygon(otherArea.points, area.points);
      });

      return { area, innerAreas };
    });

    return {
      type: "FeatureCollection",
      features: areasWithHoles.map(({ area, innerAreas }) => ({
        type: "Feature" as const,
        geometry: {
          type: "Polygon" as const,
          coordinates: buildPolygonCoordinates(
            area.points,
            innerAreas.map((ia) => ia.points),
          ),
        },
        properties: area,
      })),
    };
  }, [areas]);

  // Filters for hover and selected states
  const hoverFilter = useMemo<FilterSpecification>(
    () => ["==", ["get", "id"], hoveredAreaId ?? ""] as FilterSpecification,
    [hoveredAreaId],
  );

  const selectedFilter = useMemo<FilterSpecification>(
    () => ["==", ["get", "id"], selectedArea?.id ?? ""] as FilterSpecification,
    [selectedArea],
  );

  const monitorsGeoJson = useMemo<FeatureCollection>(
    () => ({
      type: "FeatureCollection",
      features: monitors
        .filter(
          (monitor) =>
            monitor.snowDepth !== "No Data" ||
            monitor.temperature !== "No Data",
        )
        .map((monitor) => ({
          type: "Feature" as const,
          geometry: {
            type: "Point" as const,
            coordinates: [monitor.lng, monitor.lat],
          },
          properties: {
            name: monitor.name,
            temperature: monitor.temperatureString,
            snowDepth: monitor.snowDepthString,
          },
        })),
    }),
    [monitors],
  );

  // EVENT HANDLERS:
  // Handle mouse move to detect hover over areas
  const handleMouseMove = useCallback(
    (event: MapMouseEvent) => {
      const features = event.features;
      event.target.getCanvas().style.cursor =
        features && features.length > 0 ? "pointer" : "";

      // If hovering over areas, find the smallest (topmost) one
      if (features && features.length > 0) {
        // Filter to only area features and find the smallest one
        const areaFeatures = features.filter(
          (f) => f.layer?.id === "areas-fill",
        );

        if (areaFeatures.length > 0) {
          // Find the area with the smallest size (it's rendered on top)
          // Since areas are sorted by size descending in areasGeoJson,
          // the last matching feature in the array is the smallest
          let smallestFeature = areaFeatures[0];
          let smallestArea = Infinity;

          for (const feature of areaFeatures) {
            const props = feature.properties as Segment;
            // Calculate area from the segment's points if available
            const segment = areas.find((a) => a.id === props.id);
            if (segment) {
              const area = calculatePolygonArea(segment.points);
              if (area < smallestArea) {
                smallestArea = area;
                smallestFeature = feature;
              }
            }
          }

          const properties =
            smallestFeature.properties as InteractiveAreaProperties;
          setHoveredAreaId(properties.id);
        } else {
          setHoveredAreaId(null);
        }
      } else {
        setHoveredAreaId(null);
      }
    },
    [areas],
  );

  // Handle mouse leave to clear hover state
  const handleMouseLeave = useCallback((event: MapMouseEvent) => {
    event.target.getCanvas().style.cursor = "";
    setHoveredAreaId(null);
  }, []);

  // Handle click events on the map
  const handleClick = useCallback(
    (event: MapMouseEvent) => {
      const features = event.features;

      // Check if a monitor was clicked
      const monitorFeature = features?.find(
        (f) => f.layer?.id === "monitors-points",
      );
      if (monitorFeature) {
        const monitor = monitors.find(
          (m) => m.name === monitorFeature.properties?.name,
        );
        // If monitor found, set it as selected and clear area selection
        if (monitor) {
          setSelectedMonitor(monitor);
          setSelectedArea(null);
          return;
        }
      }

      // Handle area clicks - find the smallest (topmost) area
      const areaFeatures = features?.filter(
        (f) => f.layer?.id === "areas-fill",
      );

      if (!areaFeatures || areaFeatures.length === 0) {
        setSelectedArea(null);
        setSelectedMonitor(null);
        setFormStep(0);
        submitObservationMutation.reset();
        return;
      }

      // Find the smallest area (rendered on top)
      let smallestFeature = areaFeatures[0];
      let smallestArea = Infinity;

      for (const feature of areaFeatures) {
        const props = feature.properties as Segment;
        const segment = areas.find((a) => a.id === props.id);
        if (segment) {
          const area = calculatePolygonArea(segment.points);
          if (area < smallestArea) {
            smallestArea = area;
            smallestFeature = feature;
          }
        }
      }

      // If an area was clicked, set it as selected
      // Clear any selected monitor for clarity
      const properties = smallestFeature.properties as Segment;
      setSelectedArea(properties);
      setSelectedMonitor(null);
      setFormStep(0);
      submitObservationMutation.reset();
    },
    [monitors, submitObservationMutation, areas],
  );

  // Handle map load event to manage loading overlay
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

  // HELPERS:
  const getUpdateDataForArea = (areaId: string) => {
    return updateData.find((update) => update.segmentId === areaId) ?? "";
  };

  if (areasError) {
    return (
      <div className="p-4">
        <h2 className="text-red-600 font-bold mb-2">
          {t("errors.loadingData")}
        </h2>
        <p className="text-red-500">{areasErrorMessage?.message}</p>
      </div>
    );
  }

  const isGuideRole =
    userRole === "RESCUE" || userRole === "GUIDE" || userRole === "ADMIN";

  return (
    <div className="relative w-full h-full">
      <MapLoadingOverlay
        showLoading={showLoading}
        isLoading={isLoading}
        loadingText={t("loading.map")}
      />

      <Map
        ref={(ref) => {
          if (ref) {
            mapRef.current = ref.getMap();
          }
        }}
        initialViewState={viewState}
        style={{ width: "100%", height: "100%" }}
        maxTileCacheSize={500}
        onMouseMove={handleMouseMove}
        onMouseLeave={handleMouseLeave}
        onClick={handleClick}
        onLoad={handleMapLoad}
        onMove={(evt) => {
          // Save camera state whenever user moves/zooms/rotates the map
          const newState = {
            longitude: evt.viewState.longitude,
            latitude: evt.viewState.latitude,
            zoom: evt.viewState.zoom,
            pitch: evt.viewState.pitch,
            bearing: evt.viewState.bearing,
          };
          setViewState(newState);
          saveCameraState(newState);
        }}
        interactiveLayerIds={["areas-fill", "monitors-points"]}
        mapStyle="mapbox://styles/mapbox/outdoors-v12"
        mapboxAccessToken={process.env.NEXT_PUBLIC_MAPBOX_PUBLIC_ACCESS_TOKEN}
        terrain={TERRAIN_CONFIG}
      >
        <NavigationControl
          position="top-right"
          visualizePitch
          showCompass
          showZoom
        />
        {/* Terrain source for 3D elevation */}
        <Source {...TERRAIN_SOURCE_CONFIG} />
        {/* Hillshade layer for visual terrain shading */}
        <Layer {...hillshadeLayer} />
        {!isLoading && (
          <>
            {/* Monitors layer */}
            {showMonitors && (
              <>
                <Source id="monitors" type="geojson" data={monitorsGeoJson}>
                  <Layer
                    id="monitors-points"
                    type="circle"
                    paint={{
                      "circle-radius": 6,
                      "circle-color": "#ff6b6b",
                      "circle-stroke-width": 2,
                      "circle-stroke-color": "#fff",
                    }}
                  />
                </Source>
                {viewState.zoom > 11.5 &&
                  monitors
                    .filter(
                      (monitor) =>
                        monitor.temperature !== "No Data" ||
                        monitor.snowDepth !== "No Data",
                    )
                    .map((monitor) => (
                      <Marker
                        key={monitor.name}
                        longitude={monitor.lng}
                        latitude={monitor.lat}
                        offset={[0, -35]}
                        className="bg-background p-1 rounded-md cursor-pointer"
                        onClick={(e) => {
                          e.originalEvent.stopPropagation();
                          setSelectedMonitor(monitor);
                          setSelectedArea(null);
                        }}
                      >
                        <div>
                          {monitor.temperature !== "No Data" && (
                            <p className="flex items-center gap-1">
                              <ThermometerSnowflake size={16} />
                              <span>
                                {monitor.temperature.value} °
                                {monitor.temperature.unit[0]}
                              </span>
                            </p>
                          )}
                          {monitor.snowDepth !== "No Data" && (
                            <p className="flex items-center gap-1">
                              <Snowflake size={16} />
                              <span>
                                {monitor.snowDepth.value}{" "}
                                {monitor.snowDepth.unit}
                              </span>
                            </p>
                          )}
                        </div>
                      </Marker>
                    ))}
              </>
            )}
            {showAreas && (
              <Source
                id="areas"
                type="geojson"
                data={areasGeoJson}
                promoteId="id"
              >
                <Layer {...areaFillLayer} />
                <Layer {...areaOutlineLayer} />
                <Layer {...areaAvalancheDangerOutlineLayer} />
                <Layer {...areaHoverLayer} filter={hoverFilter} />
                <Layer {...areaSelectedLayer} filter={selectedFilter} />
                <Layer {...areaLabelLayer} />
              </Source>
            )}
          </>
        )}
      </Map>

      {/* VISIBLE CONTROLS */}
      <VisibilityControls
        showAreas={showAreas}
        showMonitors={showMonitors}
        onShowAreasChange={(pressed) => {
          setShowAreas(pressed);
          if (!pressed) setSelectedArea(null);
        }}
        onShowMonitorsChange={(pressed) => {
          setShowMonitors(pressed);
          if (!pressed) setSelectedMonitor(null);
        }}
      />

      {selectedMonitor && (
        <MonitorInfo
          monitor={selectedMonitor}
          onClose={() => setSelectedMonitor(null)}
          t={t}
        />
      )}
      {selectedArea && (
        <div className="absolute top-12 left-2 bg-background p-2 rounded-lg shadow-lg text-sm flex flex-col gap-2 animate-in fade-in zoom-in-95 duration-200 overflow-y-auto overflow-x-hidden max-h-[calc(100vh-100px)] w-80 max-w-[90vw]">
          <div className="flex flex-col">
            <h3 className="font-medium">{selectedArea.name}</h3>
            <p>{selectedArea.terrain}</p>
          </div>
          <Separator />
          <div className="flex gap-2 flex-col">
            {formStep === 0 && (
              <>
                {updateDataLoading ? (
                  <p>{t("loading.segmentData")}</p>
                ) : (
                  <>
                    {updateError && (
                      <p className="text-red-500">
                        {t("errors.loadingSegmentData")}
                      </p>
                    )}
                    {selectedArea.avalancheDanger && (
                      <p>{t("warnings.avalanche.danger")}</p>
                    )}
                    {(() => {
                      const updateData = getUpdateDataForArea(selectedArea.id);
                      if (!updateData) return null;
                      return (
                        <SegmentReport
                          updateData={updateData}
                          snowTypes={snowTypes}
                          segmentName={selectedArea.name}
                        />
                      );
                    })()}
                  </>
                )}
                <div className="flex gap-2">
                  {user && (
                    <Button onClick={() => setFormStep(1)}>
                      {t("reportForm.buttons.addObservation")}
                    </Button>
                  )}
                  <Button
                    variant="secondary"
                    onClick={() => setSelectedArea(null)}
                  >
                    {t("reportForm.buttons.close")}
                  </Button>
                </div>
              </>
            )}
            {formStep === 1 && isGuideRole && (
              <GuideForm
                segmentId={selectedArea.id}
                snowTypeOptions={snowTypeOptions}
                isPending={submitGuideUpdateMutation.isPending}
                onSubmit={(data) => {
                  submitGuideUpdateMutation.mutate({
                    segmentId: data.segmentId,
                    primarySnowTypeIds: data.primarySnowTypeIds,
                    secondarySnowTypeIds: data.secondarySnowTypeIds,
                    hazards: data.hazards,
                    description: data.description,
                  });
                }}
                onBack={() => setFormStep(0)}
              />
            )}
            {formStep === 1 && !isGuideRole && (
              <ObservationForm
                snowTypes={snowTypes}
                snowTypesLoading={snowTypesLoading}
                snowTypesError={snowTypesError}
                isPending={submitObservationMutation.isPending}
                onSubmit={(data) => {
                  submitObservationMutation.mutate({
                    segmentId: selectedArea.id,
                    selectedSnowTypeId: data.selectedSnowTypeId,
                    obstacles: data.obstacles,
                    timestamp: data.timestamp,
                  });
                }}
                onBack={() => setFormStep(0)}
              />
            )}
          </div>
        </div>
      )}
    </div>
  );
}
