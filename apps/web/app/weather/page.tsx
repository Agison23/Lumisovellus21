import { useTranslations } from "next-intl";
import WeatherView from "@/components/weather/weather-view";

export default function Page() {
  const t = useTranslations("WeatherPage");

  return (
    <div className="w-full h-full bg-blue-50 text-foreground flex flex-col transition-colors duration-300">
      <div className="pt-2.5 px-12">
        <h1 className="text-xl font-semibold mb-4">{t("title")}</h1>
      </div>
      <WeatherView />
    </div>
  );
}
