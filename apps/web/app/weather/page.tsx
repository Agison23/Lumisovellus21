"use client";
import { useTranslations } from "next-intl"
export default function Page() {

  const t = useTranslations('WeatherPage')
  return (
    <div className="pt-2.5 px-12">
      <h1>{t('title')}</h1>
      <p>{t('loading')}</p>
    </div>
  )
}
