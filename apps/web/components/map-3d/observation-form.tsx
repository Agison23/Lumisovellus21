"use client";

import { useState } from "react";
import { useTranslations } from "next-intl";

import { Button } from "@/components/ui/button";
import type { Obstacles } from "@/hooks/use-observation-mutation";
import type { SnowTypesResponse } from "@/lib/map/loaders";
import {
  getSnowTypeNameById,
  getTranslationKeyForSnowTypeName,
} from "@/lib/utils";

export type SnowType = SnowTypesResponse["data"][number];

export interface ObservationFormProps {
  snowTypes: SnowType[];
  snowTypesLoading: boolean;
  snowTypesError: boolean;
  isPending: boolean;
  onSubmit: (data: {
    selectedSnowTypeId: string;
    obstacles: Obstacles;
    timestamp: Date;
  }) => void;
  onBack: () => void;
}

export function ObservationForm({
  snowTypes,
  snowTypesLoading,
  snowTypesError,
  isPending,
  onSubmit,
  onBack,
}: ObservationFormProps) {
  const t = useTranslations("MapPage");

  // Step 1: select category, Step 2: select specific type + obstacles
  const [step, setStep] = useState<1 | 2>(1);
  const [selectedSnowCategoryId, setSelectedSnowCategoryId] = useState<
    string | null
  >(null);
  const [selectedSnowTypeId, setSelectedSnowTypeId] = useState<string | null>(
    null,
  );
  const [selectedObstacles, setSelectedObstacles] = useState<Obstacles>({
    stones: false,
    branches: false,
  });

  const handleCategorySelect = (categoryId: string) => {
    setSelectedSnowCategoryId(categoryId);
    setSelectedSnowTypeId(categoryId);
    setStep(2);
  };

  const handleBack = () => {
    if (step === 2) {
      setSelectedSnowTypeId(null);
      setSelectedObstacles({ stones: false, branches: false });
      setStep(1);
    } else {
      onBack();
    }
  };

  const handleSubmit = () => {
    if (!selectedSnowTypeId) return;
    onSubmit({
      selectedSnowTypeId,
      obstacles: selectedObstacles,
      timestamp: new Date(),
    });
  };

  if (step === 1) {
    return (
      <div className="flex gap-4 flex-col items-center">
        <div className="flex flex-col gap-2 items-center">
          <p>{t("reportForm.steps.selectSnowType")}</p>
          {snowTypesLoading && <p>{t("loading.snowData")}</p>}
          {snowTypesError && (
            <p className="text-red-500">{t("errors.loadingSnowData")}</p>
          )}
          <div className="grid grid-cols-2 gap-2">
            {snowTypes
              .filter((st) => st.primarySnowTypeId === null)
              .map((snowType) => (
                <Button
                  key={snowType.id}
                  className="text-xs"
                  variant="outline"
                  onClick={() => handleCategorySelect(snowType.id)}
                >
                  {t(
                    `reportForm.snowTypes.${getTranslationKeyForSnowTypeName(
                      getSnowTypeNameById(snowTypes, snowType.id),
                    )}.name`,
                  )}
                </Button>
              ))}
          </div>
        </div>

        <div className="flex gap-2">
          <Button variant="secondary" onClick={onBack}>
            {t("reportForm.buttons.back")}
          </Button>
        </div>
      </div>
    );
  }

  return (
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
                onClick={() => setSelectedSnowTypeId(snowType.id)}
                className={`text-xs ${
                  selectedSnowTypeId === snowType.id
                    ? "ring-green-500 ring-2"
                    : ""
                }`}
              >
                {t(
                  `reportForm.snowTypes.${getTranslationKeyForSnowTypeName(
                    getSnowTypeNameById(snowTypes, snowType.id),
                  )}.name`,
                )}
              </Button>
            ))}
        </div>
        <p className="text-center">
          {t(
            `reportForm.snowTypes.${getTranslationKeyForSnowTypeName(
              getSnowTypeNameById(snowTypes, selectedSnowTypeId || ""),
            )}.description`,
          )}
        </p>
      </div>
      <div className="flex flex-col gap-2 items-center">
        <p>{t("reportForm.obstacles.description")}</p>
        <div className="grid grid-cols-2 gap-2">
          <Button
            variant="outline"
            onClick={() => {
              setSelectedObstacles((prev) => ({
                ...prev,
                stones: !prev.stones,
              }));
            }}
            className={selectedObstacles.stones ? "ring-green-500 ring-2" : ""}
          >
            {t("reportForm.obstacles.stones.name")}
          </Button>
          <Button
            variant="outline"
            onClick={() => {
              setSelectedObstacles((prev) => ({
                ...prev,
                branches: !prev.branches,
              }));
            }}
            className={
              selectedObstacles.branches ? "ring-green-500 ring-2" : ""
            }
          >
            {t("reportForm.obstacles.branches.name")}
          </Button>
        </div>
      </div>
      <div className="flex gap-2">
        <Button variant="secondary" onClick={handleBack}>
          {t("reportForm.buttons.back")}
        </Button>
        <Button onClick={handleSubmit}>
          {isPending
            ? t("reportForm.buttons.submitting")
            : t("reportForm.buttons.submit")}
        </Button>
      </div>
    </div>
  );
}
