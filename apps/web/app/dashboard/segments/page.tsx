"use client";
import { fetchAreas } from "@/lib/map/loaders";
import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";

export default function DashboardPage() {
	const t = useTranslations("Dashboard.SegmentsPage");

	const {
		data: areas = [],
		isLoading,
		isError,
	} = useQuery({
		queryKey: ["mapAreas"],
		queryFn: fetchAreas,
		staleTime: 5 * 60 * 1000, // 5 minutes
	});

	return (
		<div className="p-2 flex flex-col gap-2">
			<h1>{t("title")}</h1>
			{isLoading && <p>Loading areas...</p>}
			{isError && <p>Error loading areas.</p>}
			{!isLoading && !isError && (
				<>
					<div className="grid grid-cols-4 gap-2">
						{areas.map((area) => (
							<div key={area.id} className="p-4 border rounded">
								<h2 className="font-bold">{area.properties.name}</h2>
								<p>{area.properties.terrain}</p>
								<p>ID: {area.properties.id}</p>
								<p>
									Avalanche danger:{" "}
									{area.properties.avalancheDanger ? "True" : "False"}
								</p>
							</div>
						))}
					</div>
				</>
			)}
		</div>
	);
}
