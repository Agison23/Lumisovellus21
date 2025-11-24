import { Monitor } from "./types";

export const DEFAULT_MONITORS: Monitor[] = [
	{
		lat: 68.045527778,
		lng: 24.06225,
		name: "Aistin Level Pro #12648",
		temperatureString: "No Data",
		temperature: "No Data",
		snowDepthString: "No Data",
		snowDepth: "No Data",
	},
	{
		lat: 68.079611111,
		lng: 24.070944444,
		name: "Aistin Level Pro #12649",
		temperatureString: "No Data",
		temperature: "No Data",
		snowDepthString: "No Data",
		snowDepth: "No Data",
	},
	{
		name: "Pallas - huippu",
		lat: 68.059666819,
		lng: 24.03386725,
		temperatureString: "No Data",
		temperature: "No Data",
		snowDepthString: "No Data",
		snowDepth: "No Data",
	},
	{
		name: "Pallas - metsä",
		lat: 68.046281479,
		lng: 24.05705337,
		temperatureString: "No Data",
		temperature: "No Data",
		snowDepthString: "No Data",
		snowDepth: "No Data",
	},
];

export const DEFAULT_BOUNDING_BOX: [[number, number], [number, number]] = [
	[23.5, 67.5],
	[24.5, 68.5],
];

export const API_ENDPOINTS = {
	login: "https://app.snower.fi/api/login",
	monitorsList: "https://app.snower.fi/api/monitors_list",
	activeStatus: "https://app.snower.fi/api/monitor_active_status",
	location: "https://app.snower.fi/api/monitor_location",
	latestReading: "https://app.snower.fi/api/last_reading",
} as const;

export const CACHE_CONFIG = {
	key: "snower_monitor_data",
	ttl: 1000 * 60 * 30, // 30 minutes
} as const;
