"use client";
import { useMutation, useQuery } from "@tanstack/react-query";
import type { FeatureCollection, Polygon } from "geojson";

import {
  ActivityIcon,
  MapPlus,
  LandPlot,
  Snowflake,
  ThermometerSnowflake,
} from "lucide-react";
import type { FilterSpecification, MapMouseEvent } from "mapbox-gl";
import { useTranslations } from "next-intl";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { NavigationControl, Source, Layer, Marker } from "react-map-gl/mapbox";
import Map from "react-map-gl/mapbox";
import "mapbox-gl/dist/mapbox-gl.css";
import { toast } from "sonner";
import { Button } from "../ui/button";
import { Popover, PopoverContent, PopoverTrigger } from "../ui/popover";
import { Separator } from "../ui/separator";
import { Toggle } from "../ui/toggle";
import MapLoadingOverlay from "./map-loading";
import MonitorInfo from "./monitor-info";
import { useMultiStepForm } from "@/hooks/use-multi-step-form";
import {
  CONTROL_STORAGE_KEYS,
  loadControlState,
  saveControlState,
} from "@/lib/map/control-state";
import {
  apiUrl,
  fetchAreas,
  fetchMonitorData,
  fetchSnowTypes,
  fetchUpdateData,
  Segment,
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
import type {
  InteractiveAreaProperties,
  mockUpdateData,
  UpdateData,
} from "@/lib/map/mock-data";
import { calculatePolygonArea } from "@/lib/map/utils";
import type { Monitor } from "@/lib/snower/types";
import { paths } from "@lumisovellus/api-client-web";
import { cookies } from "next/headers";
import { document } from "postcss";
import { getAccessTokenAction } from "@/app/(auth)/actions";

const submitObservation = async (data: {
  segmentId: string | null;
  selectedSnowTypeId: string | null;
  obstacles?: Obstacles | null;
  timestamp: Date | null;
}) => {
  // Validate required fields
  if (!data.segmentId || !data.selectedSnowTypeId || !data.timestamp) {
    throw new Error(
      "Missing required fields: areaId, selectedSnowTypeId, or timestamp",
    );
  }

  const accessToken = await getAccessTokenAction();
  if (!accessToken) {
    throw new Error("User is not authenticated");
  }

  type ObservationRequestBody =
    paths["/api/v1/segments/{id}/reviews"]["post"]["requestBody"]["content"]["application/json"];

  const hazards: ("stones" | "branches")[] = [];
  if (data.obstacles?.stones) hazards.push("stones");
  if (data.obstacles?.branches) hazards.push("branches");

  const requestBody: ObservationRequestBody = {
    snowType: data.selectedSnowTypeId,
    hazards: hazards.length > 0 ? hazards : undefined,
  };

  console.log("posting to:", `/api/v1/segments/${data.segmentId}/reviews`);
  console.log("Submitting observation:", requestBody);

  const response = await fetch(
    `${apiUrl}/api/v1/segments/${data.segmentId}/reviews`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify(requestBody),
    },
  );

  if (!response.ok) throw new Error("Failed to submit observation");
  return response.json();
};

export type Obstacles = {
  stones: boolean;
  branches: boolean;
};

const HazardBadges = ({ hazards }: { hazards: ("stones" | "branches")[] }) => {
  if (!hazards || hazards.length === 0) return null;
  return (
    <div className="flex gap-1 mt-1">
      {hazards.includes("stones") && (
        <span className="inline-flex items-center gap-1 px-2 py-1 rounded bg-amber-100 text-amber-800 text-xs">
          🪨 Stones
        </span>
      )}
      {hazards.includes("branches") && (
        <span className="inline-flex items-center gap-1 px-2 py-1 rounded bg-orange-100 text-orange-800 text-xs">
          🌿 Branches
        </span>
      )}
    </div>
  );
};

