import { useTranslations } from "next-intl"
export default function Page() {

  const t = useTranslations('WeatherPage')
  return (
    <div>
      <h1>{t('title')}</h1>
      <p>{t('loading')}</p>
    </div>
  )
}
