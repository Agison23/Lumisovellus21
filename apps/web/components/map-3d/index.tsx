"use client";
import { useMutation, useQuery } from "@tanstack/react-query";
import { FeatureCollection, Polygon } from "geojson";

import { MapMouseEvent, type FilterSpecification } from "mapbox-gl";
import { useTranslations } from "next-intl";
import { useCallback, useMemo, useRef, useState } from "react";
import Map, { Layer, NavigationControl, Source } from "react-map-gl/mapbox";
import "mapbox-gl/dist/mapbox-gl.css";
import { toast } from "sonner";
import { Button } from "../ui/button";
import { Separator } from "../ui/separator";
import { useMultiStepForm } from "@/hooks/use-multi-step-form";
import {
	CameraState,
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
import {
	InteractiveAreaFeature,
	InteractiveAreaProperties,
	mapAreas2,
	mockSnowData,
	mockUpdateData,
	SnowType,
	UpdateData,
} from "@/lib/map/mock-data";
import { Monitor } from "@/lib/snower/types";

// for now, mock fetching from the API
const fetchAreas = async (): Promise<InteractiveAreaFeature[]> => {
	await new Promise((resolve) => setTimeout(resolve, 500));
	// throw new Error("Mock error fetching area types");
	return mapAreas2;
};

const fetchSnowTypes = async (): Promise<SnowType[]> => {
	await new Promise((resolve) => setTimeout(resolve, 500));
	// mock if api throws error
	// throw new Error("Mock error fetching snow types");
	return mockSnowData;
};

const fetchUpdateData = async (): Promise<UpdateData[]> => {
	await new Promise((resolve) => setTimeout(resolve, 500));
	// throw new Error("Mock error fetching update data");
	return mockUpdateData;
};

const fetchMonitorData = async (): Promise<Monitor[]> => {
	const res = await fetch("/api/snower");
	// throw new Error("Mock error fetching monitor data");

	if (!res.ok) {
		throw new Error("Failed to fetch monitor data");
	}
	return res.json();
};

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
	obstacleIds?: number[] | null;
	timestamp: Date | null;
}) => {
	// Validate that at least one of snowTypeDetails or obstacleIds is provided
	const hasSnowTypeDetails = data.selectedSnowTypeId !== null;
	const hasObstacles =
		data.obstacleIds &&
		Array.isArray(data.obstacleIds) &&
		data.obstacleIds.length > 0;

	if (
		!data.areaId ||
		!data.selectedSnowTypeId ||
		!data.timestamp ||
		(!hasSnowTypeDetails && !hasObstacles) ||
		(data.obstacleIds && !Array.isArray(data.obstacleIds))
	) {
		// show what is missing
		console.log(
			"Missing data:",
			"areaId:",
			data.areaId,
			"selectedSnowTypeId:",
			data.selectedSnowTypeId,
			"timestamp:",
			data.timestamp,
			"obstacleIds:",
			data.obstacleIds
		);
		throw new Error("Invalid observation data");
	}
	const response = await fetch("/api/observations", {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(data),
	});

	if (!response.ok) throw new Error("Failed to submit observation");
	return response.json();
};

