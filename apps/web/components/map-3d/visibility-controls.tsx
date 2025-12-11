"use client";

import { ActivityIcon, LandPlot, MapPlus } from "lucide-react";
import { useTranslations } from "next-intl";

import { Button } from "@/components/ui/button";
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from "@/components/ui/popover";
import { Toggle } from "@/components/ui/toggle";
import {
  CONTROL_STORAGE_KEYS,
  saveControlState,
} from "@/lib/map/control-state";

export interface VisibilityControlsProps {
  showAreas: boolean;
  showMonitors: boolean;
  onShowAreasChange: (value: boolean) => void;
  onShowMonitorsChange: (value: boolean) => void;
}

export function VisibilityControls({
  showAreas,
  showMonitors,
  onShowAreasChange,
  onShowMonitorsChange,
}: VisibilityControlsProps) {
  const t = useTranslations("MapPage.controls");

  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button
          variant="ghost"
          className="absolute bg-background text-primary bottom-18 sm:bottom-9 left-2"
        >
          <MapPlus />
        </Button>
      </PopoverTrigger>
      <PopoverContent
        side="top"
        align="start"
        className="flex flex-col gap-1 w-max p-1"
      >
        <Toggle
          size="sm"
          pressed={showAreas}
          onPressedChange={(pressed) => {
            onShowAreasChange(pressed);
            saveControlState(CONTROL_STORAGE_KEYS.SHOW_AREAS, pressed);
          }}
          variant="outline"
          className="data-[state=on]:bg-transparent  data-[state=on]:*:[svg]:stroke-green-500 text-xs"
        >
          <LandPlot />
          {t("segments")}
        </Toggle>
        <Toggle
          size="sm"
          pressed={showMonitors}
          onPressedChange={(pressed) => {
            onShowMonitorsChange(pressed);
            saveControlState(CONTROL_STORAGE_KEYS.SHOW_MONITORS, pressed);
          }}
          variant="outline"
          className="data-[state=on]:bg-transparent data-[state=on]:*:[svg]:stroke-green-500 text-xs"
        >
          <ActivityIcon />
          {t("sensors")}
        </Toggle>
      </PopoverContent>
    </Popover>
  );
}
