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
import { api } from "../../lib/weather/api";

interface DayAboveFreezing {
  date: string;
  averageTemperature: number;
}

interface WeatherData {
  averageWind: { speed: number | null; direction: number | null };
  temperature: { min: number | null; max: number | null };
  maxWindSpeed: number | null;
  snowDepthChange: number | null;
  daysAboveFreezing: DayAboveFreezing[];
}

export default function WeatherView() {
  const t = useTranslations("WeatherPage");

  const [snowflakes, setSnowflakes] = useState<Array<{
    left: string;
    top: string;
    size: string;
    delay: string;
    duration: string;
  }>>([]);

  const [weatherData, setWeatherData] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(true);

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

  useEffect(() => {
    async function loadWeather() {
      try {
        const DAYS_SHORT = 3;
        const DAYS_SNOW = 7;

        const [
          avgWindSpeedRes,
          avgWindDirRes,
          minTempRes,
          maxTempRes,
          maxWindRes,
          snowChangeRes,
          daysAboveFreezingRes,
        ] = await Promise.all([
          fetch(api(`/weather/average?item=windSpeed&days=${DAYS_SHORT}`)),
          fetch(api(`/weather/average?item=windDirection&days=${DAYS_SHORT}`)),
          fetch(api(`/weather/minimum?item=temperature&days=${DAYS_SHORT}`)),
          fetch(api(`/weather/maximum?item=temperature&days=${DAYS_SHORT}`)),
          fetch(api(`/weather/maximum?item=windSpeed&days=${DAYS_SHORT}`)),
          fetch(api(`/weather/change?item=snowDepth&days=${DAYS_SNOW}`)),
          fetch(
            api(
              `/weather/filterDays?item=temperature&days=${DAYS_SHORT}&threshold=0`
            )
          ),
        ]);

        const [
          avgWindSpeed,
          avgWindDir,
          minTemp,
          maxTemp,
          maxWind,
          snowChange,
          daysAboveFreezing,
        ] = await Promise.all([
          avgWindSpeedRes.json(),
          avgWindDirRes.json(),
          minTempRes.json(),
          maxTempRes.json(),
          maxWindRes.json(),
          snowChangeRes.json(),
          daysAboveFreezingRes.json(),
        ]);

        setWeatherData({
          averageWind: {
            speed:
              avgWindSpeed.success && avgWindSpeed.data?.value != null
                ? avgWindSpeed.data.value
                : null,
            direction:
              avgWindDir.success && avgWindDir.data?.value != null
                ? avgWindDir.data.value
                : null,
          },

          temperature: {
            min:
              minTemp.success && minTemp.data?.value != null
                ? minTemp.data.value
                : null,
            max:
              maxTemp.success && maxTemp.data?.value != null
                ? maxTemp.data.value
                : null,
          },

          maxWindSpeed:
            maxWind.success && maxWind.data?.value != null
              ? maxWind.data.value
              : null,

          snowDepthChange:
            snowChange.success && snowChange.data?.value != null
              ? snowChange.data.value
              : null,

          daysAboveFreezing:
            daysAboveFreezing.success &&
            Array.isArray(daysAboveFreezing.data?.matches)
              ? daysAboveFreezing.data.matches.map((m: unknown) => {
                  const cast = m as DayAboveFreezing;
                  return {
                    date: cast.date,
                    averageTemperature: cast.averageTemperature,
                  };
                })
              : [],
        });
      } catch (err) {
        console.error("Failed to load weather:", err);
      } finally {
        setLoading(false);
      }
    }

    loadWeather();
  }, []);

  if (loading || !weatherData) {
    return (
      <div className="w-full h-full flex items-center justify-center">
        <p>{t("loading")}</p>
      </div>
    );
  }

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
          {/* Avg Wind */}
          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col justify-between shadow-md hover:scale-[1.02] transition-all">
            <div className="flex items-center gap-3 mb-4">
              <Wind size={36} className="text-primary" />
              <h4 className="text-xl font-semibold">{t("avgWindTitle")}</h4>
            </div>

            <div className="flex flex-col sm:flex-row sm:items-baseline sm:gap-3">
              <p className="text-3xl font-bold text-primary">
                {weatherData.averageWind.speed !== null
                  ? `${weatherData.averageWind.speed} m/s`
                  : t("notAvailable")}
              </p>

              <span className="text-3xl font-bold text-primary">-</span>

              <p className="text-3xl font-bold text-primary">
                {weatherData.averageWind.direction !== null
                  ? t("windDirection", {
                      deg: weatherData.averageWind.direction,
                    })
                  : t("notAvailable")}
              </p>
            </div>
          </div>

          {/* Temperature */}
          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col shadow-md hover:scale-[1.02] transition-all">
            <div className="flex items-center gap-3 mb-4">
              <Thermometer size={36} className="text-red-500" />
              <h4 className="text-xl font-semibold">{t("tempTitle")}</h4>
            </div>

            <div className="text-lg space-y-1">
              <p className="text-blue-500 flex items-center gap-1">
                <ArrowDown size={16} /> {t("min")}:
                {weatherData.temperature.min !== null ? (
                  <span className="font-semibold">
                    {" "}
                    {weatherData.temperature.min} °C
                  </span>
                ) : (
                  <span className="text-muted-foreground">
                    {" "}
                    {t("notAvailable")}
                  </span>
                )}
              </p>

              <p className="text-red-500 flex items-center gap-1">
                <ArrowUp size={16} /> {t("max")}:
                {weatherData.temperature.max !== null ? (
                  <span className="font-semibold">
                    {" "}
                    {weatherData.temperature.max} °C
                  </span>
                ) : (
                  <span className="text-muted-foreground">
                    {" "}
                    {t("notAvailable")}
                  </span>
                )}
              </p>
            </div>
          </div>

          {/* Max Wind */}
          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col shadow-md hover:scale-[1.02] transition-all">
            <div className="flex items-center gap-3 mb-4">
              <Wind size={36} className="text-primary" />
              <h4 className="text-xl font-semibold">{t("maxWindTitle")}</h4>
            </div>

            <p className="text-3xl font-bold">
              {weatherData.maxWindSpeed !== null
                ? `${weatherData.maxWindSpeed} m/s`
                : t("notAvailable")}
            </p>
          </div>

          {/* Snow Depth Change */}
          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col shadow-md hover:scale-[1.02] transition-all">
            <div className="flex items-center gap-3 mb-4">
              <Snowflake size={36} className="text-cyan-500" />
              <h4 className="text-xl font-semibold">{t("snowChangeTitle")}</h4>
            </div>

            <p className="text-3xl font-bold text-green-500">
              {weatherData.snowDepthChange !== null
                ? `+${weatherData.snowDepthChange} cm`
                : t("notAvailable")}
            </p>
          </div>

          {/* Days Above Freezing */}
          <div className="bg-card border-2 border-black rounded-3xl p-8 flex flex-col shadow-md hover:scale-[1.02] transition-all">
            <div className="flex items-center gap-3 mb-4">
              <ThermometerSnowflake size={36} className="text-yellow-400" />
              <h4 className="text-xl font-semibold">{t("aboveFreezingTitle")}</h4>
            </div>

            {weatherData.daysAboveFreezing.length > 0 ? (
              <ul className="list-disc list-inside text-lg mt-2">
                {weatherData.daysAboveFreezing.map((d) => (
                  <li key={d.date}>
                    {d.date} —{" "}
                    <span className="font-semibold text-primary">
                      {d.averageTemperature} °C
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
