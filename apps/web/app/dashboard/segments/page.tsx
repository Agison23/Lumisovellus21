"use client";
import {
	Dialog,
	DialogDescription,
	DialogTitle,
	DialogTrigger,
} from "@radix-ui/react-dialog";
import { useMutation, useQuery } from "@tanstack/react-query";
import { Edit, Trash } from "lucide-react";
import { useTranslations } from "next-intl";
import { ChangeEvent, useMemo, useRef, useState } from "react";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { DialogContent, DialogHeader } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { fetchAreas } from "@/lib/map/loaders";
import { InteractiveAreaFeature } from "@/lib/map/mock-data";

export default function DashboardPage() {
	const t = useTranslations("Dashboard.SegmentsPage");

	const {
		data: areas = [],
		isLoading,
		isError,
		refetch,
	} = useQuery({
		queryKey: ["mapAreas"],
		queryFn: fetchAreas,
		staleTime: 5 * 60 * 1000, // 5 minutes
	});

	useState<InteractiveAreaFeature[]>(areas);
	const [searchTerm, setSearchTerm] = useState<string>("");

	// Filter areas based on search term
	const filteredSegments = useMemo(() => {
		if (searchTerm.trim() === "") {
			return areas;
		}
		const tokens = searchTerm.toLowerCase().split(" ").filter(Boolean);
		return areas.filter((area) => {
			const name = area.properties.name.toLowerCase();
			const terrain = area.properties.terrain.toLowerCase();
			const id = area.properties.id.toLowerCase();
			return tokens.every(
				(token) =>
					name.includes(token) || terrain.includes(token) || id.includes(token)
			);
		});
	}, [areas, searchTerm]);

	return (
		<div className="p-2 flex flex-col gap-2 w-full overflow-hidden">
			{isLoading && <p>Loading areas...</p>}
			{isError && <p>Error loading areas.</p>}
			{!isLoading && !isError && (
				<>
					<div className="w-full flex gap-2 items-center">
						<Input
							onChange={(e: ChangeEvent<HTMLInputElement>) =>
								setSearchTerm(e.currentTarget.value)
							}
							value={searchTerm}
							placeholder={t("search.placeholder")}
							className="h-max"
						/>
						<CreateAreaDialog t={t} refetch={refetch} />
					</div>
					<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2 overflow-y-auto pb-14">
						{filteredSegments.map((area) => (
							<div
								key={area.properties.id}
								className="border rounded-md text-left px-2 py-2 items-start flex flex-col gap-2 bg-background"
							>
								<div className="flex gap-2 justify-between items-center w-full">
									<h2 className="font-bold">{area.properties.name}</h2>
									<div className="flex items-center gap-1 w-max">
										<DeleteAreaDialog area={area} t={t} refetch={refetch} />
										<EditAreaDialog area={area} t={t} refetch={refetch} />
									</div>
								</div>
								<div className="flex flex-col">
									<p>{area.properties.terrain}</p>
									<p>ID: {area.properties.id}</p>
									<p>
										{t("avalanche.avalancheDanger")}
										{area.properties.avalancheDanger
											? t("avalanche.true")
											: t("avalanche.false")}
									</p>
								</div>
							</div>
						))}
					</div>
				</>
			)}
		</div>
	);
}

