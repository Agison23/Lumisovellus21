import { useTranslations } from "next-intl"
import Map3d from "@/components/map-3d"
import { mapAreas } from "@/lib/map/mock-data"

export default function Page() {
  const t = useTranslations('MapPage')
  return (
    <div className="w-full h-full">
      <Map3d areas={mapAreas} />
    </div>
  )
}
