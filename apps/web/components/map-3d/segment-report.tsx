"use client";

import { useTranslations } from "next-intl";

import { Separator } from "@/components/ui/separator";
import type { ReportsResponse, SnowTypesResponse } from "@/lib/map/loaders";
import {
  getPrettyTimeDiff,
  getSnowTypeNameById,
  getTranslationKeyForSnowTypeName,
} from "@/lib/utils";

type UpdateData = ReportsResponse["data"][number];
type SnowType = SnowTypesResponse["data"][number];

const HazardBadges = ({ hazards }: { hazards: ("stones" | "branches")[] }) => {
  const t = useTranslations("MapPage.reportForm.obstacles");
  if (!hazards || hazards.length === 0) return null;
  return (
    <div className="flex gap-1 mt-1">
      {hazards.includes("stones") && (
        <span className="inline-flex items-center gap-1 px-2 py-1 rounded bg-amber-100 text-amber-800 text-xs">
          🪨 {t("stones.name")}
        </span>
      )}
      {hazards.includes("branches") && (
        <span className="inline-flex items-center gap-1 px-2 py-1 rounded bg-orange-100 text-orange-800 text-xs">
          🌿 {t("branches.name")}
        </span>
      )}
    </div>
  );
};

export interface SegmentReportProps {
  updateData: UpdateData;
  snowTypes: SnowType[];
  segmentName: string;
}

export function SegmentReport({
  updateData,
  snowTypes,
  segmentName,
}: SegmentReportProps) {
  const t = useTranslations("MapPage.reportForm");
  const tRoot = useTranslations();

  return (
    <>
      {updateData.guideUpdate && (
        <>
          <div className="text-sm text-primary gap-1">
            {updateData.guideUpdate.description && (
              <div className="flex flex-col gap-0">
                <p className="text-xs text-muted-foreground">
                  {t("observationType.guide", {
                    name: segmentName,
                  })}
                </p>
                <p>{updateData.guideUpdate.description}</p>
              </div>
            )}
            {updateData.guideUpdate.primarySnowTypeIds.map((snowTypeId) => (
              <div key={snowTypeId}>
                <p className="font-medium text-lg">
                  {t(
                    `snowTypes.${getTranslationKeyForSnowTypeName(
                      getSnowTypeNameById(snowTypes, snowTypeId),
                    )}.name`,
                  )}
                </p>
                <p className="text-xs">
                  {t(
                    `snowTypes.${getTranslationKeyForSnowTypeName(
                      getSnowTypeNameById(snowTypes, snowTypeId),
                    )}.description`,
                  )}
                </p>
              </div>
            ))}
            {updateData.guideUpdate.secondarySnowTypeIds.map((snowTypeId) => (
              <div key={snowTypeId}>
                <p className="font-medium text-sm">
                  {t(
                    `snowTypes.${getTranslationKeyForSnowTypeName(
                      getSnowTypeNameById(snowTypes, snowTypeId),
                    )}.name`,
                  )}
                </p>
                <p className="text-xs">
                  {t(
                    `snowTypes.${getTranslationKeyForSnowTypeName(
                      getSnowTypeNameById(snowTypes, snowTypeId),
                    )}.description`,
                  )}
                </p>
              </div>
            ))}
            <HazardBadges hazards={updateData.guideUpdate.hazards} />
          </div>
        </>
      )}
      {updateData.userReviews.length > 0 && updateData.guideUpdate && (
        <Separator />
      )}
      {updateData.userReviews.length > 0 && (
        <div className="text-xs text-muted-foreground">
          <p>{t("observationType.visitor")}</p>
          {updateData.userReviews.map((review, index) => (
            <div key={index} className="text-primary flex flex-col">
              <p className="font-medium text-sm">
                {t(
                  `snowTypes.${getTranslationKeyForSnowTypeName(
                    getSnowTypeNameById(snowTypes, review.snowTypeId),
                  )}.name`,
                )}
                : {getPrettyTimeDiff(new Date(review.submittedAt), tRoot)}
              </p>
              <p className="text-xs">
                {t(
                  `snowTypes.${getTranslationKeyForSnowTypeName(
                    getSnowTypeNameById(snowTypes, review.snowTypeId),
                  )}.description`,
                )}
              </p>
              <HazardBadges
                hazards={review.hazards as ("stones" | "branches")[]}
              />
            </div>
          ))}
        </div>
      )}
    </>
  );
}
