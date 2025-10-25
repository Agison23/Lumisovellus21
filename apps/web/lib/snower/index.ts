import {
	Monitor,
	MonitorLocation,
	SnowerAPIConfig,
	ReadingData,
} from "./types";
import {
	DEFAULT_MONITORS,
	DEFAULT_BOUNDING_BOX,
	API_ENDPOINTS,
} from "./constants";
import { formatValue, mergeMonitors, isWithinBounds } from "./utils";

export class SnowerAPIError extends Error {
	constructor(
		message: string,
		public readonly cause?: unknown
	) {
		super(message);
		this.name = "SnowerAPIError";
	}
}

export class SnowerAPI {
	private authKey: string = process.env.SNOWER_API_KEY || "";
	private readonly boundingBox: [[number, number], [number, number]];
	private readonly area: string;

	constructor(config: SnowerAPIConfig = {}) {
		if (!this.authKey) {
			console.warn(
				"SNOWER_API_KEY is not set. Please set it in your environment variables."
			);
		}
		this.boundingBox = config.bounds || DEFAULT_BOUNDING_BOX;
		this.area = config.area || "Pallas";
	}

	private async fetchAPI<T>(
		url: string,
		body: Record<string, unknown>,
		requiresAuth = true
	): Promise<T> {
		try {
			const headers: HeadersInit = {
				"Content-Type": "text/plain",
				"domain-id": "public",
			};

			if (requiresAuth) {
				headers["authentication-key"] = this.authKey;
			}

			console.log(`Fetching API: ${url} with body:`, body);

			const response = await fetch(url, {
				method: "POST",
				headers,
				body: JSON.stringify(body),
				next: { revalidate: 1800 }, // Cache for 30 minutes
			});

			if (!response.ok) {
				throw new SnowerAPIError(
					`API request failed: ${response.status} ${response.statusText}`
				);
			}

			return await response.json();
		} catch (error) {
			if (error instanceof SnowerAPIError) throw error;
			throw new SnowerAPIError("Network request failed", error);
		}
	}

	async authenticate(): Promise<void> {
		try {
			if (!process.env.SNOWER_USERNAME || !process.env.SNOWER_PASSWORD) {
				console.warn(
					"SNOWER_USERNAME or SNOWER_PASSWORD is not set. Skipping authentication."
				);
				return;
			}
			const data = await this.fetchAPI<{ authentication_key?: string }>(
				API_ENDPOINTS.login,
				{
					username: process.env.SNOWER_USERNAME,
					password: process.env.SNOWER_PASSWORD,
				},
				false
			);

			if (data.authentication_key) {
				this.authKey = data.authentication_key;
			}
		} catch (error) {
			console.error("Authentication failed, using default key:", error);
		}
	}

	async getMonitorList(): Promise<string[]> {
		try {
			const monitors = await this.fetchAPI<string[]>(
				API_ENDPOINTS.monitorsList,
				{ area: this.area }
			);
			return monitors;
		} catch (error) {
			console.error("Failed to fetch monitor list:", error);
			return DEFAULT_MONITORS.map((m) => m.name);
		}
	}

	async getActiveMonitors(monitorNames: string[]): Promise<string[]> {
		try {
			const statusChecks = await Promise.allSettled(
				monitorNames.map(async (monitor) => {
					const data = await this.fetchAPI<{ active_status?: boolean }>(
						API_ENDPOINTS.activeStatus,
						{ monitor, area: this.area }
					);
					return data.active_status === true ? monitor : null;
				})
			);

			return statusChecks
				.filter(
					(result): result is PromiseFulfilledResult<string> =>
						result.status === "fulfilled" && result.value !== null
				)
				.map((result) => result.value);
		} catch (error) {
			console.error("Failed to check monitor status:", error);
			return monitorNames;
		}
	}

	async getMonitorLocations(monitorNames: string[]): Promise<Monitor[]> {
		try {
			const locationPromises = monitorNames.map(async (monitor) => {
				try {
					const data = await this.fetchAPI<{ location?: MonitorLocation }>(
						API_ENDPOINTS.location,
						{ monitor, area: this.area }
					);

					if (!data.location?.lat || !data.location?.lng) {
						return null;
					}

					const { lat, lng } = data.location;

					if (!isWithinBounds(lat, lng, this.boundingBox)) {
						return null;
					}

					return {
						name: monitor,
						lat,
						lng,
						temperature: "No Data",
						snowDepth: "No Data",
					} as Monitor;
				} catch {
					return null;
				}
			});

			const results = await Promise.allSettled(locationPromises);

			return results
				.filter(
					(result): result is PromiseFulfilledResult<Monitor> =>
						result.status === "fulfilled" && result.value !== null
				)
				.map((result) => result.value);
		} catch (error) {
			console.error("Failed to fetch monitor locations:", error);
			return [];
		}
	}

	async getMonitorReadings(monitors: Monitor[]): Promise<Monitor[]> {
		try {
			const readingPromises = monitors.map(async (monitor) => {
				try {
					const data = await this.fetchAPI<ReadingData>(
						API_ENDPOINTS.latestReading,
						{ monitor: monitor.name, area: this.area }
					);

					return {
						...monitor,
						temperature: formatValue(
							data.probe_temperature?.value,
							data.probe_temperature?.unit
						),
						snowDepth: formatValue(
							data.snow_depth?.value,
							data.snow_depth?.unit
						),
					};
				} catch {
					return monitor;
				}
			});

			return await Promise.all(readingPromises);
		} catch (error) {
			console.error("Failed to fetch monitor readings:", error);
			return monitors;
		}
	}

	async getAllMonitorData(): Promise<Monitor[]> {
		try {
			await this.authenticate();
			const monitorNames = await this.getMonitorList();
			const activeMonitors = await this.getActiveMonitors(monitorNames);
			const monitorsWithLocations =
				await this.getMonitorLocations(activeMonitors);
			const monitorsWithReadings = await this.getMonitorReadings(
				monitorsWithLocations
			);

			console.log("Fetched monitor data:", monitorsWithReadings);
			return mergeMonitors(DEFAULT_MONITORS, monitorsWithReadings);
		} catch (error) {
			console.error("Failed to fetch all monitor data:", error);
			return DEFAULT_MONITORS;
		}
	}
}