function CreateAreaDialog({
	t,
	refetch,
}: {
	t: (key: string, params?: Record<string, string>) => string;
	refetch: () => void;
}) {
	const [open, setOpen] = useState(false);
	const [newArea, setNewArea] = useState<InteractiveAreaFeature>({
		type: "Feature",
		geometry: {
			type: "Polygon",
			coordinates: [[[0, 0]]],
		},
		properties: {
			id: "",
			name: "",
			terrain: "",
			avalancheDanger: false,
			isLowerSegment: null,
		},
	});
	const scrollRefs = useRef<(HTMLDivElement | null)[]>([]);

	const handleCoordinateChange = (
		index: number,
		coordIndex: number,
		positionIndex: number,
		value: string
	) => {
		const numValue = value === "" ? 0 : Number(value);
		const updatedCoordinates = [...newArea.geometry.coordinates];
		updatedCoordinates[index][coordIndex][positionIndex] = numValue;
		setNewArea((prev) => ({
			...prev,
			geometry: {
				...prev.geometry,
				coordinates: updatedCoordinates,
			},
		}));
	};

	const handleCancel = () => {
		setNewArea({
			type: "Feature",
			geometry: {
				type: "Polygon",
				coordinates: [[[0, 0]]],
			},
			properties: {
				id: "",
				name: "",
				terrain: "",
				avalancheDanger: false,
				isLowerSegment: null,
			},
		});
		setOpen(false);
	};

	const mutation = useMutation({
		mutationFn: async (areaToCreate: InteractiveAreaFeature) => {
			return fetch("/api/areas/create", {
				method: "POST",
				body: JSON.stringify(areaToCreate),
			});
		},
		onSuccess: () => {
			toast.success(t("createDialog.success.createSuccessful"));
			refetch();
			handleCancel();
		},
		onError: () => {
			toast.error(t("createDialog.errors.createFailed"));
		},
	});

	const handleCreate = async () => {
		mutation.mutate(newArea);
	};

	const isValid =
		newArea.properties.id.trim() !== "" &&
		newArea.properties.name.trim() !== "" &&
		newArea.properties.terrain.trim() !== "";

	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button>{t("newButton")}</Button>
			</DialogTrigger>
			<DialogContent className="max-h-[80vh] w-full grid-rows-[auto_1fr] overflow-hidden flex flex-col gap-4">
				<DialogHeader>
					<DialogTitle>{t("createDialog.title")}</DialogTitle>
				</DialogHeader>
				<div className="flex flex-col gap-2 min-h-0">
					<div className="flex flex-col gap-1">
						<label className="text-xs">{t("createDialog.id")}</label>
						<Input
							value={newArea.properties.id}
							onChange={(e) =>
								setNewArea((prev) => ({
									...prev,
									properties: { ...prev.properties, id: e.target.value },
								}))
							}
							placeholder="e.g., area-1"
						/>
					</div>
					<div className="flex flex-col gap-1">
						<label className="text-xs">{t("createDialog.name")}</label>
						<Input
							value={newArea.properties.name}
							onChange={(e) =>
								setNewArea((prev) => ({
									...prev,
									properties: { ...prev.properties, name: e.target.value },
								}))
							}
						/>
					</div>
					<div className="flex flex-col gap-1">
						<label className="text-xs">{t("createDialog.terrain")}</label>
						<Input
							value={newArea.properties.terrain}
							onChange={(e) =>
								setNewArea((prev) => ({
									...prev,
									properties: { ...prev.properties, terrain: e.target.value },
								}))
							}
						/>
					</div>
					<div className="flex flex-col gap-1 min-h-0 overflow-hidden">
						<label className="text-xs">
							{t("createDialog.coordinates.title")}
						</label>
						{newArea.geometry.coordinates.map(
							(coordSet: number[][], index: number) => (
								<div
									key={index}
									className="flex flex-col gap-2 min-h-0 border overflow-hidden rounded-md"
								>
									<div
										ref={(el) => {
											scrollRefs.current[index] = el;
										}}
										className="overflow-y-auto min-h-0 p-2"
									>
										{coordSet.map((coord: number[], coordIndex: number) => (
											<div key={coordIndex} className="flex gap-2 mb-1 min-w-0">
												<Input
													placeholder={t("createDialog.coordinates.longitude")}
													value={coord[0]}
													type="number"
													className="min-w-0 flex-1 no-spinner"
													onChange={(e) =>
														handleCoordinateChange(
															index,
															coordIndex,
															0,
															e.target.value
														)
													}
												/>
												<Input
													placeholder={t("createDialog.coordinates.latitude")}
													value={coord[1]}
													type="number"
													className="min-w-0 flex-1 no-spinner"
													onChange={(e) =>
														handleCoordinateChange(
															index,
															coordIndex,
															1,
															e.target.value
														)
													}
												/>
												<Button
													variant="outline"
													className="shrink-0"
													onClick={() => {
														const updatedCoordinates = [
															...newArea.geometry.coordinates,
														];
														updatedCoordinates[index].splice(coordIndex, 1);
														setNewArea((prev) => ({
															...prev,
															geometry: {
																...prev.geometry,
																coordinates: updatedCoordinates,
															},
														}));
													}}
												>
													<Trash />
												</Button>
											</div>
										))}
									</div>
									<Button
										variant="outline"
										className="flex-1 shrink-0 mb-2 mx-2"
										onClick={() => {
											const updatedCoordinates = [
												...newArea.geometry.coordinates,
											];
											updatedCoordinates[index].push([0, 0]);
											setNewArea((prev) => ({
												...prev,
												geometry: {
													...prev.geometry,
													coordinates: updatedCoordinates,
												},
											}));
											// Scroll to bottom after adding coordinate
											setTimeout(() => {
												const scrollEl = scrollRefs.current[index];
												if (scrollEl) {
													scrollEl.scrollTop = scrollEl.scrollHeight;
												}
											}, 0);
										}}
									>
										{t("createDialog.coordinates.addCoordinate")}
									</Button>
								</div>
							)
						)}
					</div>

					<div className="flex flex-col gap-1">
						<label className="text-xs">
							{t("createDialog.avalanche.title")}
						</label>
						<div className="flex gap-2 items-center">
							<Checkbox
								checked={newArea.properties.avalancheDanger}
								onCheckedChange={(checked) =>
									setNewArea((prev) => ({
										...prev,
										properties: {
											...prev.properties,
											avalancheDanger: Boolean(checked),
										},
									}))
								}
							/>
							<span>{t("createDialog.avalanche.toggleAvalancheWarning")}</span>
						</div>
					</div>
					<div className="flex gap-2 w-full shrink-0">
						<Button
							onClick={() => handleCancel()}
							variant="outline"
							className="flex-1"
							disabled={mutation.isPending}
						>
							{t("createDialog.buttons.cancel")}
						</Button>
						<Button
							disabled={mutation.isPending || !isValid}
							onClick={() => handleCreate()}
							className="flex-1"
						>
							{mutation.isPending
								? t("createDialog.buttons.creating")
								: t("createDialog.buttons.create")}
						</Button>
					</div>
				</div>
			</DialogContent>
		</Dialog>
	);
}

