"use client";

import { useQuery } from "@tanstack/react-query";
import { useTranslations } from "next-intl";
import { useMemo, useState } from "react";
import { Input } from "@/components/ui/input";
import { fetchSnowTypes } from "@/lib/map/loaders";
import { getTranslationKeyForSnowTypeName } from "@/lib/utils";

export default function DefinitionsPage() {
  const t = useTranslations("DefinitionsPage");
  const snowTypesTranslations = useTranslations("MapPage.reportForm.snowTypes");

  const {
    data: snowTypes = [],
    isLoading,
    isError,
  } = useQuery({
    queryKey: ["snowTypes"],
    queryFn: fetchSnowTypes,
    staleTime: 60 * 60 * 1000,
  });

  const [searchTerm, setSearchTerm] = useState("");

  const filteredSnowTypes = useMemo(() => {
    if (searchTerm.trim() === "") {
      return snowTypes;
    }

    const tokens = searchTerm.toLowerCase().split(" ").filter(Boolean);

    return snowTypes.filter((snowType) => {
      const translationKey = getTranslationKeyForSnowTypeName(snowType.name);
      const translatedName = snowTypesTranslations(`${translationKey}.name`);
      const translatedDescription = snowTypesTranslations(
        `${translationKey}.description`,
      );

      return tokens.every(
        (token) =>
          snowType.name.toLowerCase().includes(token) ||
          snowType.id.toLowerCase().includes(token) ||
          translatedName.toLowerCase().includes(token) ||
          translatedDescription.toLowerCase().includes(token),
      );
    });
  }, [snowTypes, searchTerm, snowTypesTranslations]);

  return (
    <div className="p-2 flex flex-col gap-4 w-full overflow-hidden h-full">
      <h1 className="text-2xl font-bold pl-8">{t("title")}</h1>
      {isLoading && <p>{t("loading")}</p>}
      {isError && <p>{t("errors.loadingFailed")}</p>}
      {!isLoading && !isError && (
        <>
          <div className="flex flex-col gap-4">
            <Input
              onChange={(e) => setSearchTerm(e.target.value)}
              value={searchTerm}
              placeholder={t("search.placeholder")}
            />
          </div>
          <div className="flex-1 overflow-y-auto pb-14">
            {filteredSnowTypes.length > 0 && (
              <section>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-2">
                  {filteredSnowTypes.map((snowType) => {
                    const translationKey = getTranslationKeyForSnowTypeName(
                      snowType.name,
                    );
                    const translatedName = snowTypesTranslations(
                      `${translationKey}.name`,
                    );
                    const translatedDescription = snowTypesTranslations(
                      `${translationKey}.description`,
                    );

                    return (
                      <div
                        key={snowType.id}
                        className="border p-4 rounded-lg bg-card text-card-foreground shadow-sm"
                      >
                        <h3 className="font-semibold mb-2">{translatedName}</h3>
                        <div className="text-sm">
                          <p className="text-muted-foreground">
                            {translatedDescription || t("labels.noDescription")}
                          </p>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </section>
            )}

            {filteredSnowTypes.length === 0 && (
              <p className="text-center text-muted-foreground mt-8">
                {t("noResults")}
              </p>
            )}
          </div>
        </>
      )}
    </div>
  );
}
