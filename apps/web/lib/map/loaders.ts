import type { paths } from "@lumisovellus/api-client-web";
import { Monitor } from "../snower/types";



export type SegmentsResponse =
  paths["/api/v1/segments"]["get"]["responses"]["200"]["content"]["application/json"];
export type Segment = SegmentsResponse["data"][number];
export const apiUrl =
  process.env.NEXT_PUBLIC_BACKEND_URL || "http://localhost:3001";

// for now, mock fetching from the API
export const fetchAreas = async (): Promise<SegmentsResponse["data"]> => {
  const res = await fetch(`${apiUrl}/api/v1/segments`);
  if (!res.ok) {
    throw new Error("Failed to fetch areas");
  }

  const data: SegmentsResponse = await res.json();
  return data.data;
};

export type SnowTypesResponse =
  paths["/api/v1/snow-types"]["get"]["responses"]["200"]["content"]["application/json"];

export const fetchSnowTypes = async (): Promise<SnowTypesResponse["data"]> => {
  const res = await fetch(`${apiUrl}/api/v1/snow-types`);
  if (!res.ok) {
    throw new Error("Failed to fetch snow types");
  }

  const data: SnowTypesResponse = await res.json();
  return data.data;
};

export type ReportsResponse =
  paths["/api/v1/observations"]["get"]["responses"]["200"]["content"]["application/json"];

export const fetchUpdateData = async (): Promise<ReportsResponse["data"]> => {
  const res = await fetch(`${apiUrl}/api/v1/observations`);
  if (!res.ok) {
    throw new Error("Failed to fetch update data");
  }

  const data: ReportsResponse = await res.json();
  return data.data;
};

export const fetchMonitorData = async (): Promise<Monitor[]> => {
  const res = await fetch("/api/snower");
  // throw new Error("Mock error fetching monitor data");

  if (!res.ok) {
    throw new Error("Failed to fetch monitor data");
  }
  return res.json();
};
