import { useTranslations } from "next-intl"
import Map3d from "@/components/map-3d"

export default function Page() {
  const t = useTranslations('MapPage')
  return (
    <div className="w-full h-full bg-white">
      <h1>{t('title')}</h1>
      <Map3d />
    </div>
  )
}