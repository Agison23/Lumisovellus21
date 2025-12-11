"use client";

import { useTranslations } from "next-intl";
import { useState } from "react";

import { SnowTypeCombobox } from "./snow-type-combobox";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";
import type { Obstacles } from "@/hooks/use-observation-mutation";

export interface GuideFormProps {
  segmentId: string;
  snowTypeOptions: { value: string; label: string }[];
  isPending: boolean;
  onSubmit: (data: {
    segmentId: string;
    primarySnowTypeIds: string[];
    secondarySnowTypeIds: string[];
    hazards: ("stones" | "branches")[];
    description: string;
  }) => void;
  onBack: () => void;
}

export function GuideForm({
  segmentId,
  snowTypeOptions,
  isPending,
  onSubmit,
  onBack,
}: GuideFormProps) {
  const t = useTranslations("MapPage");

  const [guidePrimary1, setGuidePrimary1] = useState<string | null>(null);
  const [guidePrimary2, setGuidePrimary2] = useState<string | null>(null);
  const [guideSecondary1, setGuideSecondary1] = useState<string | null>(null);
  const [guideSecondary2, setGuideSecondary2] = useState<string | null>(null);
  const [guideDescription, setGuideDescription] = useState<string>("");
  const [selectedObstacles, setSelectedObstacles] = useState<Obstacles>({
    stones: false,
    branches: false,
  });

  const handleSubmit = () => {
    const primarySnowTypeIds = [guidePrimary1, guidePrimary2].filter(
      Boolean,
    ) as string[];
    const secondarySnowTypeIds = [guideSecondary1, guideSecondary2].filter(
      Boolean,
    ) as string[];
    const hazards: ("stones" | "branches")[] = [];
    if (selectedObstacles.stones) hazards.push("stones");
    if (selectedObstacles.branches) hazards.push("branches");

    onSubmit({
      segmentId,
      primarySnowTypeIds,
      secondarySnowTypeIds,
      hazards,
      description: guideDescription,
    });
  };

  return (
    <div className="flex flex-col gap-4 w-full">
      <div className="flex flex-col gap-2">
        <p className="font-medium">{t("reportForm.steps.selectSnowType")}</p>
        <div className="flex flex-col gap-2">
          <label className="text-xs font-medium">
            {t("reportForm.labels.primarySnowTypes")}
          </label>
          <SnowTypeCombobox
            value={guidePrimary1}
            onChange={setGuidePrimary1}
            options={snowTypeOptions}
            placeholder={`${t("reportForm.labels.primarySnowType")} 1`}
          />
          <SnowTypeCombobox
            value={guidePrimary2}
            onChange={setGuidePrimary2}
            options={snowTypeOptions}
            placeholder={`${t("reportForm.labels.primarySnowType")} 2`}
          />
        </div>
        <div className="flex flex-col gap-2">
          <label className="text-xs font-medium">
            {t("reportForm.labels.secondarySnowTypes")}
          </label>
          <SnowTypeCombobox
            value={guideSecondary1}
            onChange={setGuideSecondary1}
            options={snowTypeOptions}
            placeholder={t("reportForm.labels.secondarySnowType") + " 1"}
          />
          <SnowTypeCombobox
            value={guideSecondary2}
            onChange={setGuideSecondary2}
            options={snowTypeOptions}
            placeholder={t("reportForm.labels.secondarySnowType") + " 2"}
          />
        </div>
      </div>

      <div className="flex flex-col gap-2">
        <p className="font-medium">{t("reportForm.obstacles.description")}</p>
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

      <div className="flex flex-col gap-2">
        <p className="font-medium">{t("reportForm.description.label")}</p>
        <Textarea
          value={guideDescription}
          onChange={(e) => setGuideDescription(e.target.value)}
          placeholder={t("reportForm.description.placeholder")}
        />
      </div>
      <div className="flex gap-2 w-full justify-center">
        <Button variant="secondary" onClick={onBack}>
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