function EditAreaDialog({
	area,
	t,
	refetch,
}: {
	area: InteractiveAreaFeature;
	t: (key: string, params?: Record<string, string>) => string;
	refetch: () => void;
}) {
	const [open, setOpen] = useState(false);
	const [editArea, setEditArea] = useState<InteractiveAreaFeature>(
		JSON.parse(JSON.stringify(area))
	);
	const scrollRefs = useRef<(HTMLDivElement | null)[]>([]);

	const handleCoordinateChange = (
		index: number,
		coordIndex: number,
		positionIndex: number,
		value: string
	) => {
		const numValue = value === "" ? 0 : Number(value);
		const updatedCoordinates = [...editArea.geometry.coordinates];
		updatedCoordinates[index][coordIndex][positionIndex] = numValue;
		setEditArea((prev) => ({
			...prev,
			geometry: {
				...prev.geometry,
				coordinates: updatedCoordinates,
			},
		}));
	};

	const handleCancel = () => {
		setEditArea(area);
		setOpen(false);
	};

	const mutation = useMutation({
		mutationFn: async (updatedArea: InteractiveAreaFeature) => {
			return fetch("/api/areas", {
				method: "POST",
				body: JSON.stringify(updatedArea),
			});
		},
		onSuccess: () => {
			toast.success(t("editDialog.success.saveSuccessful"));
			refetch();
			setOpen(false);
		},
		onError: () => {
			toast.error(t("editDialog.errors.saveFailed"));
		},
	});

	const handleSave = async () => {
		mutation.mutate(editArea);
	};

	const hasBeenModified = JSON.stringify(area) !== JSON.stringify(editArea);

	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button variant="outline" size="icon" className="p-1">
					<Edit size={20} />
				</Button>
			</DialogTrigger>
			<DialogContent className="max-h-[80vh] w-full grid-rows-[auto_1fr] overflow-hidden flex flex-col gap-4">
				<DialogHeader>
					<DialogTitle>
						{t("editDialog.title", {
							name: area.properties.name,
						})}
					</DialogTitle>
				</DialogHeader>
				<div className="flex flex-col gap-2 min-h-0">
					<div className="flex flex-col gap-1">
						<label className="text-xs">{t("editDialog.name")}</label>
						<Input
							value={editArea.properties.name}
							onChange={(e) =>
								setEditArea((prev) => ({
									...prev,
									properties: { ...prev.properties, name: e.target.value },
								}))
							}
						/>
					</div>
					<div className="flex flex-col gap-1">
						<label className="text-xs">{t("editDialog.terrain")}</label>
						<Input
							value={editArea.properties.terrain}
							onChange={(e) =>
								setEditArea((prev) => ({
									...prev,
									properties: { ...prev.properties, terrain: e.target.value },
								}))
							}
						/>
					</div>
					<div className="flex flex-col gap-1 min-h-0 overflow-hidden">
						<label className="text-xs">
							{t("editDialog.coordinates.title")}
						</label>
						{editArea.geometry.coordinates.map(
							(coordSet: number[][], index: number) => (
								<div
									key={index}
									className="flex flex-col gap-2 min-h-0 border overflow-hidden rounded-md"
								>
									<div
										ref={(el) => {
											scrollRefs.current[index] = el;
										}}
										className="overflow-y-auto min-h-0 p-2"
									>
										{coordSet.map((coord: number[], coordIndex: number) => (
											<div key={coordIndex} className="flex gap-2 mb-1 min-w-0">
												<Input
													placeholder={t("editDialog.coordinates.longitude")}
													value={coord[0]}
													type="number"
													className="min-w-0 flex-1 no-spinner"
													onChange={(e) =>
														handleCoordinateChange(
															index,
															coordIndex,
															0,
															e.target.value
														)
													}
												/>
												<Input
													placeholder={t("editDialog.coordinates.latitude")}
													value={coord[1]}
													type="number"
													className="min-w-0 flex-1 no-spinner"
													onChange={(e) =>
														handleCoordinateChange(
															index,
															coordIndex,
															1,
															e.target.value
														)
													}
												/>
												<Button
													variant="outline"
													className="shrink-0"
													onClick={() => {
														const updatedCoordinates = [
															...editArea.geometry.coordinates,
														];
														updatedCoordinates[index].splice(coordIndex, 1);
														setEditArea((prev) => ({
															...prev,
															geometry: {
																...prev.geometry,
																coordinates: updatedCoordinates,
															},
														}));
													}}
												>
													<Trash />
												</Button>
											</div>
										))}
									</div>
									<Button
										variant="outline"
										className="flex-1 shrink-0 mb-2 mx-2"
										onClick={() => {
											const updatedCoordinates = [
												...editArea.geometry.coordinates,
											];
											updatedCoordinates[index].push([0, 0]);
											setEditArea((prev) => ({
												...prev,
												geometry: {
													...prev.geometry,
													coordinates: updatedCoordinates,
												},
											}));
											// Scroll to bottom after adding coordinate
											setTimeout(() => {
												const scrollEl = scrollRefs.current[index];
												if (scrollEl) {
													scrollEl.scrollTop = scrollEl.scrollHeight;
												}
											}, 0);
										}}
									>
										{t("editDialog.coordinates.addCoordinate")}
									</Button>
								</div>
							)
						)}
					</div>

					<div className="flex flex-col gap-1">
						<label className="text-xs">{t("editDialog.avalanche.title")}</label>
						<div className="flex gap-2 items-center">
							<Checkbox
								checked={editArea.properties.avalancheDanger}
								onCheckedChange={(checked) =>
									setEditArea((prev) => ({
										...prev,
										properties: {
											...prev.properties,
											avalancheDanger: Boolean(checked),
										},
									}))
								}
							/>
							<span>{t("editDialog.avalanche.toggleAvalancheWarning")}</span>
						</div>
					</div>
					<div className="flex gap-2 w-full shrink-0">
						<Button
							onClick={() => handleCancel()}
							variant="outline"
							className="flex-1"
							disabled={mutation.isPending}
						>
							{t("editDialog.buttons.cancel")}
						</Button>
						<Button
							disabled={mutation.isPending || !hasBeenModified}
							onClick={() => handleSave()}
							className="flex-1"
						>
							{mutation.isPending
								? t("editDialog.buttons.saving")
								: t("editDialog.buttons.save")}
						</Button>
					</div>
				</div>
			</DialogContent>
		</Dialog>
	);
}

