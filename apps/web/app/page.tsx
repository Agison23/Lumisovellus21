import Link from 'next/link'
import { useTranslations } from "next-intl"

export default function Page() {
  const t = useTranslations('MapPage')
  return (
    <div>

      <h1>{t('title')}</h1>
      <p>{t('loading')}</p>
      <Link href="/about">About</Link>
    </div>
  )
}
