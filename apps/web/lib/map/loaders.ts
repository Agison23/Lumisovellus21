import { Monitor } from "../snower/types";
import {
	InteractiveAreaFeature,
	SnowType,
	UpdateData,
	mapAreas2,
	mockSnowData,
	mockUpdateData,
} from "./mock-data";

// for now, mock fetching from the API
export const fetchAreas = async (): Promise<InteractiveAreaFeature[]> => {
	await new Promise((resolve) => setTimeout(resolve, 500));
	// throw new Error("Mock error fetching area types");
	return mapAreas2;
};

export const fetchSnowTypes = async (): Promise<SnowType[]> => {
	await new Promise((resolve) => setTimeout(resolve, 500));
	// mock if api throws error
	// throw new Error("Mock error fetching snow types");
	return mockSnowData;
};

export const fetchUpdateData = async (): Promise<UpdateData[]> => {
	await new Promise((resolve) => setTimeout(resolve, 500));
	// throw new Error("Mock error fetching update data");
	return mockUpdateData;
};

export const fetchMonitorData = async (): Promise<Monitor[]> => {
	const res = await fetch("/api/snower");
	// throw new Error("Mock error fetching monitor data");

	if (!res.ok) {
		throw new Error("Failed to fetch monitor data");
	}
	return res.json();
};