function DeleteAreaDialog({
	area,
	t,
	refetch,
}: {
	area: InteractiveAreaFeature;
	t: (key: string, params?: Record<string, string>) => string;
	refetch: () => void;
}) {
	const [open, setOpen] = useState(false);

	const deleteMutation = useMutation({
		mutationFn: async (areaId: string) => {
			return fetch(`/api/areas/${areaId}`, {
				method: "DELETE",
			});
		},
		onSuccess: () => {
			toast.success(t("deleteDialog.success.deleteSuccessful"));
			refetch();
			setOpen(false);
		},
		onError: () => {
			toast.error(t("deleteDialog.errors.deleteFailed"));
		},
	});

	const handleDelete = () => {
		deleteMutation.mutate(area.properties.id);
	};

	return (
		<Dialog open={open} onOpenChange={setOpen}>
			<DialogTrigger asChild>
				<Button variant="outline" size="icon" className="p-1">
					<Trash size={20} />
				</Button>
			</DialogTrigger>
			<DialogContent>
				<DialogHeader>
					<DialogTitle>
						{t("deleteDialog.title", {
							name: area.properties.name,
						})}
					</DialogTitle>
					<DialogDescription>{t("deleteDialog.message")}</DialogDescription>
				</DialogHeader>
				<div className="flex gap-2 w-full">
					<DialogTrigger asChild>
						<Button
							onClick={() => setOpen(false)}
							variant="outline"
							className="flex-1"
							disabled={deleteMutation.isPending}
						>
							{t("deleteDialog.buttons.cancel")}
						</Button>
					</DialogTrigger>
					<Button
						onClick={() => handleDelete()}
						variant="destructive"
						className="flex-1"
						disabled={deleteMutation.isPending}
					>
						{deleteMutation.isPending
							? t("deleteDialog.buttons.deleting")
							: t("deleteDialog.buttons.delete")}
					</Button>
				</div>
			</DialogContent>
		</Dialog>
	);
}
