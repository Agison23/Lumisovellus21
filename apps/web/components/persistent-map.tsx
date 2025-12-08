"use client";

import { usePathname } from "next/navigation";
import Map3d from "@/components/map-3d";

/**
 * PersistentMap component keeps the Map3D mounted across navigation
 * to avoid reloading the map every time. It shows/hides based on route.
 */
export default function PersistentMap() {
  const pathname = usePathname();

  // Only show map on the home page
  const isMapPage = pathname === "/";

  return (
    <div
      className={`absolute inset-0 w-full h-full bg-white transition-opacity duration-200 ${
        isMapPage
          ? "opacity-100 z-10 pointer-events-auto"
          : "opacity-0 -z-10 pointer-events-none"
      }`}
    >
      <Map3d />
    </div>
  );
}
