"use client";

import type { paths } from "@lumisovellus/api-client-web";
import { useMutation } from "@tanstack/react-query";

import { getAccessTokenAction } from "@/app/(auth)/actions";
import { clientApiUrl } from "@/lib/map/loaders";

export interface GuideUpdateData {
  segmentId: string | null;
  primarySnowTypeIds: string[] | null;
  secondarySnowTypeIds?: string[] | null;
  hazards?: ("stones" | "branches")[] | null;
  description?: string | null;
}

const submitGuideUpdate = async (data: GuideUpdateData) => {
  if (
    !data.segmentId ||
    !data.primarySnowTypeIds ||
    !data.secondarySnowTypeIds
  ) {
    throw new Error();
  }

  // update must have at least one primary snow type
  if (data.primarySnowTypeIds.length === 0) {
    throw new Error("At least one primary snow type must be selected");
  }

  const accessToken = await getAccessTokenAction();
  if (!accessToken) {
    throw new Error("User is not authenticated");
  }

  type GuideUpdateRequestBody =
    paths["/api/v1/segments/{id}/guideUpdate"]["post"]["requestBody"]["content"]["application/json"];

  const requestBody: GuideUpdateRequestBody = {
    primarySnowTypeIds: data.primarySnowTypeIds,
    secondarySnowTypeIds: data.secondarySnowTypeIds,
    hazards:
      data.hazards && data.hazards.length > 0 ? data.hazards : ([] as const),
    description: data.description,
  };

  const response = await fetch(
    `${clientApiUrl}/api/v1/segments/${data.segmentId}/guideUpdate`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify(requestBody),
    },
  );

  if (!response.ok) throw new Error("Failed to submit guide update");
  return response.json();
};

export interface UseGuideUpdateMutationOptions {
  onSuccess?: () => void;
  onError?: (error: Error) => void;
}

export function useGuideUpdateMutation(
  options?: UseGuideUpdateMutationOptions,
) {
  return useMutation({
    mutationFn: submitGuideUpdate,
    onSuccess: options?.onSuccess,
    onError: options?.onError,
  });
}
