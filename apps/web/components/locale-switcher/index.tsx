"use client";

import { useLocale, useTranslations } from "next-intl";
import React from "react";
import { LocaleSwitcherSelect } from "./locale-switcher-select";

export default function LocaleSwitcher() {
  const t = useTranslations("LocaleSwitcher");
  const locale = useLocale();

  return (
    <LocaleSwitcherSelect
      defaultValue={locale}
      items={[
        { value: "en", label: t("en") },
        { value: "fi", label: t("fi") },
      ]}
      label={t("label")}
    />
  );
}
