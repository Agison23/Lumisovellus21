"use client";
import { getAccessTokenAction } from "@/app/(auth)/actions";
import { Input } from "@/components/ui/input";
import { apiUrl, fetchAreas, fetchSnowTypes, fetchUpdateData } from "@/lib/map/loaders";
import { getSnowTypeNameById, getTranslationKeyForSnowTypeName } from "@/lib/utils";
import { paths } from "@lumisovellus/api-client-web";
import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";
import { useMemo, useState } from "react";

export default function ReportsPage() {
	const t = useTranslations("Dashboard.ReportsPage");
  const snowTypesTranslations = useTranslations("MapPage.reportForm.snowTypes");
  const {
    data: reports = [],
    isLoading,
    isError,
  } = useQuery({
    queryKey: ["reports"],
    queryFn: fetchUpdateData,
    staleTime: 60 * 60 * 1000,
  })

  const {
    data: segments = [],
    isLoading: segmentsLoading,
    isError: segmentsError,
  } = useQuery({
    queryKey: ["segments"],
    queryFn: fetchAreas,
    staleTime: 60 * 60 * 1000,
  })

  const {
    data: snowTypes = [],
    isLoading: snowTypesLoading,
    isError: snowTypesError,
  } = useQuery({
    queryKey: ["snowTypes"],
    queryFn: fetchSnowTypes,
    staleTime: 60 * 60 * 1000,
  })

  const [searchTerm, setSearchTerm] = useState("");

  const { guideUpdates, userReviews } = useMemo(() => {
    const allGuideUpdates = reports
      .filter(r => r.guideUpdate)
      .map(r => ({
        segmentId: r.segmentId,
        ...r.guideUpdate!
      }));

    const allUserReviews = reports.flatMap(r => 
      r.userReviews.map(review => ({
        segmentId: r.segmentId,
        ...review
      }))
    );

    if (searchTerm.trim() === "") {
      return { guideUpdates: allGuideUpdates, userReviews: allUserReviews };
    }

    const tokens = searchTerm.toLowerCase().split(" ").filter(Boolean);

    const filteredGuideUpdates = allGuideUpdates.filter(update => 
      tokens.every(token => 
        update.segmentId.toLowerCase().includes(token) ||
        update.description?.toLowerCase().includes(token) ||
        update.hazards.some(h => h.toLowerCase().includes(token)) ||
        update.primarySnowTypeIds.some(id => id.toLowerCase().includes(token)) ||
        update.secondarySnowTypeIds.some(id => id.toLowerCase().includes(token))
        || update.primarySnowTypeIds.some(id => snowTypes.find(s => s.id === id)?.name.toLowerCase().includes(token))
        || update.secondarySnowTypeIds.some(id => snowTypes.find(s => s.id === id)?.name.toLowerCase().includes(token))
        || update.primarySnowTypeIds.some(id => snowTypesTranslations(`${getTranslationKeyForSnowTypeName(getSnowTypeNameById(snowTypes, id))}.name`).toLowerCase().includes(token))
        || update.secondarySnowTypeIds.some(id => snowTypesTranslations(`${getTranslationKeyForSnowTypeName(getSnowTypeNameById(snowTypes, id))}.name`).toLowerCase().includes(token))
        || segments.find(s => s.id === update.segmentId)?.name.toLowerCase().includes(token)
      )
    );

    const filteredUserReviews = allUserReviews.filter(review => 
      tokens.every(token => 
        review.segmentId.toLowerCase().includes(token) ||
        review.snowTypeId.toLowerCase().includes(token) ||
        review.hazards.some(h => h.toLowerCase().includes(token)) ||
        review.submittedAt.toLowerCase().includes(token)
        || snowTypes.find(s => s.id === review.snowTypeId)?.name.toLowerCase().includes(token)
        || snowTypesTranslations(`${getTranslationKeyForSnowTypeName(getSnowTypeNameById(snowTypes, review.snowTypeId))}.name`).toLowerCase().includes(token)
        || segments.find(s => s.id === review.segmentId)?.name.toLowerCase().includes(token)
      )
    );

    return { guideUpdates: filteredGuideUpdates, userReviews: filteredUserReviews };
  }, [reports, searchTerm]);

	return (
    <div className="p-2 flex flex-col gap-4 w-full overflow-hidden h-full">
      {isLoading || segmentsLoading || snowTypesLoading && <p>{t('loading')}</p>}
      {isError || segmentsError || snowTypesError && <p>{t('errors.loadingFailed')}</p>}
      {!isLoading && !isError && (
        <>
          <Input
            onChange={(e) => setSearchTerm(e.target.value)}
            value={searchTerm}
            placeholder={t('search.placeholder')}
          />
          
          <div className="flex-1 overflow-y-auto space-y-6 pb-14">
            {guideUpdates.length > 0 && (
              <section>
                <h2 className="text-xl font-bold mb-4">{t('labels.guideUpdates')}</h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2">
                  {guideUpdates.map((update, i) => (
                    <div key={`${update.segmentId}-${i}`} className="border p-4 rounded-lg bg-card text-card-foreground shadow-sm">
                      <h3 className="font-semibold mb-2">{segments.find(s => s.id === update.segmentId)?.name}</h3>
                      <div className="text-sm">
                        <p>{t('labels.description')}: {update.description}</p>
                        <p>{t('labels.hazards')}: {update.hazards.join(", ") || "None"}</p>
                        <p>{t('labels.primarySnowType')}: {update.primarySnowTypeIds.length > 0 ? update.primarySnowTypeIds.map(id => snowTypesTranslations(`${getTranslationKeyForSnowTypeName(getSnowTypeNameById(snowTypes, id))}.name`)).join(", ") : "None"}</p>
                        <p>{t('labels.secondarySnowType')}: {update.secondarySnowTypeIds.length > 0 ? update.secondarySnowTypeIds.map(id => snowTypesTranslations(`${getTranslationKeyForSnowTypeName(getSnowTypeNameById(snowTypes, id))}.name`)).join(", ") : "None"}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </section>
            )}

            {userReviews.length > 0 && (
              <section>
                <h2 className="text-xl font-bold mb-4">{t('labels.userReviews')}</h2>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2">
                  {userReviews.map((review, i) => (
                    <div key={`${review.segmentId}-${review.submittedAt}-${i}`} className="border p-4 rounded-lg bg-card text-card-foreground shadow-sm">
                      <h3 className="font-semibold mb-2">{segments.find(s => s.id === review.segmentId)?.name}</h3>
                      <p className="text-xs text-muted-foreground mb-1">
                        {new Date(review.submittedAt).toLocaleDateString()}{' '}
                        {new Date(review.submittedAt).toLocaleTimeString()} 
                      </p>
                      <div className="text-sm">
                        <p>{t('labels.snowType')}: {snowTypesTranslations(`${getTranslationKeyForSnowTypeName(getSnowTypeNameById(snowTypes, review.snowTypeId))}.name`)}</p>
                        <p>{t('labels.hazards')}: {review.hazards.join(", ") || "None"}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </section>
            )}
            
            {guideUpdates.length === 0 && userReviews.length === 0 && (
               <p className="text-center text-muted-foreground mt-8">No reports found</p>
            )}
          </div>
        </>
      )}
    </div>
  )
}
