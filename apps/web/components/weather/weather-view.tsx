"use client";

import {
  Thermometer,
  ThermometerSnowflake,
  Wind,
  Snowflake,
  ArrowDown,
  ArrowUp,
} from "lucide-react";
import { useTranslations } from "next-intl";
import { useEffect, useState } from "react";

export default function WeatherView() {
  const t = useTranslations("WeatherPage");

  const [snowflakes, setSnowflakes] = useState<
    {
      left: string;
      top: string;
      size: string;
      delay: string;
      duration: string;
    }[]
  >([]);

  useEffect(() => {
    const items = Array.from({ length: 40 }).map(() => ({
      left: `${Math.random() * 100}%`,
      top: `${Math.random() * -100}%`,
      size: `${Math.random() * 1.2 + 0.6}rem`,
      delay: `${Math.random() * 10}s`,
      duration: `${Math.random() * 12 + 10}s`,
    }));
    setSnowflakes(items);
  }, []);

  const weatherData = {
    averageWind: { speed: 6.2, direction: 315 },
    temperature: { min: -5.3, max: 3.8 },
    maxWindSpeed: 10.1,
    snowDepthChange: 4,
    daysAboveFreezing: [
      { date: "2025-11-09", avgTemp: 1.2 },
      { date: "2025-11-08", avgTemp: 0.5 },
    ],
  };

  return (
    <div className="relative w-full h-full flex flex-col items-center py-16 px-6 overflow-y-auto select-none">
      <div className="absolute inset-0 overflow-hidden pointer-events-none z-0">
        {snowflakes.map((f, i) => (
          <div
            key={i}
            className="absolute animate-snow text-gray-400 dark:text-white/40"
            style={{
              left: f.left,
              top: f.top,
              fontSize: f.size,
              animationDelay: f.delay,
              animationDuration: f.duration,
            }}
          >
            ❄
          </div>
        ))}
      </div>

      <div className="relative z-10 flex flex-col items-center">
        <h2 className="text-4xl font-bold mb-12 text-primary tracking-tight">
          {t("title")}
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-8 max-w-5xl">
          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col justify-between shadow-md dark:shadow-black/[0.4] hover:shadow-lg hover:scale-[1.02] transition-all duration-300 ease-out">
            <div className="flex items-center gap-3 mb-4">
              <Wind size={36} className="text-primary" />
              <h4 className="text-xl font-semibold">{t("avgWindTitle")}</h4>
            </div>
            <div className="flex flex-col sm:flex-row sm:items-baseline sm:gap-3">
              <p className="text-3xl font-bold text-primary">
                {weatherData.averageWind.speed} m/s
              </p>
              <span className="text-3xl font-bold text-primary">-</span>
              <p className="text-3xl font-bold text-primary">
                {t("windDirection", { deg: weatherData.averageWind.direction })}
              </p>
            </div>
          </div>

          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col justify-between shadow-md dark:shadow-black/[0.4] hover:shadow-lg hover:scale-[1.02] transition-all duration-300 ease-out">
            <div className="flex items-center gap-3 mb-4">
              <Thermometer size={36} className="text-red-500" />
              <h4 className="text-xl font-semibold">{t("tempTitle")}</h4>
            </div>
            <div className="text-lg space-y-1">
              <p className="text-blue-500 flex items-center gap-1">
                <ArrowDown size={16} /> {t("min")}:{" "}
                <span className="font-semibold">
                  {weatherData.temperature.min} °C
                </span>
              </p>
              <p className="text-red-500 flex items-center gap-1">
                <ArrowUp size={16} /> {t("max")}:{" "}
                <span className="font-semibold">
                  {weatherData.temperature.max} °C
                </span>
              </p>
            </div>
          </div>

          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col justify-between shadow-md dark:shadow-black/[0.4] hover:shadow-lg hover:scale-[1.02] transition-all duration-300 ease-out">
            <div className="flex items-center gap-3 mb-4">
              <Wind size={36} className="text-primary" />
              <h4 className="text-xl font-semibold">{t("maxWindTitle")}</h4>
            </div>
            <p className="text-3xl font-bold">{weatherData.maxWindSpeed} m/s</p>
          </div>

          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col justify-between shadow-md dark:shadow-black/[0.4] hover:shadow-lg hover:scale-[1.02] transition-all duration-300 ease-out">
            <div className="flex items-center gap-3 mb-4">
              <Snowflake size={36} className="text-cyan-500" />
              <h4 className="text-xl font-semibold">{t("snowChangeTitle")}</h4>
            </div>
            <p className="text-3xl font-bold text-green-500">
              +{weatherData.snowDepthChange} cm
            </p>
          </div>

          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col justify-between shadow-md dark:shadow-black/[0.4] hover:shadow-lg hover:scale-[1.02] transition-all duration-300 ease-out">
            <div className="flex items-center gap-3 mb-4">
              <ThermometerSnowflake size={36} className="text-yellow-400" />
              <h4 className="text-xl font-semibold">
                {t("aboveFreezingTitle")}
              </h4>
            </div>
            {weatherData.daysAboveFreezing.length > 0 ? (
              <ul className="list-disc list-inside text-lg mt-2">
                {weatherData.daysAboveFreezing.map((d) => (
                  <li key={d.date}>
                    {d.date} —{" "}
                    <span className="font-semibold text-primary">
                      {d.avgTemp} °C
                    </span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-muted-foreground">{t("noAboveFreezing")}</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