export default function Map3d() {
	const [hoveredAreaId, setHoveredAreaId] = useState<string | null>(null);
	const [selectedArea, setSelectedArea] =
		useState<InteractiveAreaProperties | null>(null);
	const [isLoading, setIsLoading] = useState(true);
	const [showLoading, setShowLoading] = useState(true);
	const hasLoadedRef = useRef(false);
	const [selectedSnowCategoryId, setSelectedSnowCategoryId] = useState<
		number | null
	>(null);
	const [selectedSnowTypeId, setSelectedSnowTypeId] = useState<number | null>(
		null
	);
	const [selectedObstacleIds, setSelectedObstacleIds] = useState<
		number[] | null
	>(null);
	const [selectedMonitor, setSelectedMonitor] = useState<Monitor | null>(null);

	const [viewState, setViewState] = useState<CameraState>(() => {
		if (typeof window === "undefined") return DEFAULT_VIEW_STATE;
		return loadCameraState() ?? DEFAULT_VIEW_STATE;
	});

	const t = useTranslations("MapPage");

	// DATA LOADERS:
	const {
		data: areas = [],
		isError: areasError,
		error: areasErrorMessage,
		isLoading: areasLoading,
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
			setSelectedObstacleIds(null);
			toast.success(t("reportForm.messages.submitSuccess"));
		},
		onError: (error) => {
			toast.error(
				t("reportForm.messages.submitError") +
					(error instanceof Error ? ` ${error.message}` : "")
			);
		},
	});

	const areasGeoJson = useMemo<
		FeatureCollection<Polygon, InteractiveAreaProperties>
	>(
		() => ({
			type: "FeatureCollection",
			features: [...areas].sort((a, b) => {
				const areaA = calculatePolygonArea(a.geometry.coordinates[0]);
				const areaB = calculatePolygonArea(b.geometry.coordinates[0]);
				return areaB - areaA; // Descending order
			}),
		}),
		[areas]
	);

	const hoverFilter = useMemo<FilterSpecification>(
		() => ["==", ["get", "id"], hoveredAreaId ?? ""] as FilterSpecification,
		[hoveredAreaId]
	);

	const selectedFilter = useMemo<FilterSpecification>(
		() => ["==", ["get", "id"], selectedArea?.id ?? ""] as FilterSpecification,
		[selectedArea]
	);

	const monitorsGeoJson = useMemo<FeatureCollection>(
		() => ({
			type: "FeatureCollection",
			features: monitors
				.filter(
					(monitor) =>
						monitor.snowDepth !== "No Data" || monitor.temperature !== "No Data"
				)
				.map((monitor) => ({
					type: "Feature" as const,
					geometry: {
						type: "Point" as const,
						coordinates: [monitor.lng, monitor.lat],
					},
					properties: {
						name: monitor.name,
						temperature: monitor.temperature,
						snowDepth: monitor.snowDepth,
					},
				})),
		}),
		[monitors]
	);

	const handleMouseMove = useCallback((event: MapMouseEvent) => {
		const hoveredFeature = event.features && event.features[0];
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
			areaId: selectedArea?.id || null,
			timestamp: new Date(),
			selectedSnowTypeId: selectedSnowTypeId,
			obstacleIds: selectedObstacleIds,
		},
		3
	);

	const handleClick = useCallback(
		(event: MapMouseEvent) => {
			const feature = event.features && event.features[0];

			setSelectedSnowCategoryId(null);
			setSelectedSnowTypeId(null);
			setSelectedObstacleIds(null);

			// Check if a monitor was clicked
			if (feature?.layer?.id === "monitors-points") {
				const monitor = monitors.find(
					(m) => m.name === feature.properties?.name
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

			const properties = feature.properties as InteractiveAreaProperties;
			setSelectedArea(properties);
			setSelectedMonitor(null);
			form.updateFormData({
				areaId: properties.id,
			});
			form.goToStep(0);
			submitMutation.reset();
		},
		[monitors, form, submitMutation]
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

	const getUpdateDataForArea = (
		areaId: string
	): (typeof mockUpdateData)[0] | undefined => {
		const segmentNumber = parseInt(areaId.split("-")[1]);
		return updateData.find((update) => update.segment === segmentNumber);
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

	const getSnowTypeDetails = (
		snowTypeId: number | null
	): SnowType | undefined => {
		return snowTypes.find((st) => st.id === snowTypeId);
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
			{showLoading && (
				<div
					className={`absolute inset-0 z-50 flex items-center justify-center bg-background backdrop-blur-sm transition-opacity duration-500 ${
						isLoading ? "opacity-100" : "opacity-0"
					}`}
				>
					<div className="flex flex-col items-center gap-4">
						<p className="text-primary text-lg font-medium animate-pulse">
							{t("loading.map")}
						</p>
					</div>
				</div>
			)}
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
					</>
				)}
			</Map>

			{selectedMonitor && (
				<div className="absolute top-12 left-2 bg-background p-2 rounded-lg shadow-lg text-sm flex flex-col gap-2 animate-in fade-in zoom-in-95 duration-200 w-80 max-w-[90vw]">
					<div className="flex flex-col gap-2">
						<h3 className="font-medium text-base">{selectedMonitor.name}</h3>
						<Separator />
						<div className="flex flex-col gap-3">
							<div>
								<p className="text-muted-foreground text-xs">
									{t("monitorInfo.fields.temperature.label")}
								</p>
								{selectedMonitor.temperature === "No Data"
									? t("monitorInfo.fields.temperature.noData")
									: selectedMonitor.temperature}
							</div>
							<div>
								<p className="text-muted-foreground text-xs">
									{t("monitorInfo.fields.snowDepth.label")}
								</p>
								<p className="font-medium">
									{selectedMonitor.snowDepth === "No Data"
										? t("monitorInfo.fields.snowDepth.noData")
										: selectedMonitor.snowDepth}
								</p>
							</div>
							<div className="text-xs text-muted-foreground">
								<p>
									{t("monitorInfo.fields.coordinates.latitude")}:{" "}
									{selectedMonitor.lat.toFixed(4)}
								</p>
								<p>
									{t("monitorInfo.fields.coordinates.longitude")}:{" "}
									{selectedMonitor.lng.toFixed(4)}
								</p>
							</div>
						</div>
					</div>
					<Button
						variant="default"
						onClick={() => setSelectedMonitor(null)}
						className="w-full"
					>
						{t("reportForm.buttons.close")}
					</Button>
				</div>
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

											const userUpdate = getLatestUserUpdateForArea(updateData);
											const guideUpdate =
												getLatestGuideUpdateForArea(updateData);

											return (
												<>
													{guideUpdate && (
														<div className="text-sm text-primary">
															<p>
																{t("reportForm.lastUpdate.guide", {
																	time: getPrettyTimeDiff(
																		new Date(guideUpdate.time)
																	),
																})}
															</p>
															<p className="font-medium">
																{t(
																	`reportForm.snowTypes.${guideUpdate.snowTypeId1}.name`
																)}
															</p>
															<p className="text-xs">
																{t(
																	`reportForm.snowTypes.${guideUpdate.snowTypeId1}.description`
																)}
															</p>
														</div>
													)}
													{userUpdate && guideUpdate && <Separator />}
													{userUpdate && (
														<div className="text-xs text-muted-foreground">
															<p>{t("reportForm.observationType.visitor")}</p>
															<div className="text-primary flex flex-col">
																<p>
																	{t("reportForm.lastUpdate.visitor", {
																		time: getPrettyTimeDiff(
																			new Date(userUpdate.time)
																		),
																	})}
																</p>
																<p className="font-medium">
																	{t(
																		`reportForm.snowTypes.${userUpdate.snowTypeId}.name`
																	)}
																</p>
																<p className="text-xs">
																	{t(
																		`reportForm.snowTypes.${userUpdate.snowTypeId}.description`
																	)}
																</p>
															</div>
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
							<>
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
												.filter((st) => st.categoryId === null)
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
										<Button
											variant="secondary"
											onClick={() => form.goToStep(0)}
										>
											{t("reportForm.buttons.back")}
										</Button>
									</div>
								</div>
							</>
						)}
						{form.currentStep === 2 && (
							<>
								<div className="flex gap-4 flex-col items-center">
									<div className="flex flex-col gap-2 items-center">
										<p>{t("reportForm.steps.specifySnowType")}</p>
										<div className="grid grid-cols-2 gap-2">
											{snowTypes
												.filter(
													(st) =>
														st.categoryId === selectedSnowCategoryId ||
														st.id === selectedSnowCategoryId
												)
												.map((snowType) => (
													<Button
														key={snowType.id}
														variant="outline"
														onClick={() => {
															setSelectedSnowTypeId(snowType.id);
															form.updateFormData({
																selectedSnowTypeId: snowType.id,
															}); // ADD THIS LINE
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
												`reportForm.snowTypes.${selectedSnowTypeId}.description`
											)}
										</p>
									</div>
									<div className="flex flex-col gap-2 items-center">
										<p>{t("reportForm.obstacles.description")}</p>
										<div className="grid grid-cols-2 gap-2">
											{snowTypes
												.filter((st) => st.categoryId === 7)
												.map((obstacleType) => (
													<Button
														key={obstacleType.id}
														variant="outline"
														onClick={() => {
															let newObstacles = selectedObstacleIds;
															if (
																selectedObstacleIds?.includes(obstacleType.id)
															) {
																newObstacles = selectedObstacleIds.filter(
																	(id) => id !== obstacleType.id
																);
															} else {
																newObstacles = selectedObstacleIds
																	? [...selectedObstacleIds, obstacleType.id]
																	: [obstacleType.id];
															}
															setSelectedObstacleIds(newObstacles);
															form.updateFormData({
																obstacleIds: newObstacles,
															});
														}}
														className={
															selectedObstacleIds?.includes(obstacleType.id)
																? "ring-green-500 ring-2"
																: ""
														}
													>
														{t(`reportForm.snowTypes.${obstacleType.id}.name`)}
													</Button>
												))}
										</div>
									</div>
									<div className="flex gap-2">
										<Button
											variant="secondary"
											onClick={() => {
												setSelectedSnowTypeId(null);
												setSelectedObstacleIds(null);
												submitMutation.reset();
												form.goToStep(1);
											}}
										>
											{t("reportForm.buttons.back")}
										</Button>
										<Button
											onClick={() =>
												submitMutation.mutate({
													areaId: form.formData.areaId,
													selectedSnowTypeId: form.formData.selectedSnowTypeId,
													obstacleIds: form.formData.obstacleIds,
													timestamp: new Date(),
												})
											}
											disabled={
												submitMutation.isPending ||
												(selectedSnowTypeId === null &&
													(!selectedObstacleIds ||
														selectedObstacleIds.length === 0))
											}
										>
											{submitMutation.isPending
												? t("reportForm.buttons.submitting")
												: t("reportForm.buttons.submit")}
										</Button>
									</div>
								</div>
							</>
						)}
					</div>
				</div>
			)}
		</div>
	);
}
