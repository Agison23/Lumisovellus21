import Map3d from "@/components/map-3d"
import { mapAreas, mapAreas2 } from "@/lib/map/mock-data"
import { useTranslations } from "next-intl"

export default function Page() {
  const t = useTranslations('MapPage')
  return (
    <div className="w-full h-full">
      <Map3d areas={mapAreas2} />
    </div>
  )
}
