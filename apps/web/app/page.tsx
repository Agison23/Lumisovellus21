import { useTranslations } from "next-intl"
import Link from 'next/link'

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
