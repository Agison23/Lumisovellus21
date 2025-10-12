import { useTranslations } from "next-intl"
export default function Page() {

  const t = useTranslations('DefinitionsPage')
  return (
    <div>
      <h1>{t('title')}</h1>
    </div>
  )
}
