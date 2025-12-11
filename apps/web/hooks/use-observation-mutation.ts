"use client";

import type { paths } from "@lumisovellus/api-client-web";
import { useMutation } from "@tanstack/react-query";

import { getAccessTokenAction } from "@/app/(auth)/actions";
import { clientApiUrl } from "@/lib/map/loaders";

export type Obstacles = {
  stones: boolean;
  branches: boolean;
};

export interface ObservationData {
  segmentId: string | null;
  selectedSnowTypeId: string | null;
  obstacles?: Obstacles | null;
  timestamp: Date | null;
}

const submitObservation = async (data: ObservationData) => {
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

  const response = await fetch(
    `${clientApiUrl}/api/v1/segments/${data.segmentId}/reviews`,
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

export interface UseObservationMutationOptions {
  onSuccess?: () => void;
  onError?: (error: Error) => void;
}

export function useObservationMutation(
  options?: UseObservationMutationOptions,
) {
  return useMutation({
    mutationFn: submitObservation,
    onSuccess: options?.onSuccess,
    onError: options?.onError,
  });
}