export default function Map3d() {
  const [hoveredAreaId, setHoveredAreaId] = useState<string | null>(null);
  const [selectedArea, setSelectedArea] = useState<Segment | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [showLoading, setShowLoading] = useState(true);
  const hasLoadedRef = useRef(false);
  const [selectedSnowCategoryId, setSelectedSnowCategoryId] = useState<
    string | null | undefined
  >(null);
  const [selectedSnowTypeId, setSelectedSnowTypeId] = useState<
    string | null | undefined
  >(null);
  const [selectedObstacles, setSelectedObstacles] = useState<Obstacles>({
    stones: false,
    branches: false,
  });
  const [selectedMonitor, setSelectedMonitor] = useState<Monitor | null>(null);

  const [viewState, setViewState] = useState<CameraState>(() => {
    if (typeof window === "undefined") return DEFAULT_VIEW_STATE;
    return loadCameraState() ?? DEFAULT_VIEW_STATE;
  });

  // map control states
  const [showAreas, setShowAreas] = useState(true);
  const [showMonitors, setShowMonitors] = useState(true);

  useEffect(() => {
    setShowAreas(loadControlState(CONTROL_STORAGE_KEYS.SHOW_AREAS, true));
    setShowMonitors(loadControlState(CONTROL_STORAGE_KEYS.SHOW_MONITORS, true));
  }, []);

  const t = useTranslations("MapPage");

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

  const submitMutation = useMutation({
    mutationFn: submitObservation,
    onSuccess: () => {
      setSelectedArea(null);
      form.reset();
      setSelectedSnowCategoryId(null);
      setSelectedSnowTypeId(null);
      setSelectedObstacles({ stones: false, branches: false });
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

  const areasGeoJson = useMemo<FeatureCollection<Polygon, Segment>>(
    () => ({
      type: "FeatureCollection",
      features: [...areas]
        .sort((a, b) => {
          const areaA = calculatePolygonArea(a.points);
          const areaB = calculatePolygonArea(b.points);
          return areaB - areaA; // Descending order
        })
        .map((area) => {
          // convert points [{lat,lng}] to a GeoJSON linear ring [[lng,lat], ...]
          const ring: [number, number][] = area.points.map((p) => [
            p.lng,
            p.lat,
          ]);
          // ensure the ring is closed (first point equals last point)
          if (ring.length > 0) {
            const first = ring[0];
            const last = ring[ring.length - 1];
            if (first[0] !== last[0] || first[1] !== last[1]) {
              ring.push(first);
            }
          }
          return {
            type: "Feature" as const,
            geometry: {
              type: "Polygon" as const,
              coordinates: [ring],
            },
            properties: area,
          };
        }),
    }),
    [areas],
  );

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

  const handleMouseMove = useCallback((event: MapMouseEvent) => {
    const hoveredFeature = event.features?.[0];
    event.target.getCanvas().style.cursor = hoveredFeature ? "pointer" : "";

    if (hoveredFeature) {
      const properties = hoveredFeature.properties as InteractiveAreaProperties;
      setHoveredAreaId(properties.id);
    } else {
      setHoveredAreaId(null);
    }
  }, []);

  const handleMouseLeave = useCallback((event: MapMouseEvent) => {
    event.target.getCanvas().style.cursor = "";
    setHoveredAreaId(null);
  }, []);

  const form = useMultiStepForm(
    {
      segmentId: selectedArea?.id || null,
      timestamp: new Date(),
      selectedSnowTypeId: selectedSnowTypeId,
      obstacleIds: selectedObstacles,
    },
    3,
  );

  const handleClick = useCallback(
    (event: MapMouseEvent) => {
      const feature = event.features?.[0];

      setSelectedSnowCategoryId(null);
      setSelectedSnowTypeId(null);
      setSelectedObstacles({
        stones: false,
        branches: false,
      });

      // Check if a monitor was clicked
      if (feature?.layer?.id === "monitors-points") {
        const monitor = monitors.find(
          (m) => m.name === feature.properties?.name,
        );
        if (monitor) {
          setSelectedMonitor(monitor);
          setSelectedArea(null);
          return;
        }
      }

      // Handle area clicks as before
      if (!feature) {
        setSelectedArea(null);
        setSelectedMonitor(null);
        form.reset();
        submitMutation.reset();
        return;
      }

      const properties = feature.properties as Segment;
      setSelectedArea(properties);
      setSelectedMonitor(null);
      form.updateFormData({
        segmentId: properties.id,
      });
      form.goToStep(0);
      submitMutation.reset();
    },
    [monitors, form, submitMutation],
  );

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

  const getUpdateDataForArea = (areaId: string) => {
    return updateData.find((update) => update.segmentId === areaId);
  };

  const getLatestUserUpdateForArea = (updateData: UpdateData) => {
    // return the latest update from users (a1 fields)
    if (!updateData.a1Details || !updateData.a1SnowType) {
      return null;
    }
    return {
      details: updateData.a1Details,
      snowTypeId: updateData.a1SnowType,
      time: updateData.a1Time as string,
    };
  };

  const getLatestGuideUpdateForArea = (updateData: UpdateData) => {
    // return the latest update from experts (a2 fields)

    if (!updateData.snowTypeId1 && !updateData.snowTypeId2) {
      return null;
    }
    return {
      description: updateData.description ?? null,
      snowTypeId1: updateData.snowTypeId1 ?? null,
      snowTypeId2: updateData.snowTypeId2 ?? null,
      time: updateData.time,
      secondaryId1: updateData.secondaryId1,
      secondaryId2: updateData.secondaryId2,
    };
  };

  const getPrettyTimeDiff = (pastTime: Date): string => {
    const now = new Date();
    const diffMs = now.getTime() - pastTime.getTime();
    const diffMins = Math.floor(diffMs / 60000);

    if (diffMins < 1) return t("reportForm.time.justNow");
    if (diffMins < 60)
      return t("reportForm.time.minutesAgo", { count: diffMins });
    const diffHours = Math.floor(diffMins / 60);
    if (diffHours < 24)
      return t("reportForm.time.hoursAgo", { count: diffHours });
    const diffDays = Math.floor(diffHours / 24);
    return t("reportForm.time.daysAgo", { count: diffDays });
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
  return (
    <div className="relative w-full h-full">
      <MapLoadingOverlay
        showLoading={showLoading}
        isLoading={isLoading}
        loadingText={t("loading.map")}
      />

      <Map
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
                        className="bg-background p-1 rounded-md "
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

      <Popover>
        <PopoverTrigger asChild>
          <Button
            variant="ghost"
            className="absolute bg-background text-primary bottom-9 left-2"
          >
            <MapPlus />
          </Button>
        </PopoverTrigger>
        <PopoverContent
          side="top"
          align="start"
          className="flex flex-col gap-1 w-max p-1"
        >
          <Toggle
            size="sm"
            pressed={showAreas}
            onPressedChange={(pressed) => {
              setShowAreas(pressed);
              if (!pressed) {
                setSelectedArea(null);
              }
              saveControlState(CONTROL_STORAGE_KEYS.SHOW_AREAS, pressed);
            }}
            variant="outline"
            className="data-[state=on]:bg-transparent  data-[state=on]:*:[svg]:stroke-green-500 text-xs"
          >
            <LandPlot />
            {t("controls.segments")}
          </Toggle>
          <Toggle
            size="sm"
            pressed={showMonitors}
            onPressedChange={(pressed) => {
              setShowMonitors(pressed);
              if (!pressed) {
                setSelectedMonitor(null);
              }
              saveControlState(CONTROL_STORAGE_KEYS.SHOW_MONITORS, pressed);
            }}
            variant="outline"
            className="data-[state=on]:bg-transparent data-[state=on]:*:[svg]:stroke-green-500 text-xs"
          >
            <ActivityIcon />
            {t("controls.sensors")}
          </Toggle>
        </PopoverContent>
      </Popover>

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
            {form.currentStep === 0 && (
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
                        <>
                          {updateData.guideUpdate && (
                            <div className="text-sm text-primary gap-1">
                              {updateData.guideUpdate.primarySnowTypeIds.map(
                                (snowTypeId, index) => (
                                  <div key={snowTypeId}>
                                    <p className="font-medium text-lg">
                                      {t(
                                        `reportForm.snowTypes.${snowTypeId}.name`,
                                      )}
                                    </p>
                                    <p className="text-xs">
                                      {t(
                                        `reportForm.snowTypes.${snowTypeId}.description`,
                                      )}
                                    </p>
                                  </div>
                                ),
                              )}
                              {updateData.guideUpdate.secondarySnowTypeIds.map(
                                (snowTypeId) => (
                                  <div key={snowTypeId}>
                                    <p className="font-medium text-sm">
                                      {t(
                                        `reportForm.snowTypes.${snowTypeId}.name`,
                                      )}
                                    </p>
                                    <p className="text-xs">
                                      {t(
                                        `reportForm.snowTypes.${snowTypeId}.description`,
                                      )}
                                    </p>
                                  </div>
                                ),
                              )}
                              <HazardBadges
                                hazards={updateData.guideUpdate.hazards}
                              />
                            </div>
                          )}
                          {updateData.userReviews.length > 0 &&
                            updateData.guideUpdate && <Separator />}
                          {updateData.userReviews.length > 0 && (
                            <div className="text-xs text-muted-foreground">
                              <p>{t("reportForm.observationType.visitor")}</p>
                              {updateData.userReviews.map((review, index) => (
                                <div
                                  key={index}
                                  className="text-primary flex flex-col"
                                >
                                  <p className="font-medium text-sm">
                                    {t(
                                      `reportForm.snowTypes.${review.snowTypeId}.name`,
                                    )}
                                    :{" "}
                                    {getPrettyTimeDiff(
                                      new Date(review.submittedAt),
                                    )}
                                  </p>
                                  <p className="text-xs">
                                    {t(
                                      `reportForm.snowTypes.${review.snowTypeId}.description`,
                                    )}
                                  </p>
                                  <HazardBadges
                                    hazards={
                                      review.hazards as (
                                        | "stones"
                                        | "branches"
                                      )[]
                                    }
                                  />
                                </div>
                              ))}
                            </div>
                          )}
                        </>
                      );
                    })()}
                  </>
                )}
                <div className="flex gap-2">
                  <Button onClick={() => form.goToStep(1)}>
                    {t("reportForm.buttons.addObservation")}
                  </Button>
                  <Button
                    variant="secondary"
                    onClick={() => setSelectedArea(null)}
                  >
                    {t("reportForm.buttons.close")}
                  </Button>
                </div>
              </>
            )}
            {form.currentStep === 1 && (
              <div className="flex gap-4 flex-col items-center">
                <div className="flex flex-col gap-2 items-center">
                  <p>{t("reportForm.steps.selectSnowType")}</p>
                  {snowTypesLoading && <p>{t("loading.snowData")}</p>}
                  {snowTypesError && (
                    <p className="text-red-500">
                      {t("errors.loadingSnowData")}
                    </p>
                  )}
                  <div className="grid grid-cols-2 gap-2">
                    {snowTypes
                      .filter((st) => st.primarySnowTypeId === null)
                      .map((snowType) => (
                        <Button
                          key={snowType.id}
                          className="text-xs"
                          variant="outline"
                          onClick={() => {
                            setSelectedSnowCategoryId(snowType.id);
                            setSelectedSnowTypeId(snowType.id);

                            form.updateFormData({
                              selectedSnowTypeId: snowType.id,
                            });
                            form.nextStep();
                          }}
                        >
                          {t(`reportForm.snowTypes.${snowType.id}.name`)}
                        </Button>
                      ))}
                  </div>
                </div>

                <div className="flex gap-2">
                  <Button variant="secondary" onClick={() => form.goToStep(0)}>
                    {t("reportForm.buttons.back")}
                  </Button>
                </div>
              </div>
            )}
            {form.currentStep === 2 && (
              <div className="flex gap-4 flex-col items-center">
                <div className="flex flex-col gap-2 items-center">
                  <p>{t("reportForm.steps.specifySnowType")}</p>
                  <div className="grid grid-cols-2 gap-2">
                    {snowTypes
                      .filter(
                        (st) =>
                          st.primarySnowTypeId === selectedSnowCategoryId ||
                          st.id === selectedSnowCategoryId,
                      )
                      .map((snowType) => (
                        <Button
                          key={snowType.id}
                          variant="outline"
                          onClick={() => {
                            setSelectedSnowTypeId(snowType.id);
                            form.updateFormData({
                              selectedSnowTypeId: snowType.id,
                            });
                          }}
                          className={` text-xs
															${selectedSnowTypeId === snowType.id ? "ring-green-500 ring-2" : ""}
														`}
                        >
                          {t(`reportForm.snowTypes.${snowType.id}.name`)}
                        </Button>
                      ))}
                  </div>
                  <p className="text-center">
                    {t(
                      `reportForm.snowTypes.${selectedSnowTypeId}.description`,
                    )}
                  </p>
                </div>
                <div className="flex flex-col gap-2 items-center">
                  <p>{t("reportForm.obstacles.description")}</p>
                  <div className="grid grid-cols-2 gap-2">
                    <Button
                      variant="outline"
                      onClick={() => {
                        const newStonesState = !selectedObstacles.stones;
                        setSelectedObstacles((prev) => ({
                          ...prev,
                          stones: newStonesState,
                        }));
                        form.updateFormData({
                          obstacleIds: {
                            stones: newStonesState,
                            branches: selectedObstacles.branches,
                          },
                        });
                      }}
                      className={
                        selectedObstacles.stones ? "ring-green-500 ring-2" : ""
                      }
                    >
                      Stones
                    </Button>
                    <Button
                      variant="outline"
                      onClick={() => {
                        const newBranchesState = !selectedObstacles.branches;
                        setSelectedObstacles((prev) => ({
                          ...prev,
                          branches: newBranchesState,
                        }));
                        form.updateFormData({
                          obstacleIds: {
                            stones: selectedObstacles.stones,
                            branches: newBranchesState,
                          },
                        });
                      }}
                      className={
                        selectedObstacles.branches
                          ? "ring-green-500 ring-2"
                          : ""
                      }
                    >
                      Branches
                    </Button>
                  </div>
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="secondary"
                    onClick={() => {
                      setSelectedSnowTypeId(null);
                      setSelectedObstacles({ stones: false, branches: false });
                      submitMutation.reset();
                      form.goToStep(1);
                    }}
                  >
                    {t("reportForm.buttons.back")}
                  </Button>
                  <Button
                    onClick={() =>
                      submitMutation.mutate({
                        segmentId: form.formData.segmentId,
                        selectedSnowTypeId: form.formData.selectedSnowTypeId,
                        obstacles: form.formData.obstacleIds,
                        timestamp: new Date(),
                      })
                    }
                  >
                    {submitMutation.isPending
                      ? t("reportForm.buttons.submitting")
                      : t("reportForm.buttons.submit")}
                  </Button>
                </div>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
