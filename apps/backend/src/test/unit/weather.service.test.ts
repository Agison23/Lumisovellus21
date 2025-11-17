import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import { WeatherService } from '../../api/services/weather/WeatherService';
import { testPrisma } from '../vitest.setup';

describe('WeatherService Unit Tests', () => {
  let weatherService: WeatherService;

  beforeEach(async () => {
    // Clean up data before each test
    await testPrisma.weather.deleteMany();

    weatherService = new WeatherService();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  describe('saveWeatherData', () => {
    it('should save weather data successfully', async () => {
      const weatherData = {
        temperature: 15.5,
        windSpeed: 8.3,
        windDirection: 180,
        airPressure: 1013.2,
        snowDepth: null,
        relativeHumidity: 65,
        dewPoint: 5.2,
        precipitation: null,
        visibility: null,
        cloudCover: null,
        stationId: '101982',
        stationName: 'Pallastunturi',
      };

      const savedWeather = await weatherService.saveWeatherData(weatherData);

      expect(savedWeather).not.toBeNull();
      expect(savedWeather?.temperature).toBe(15.5);
      expect(savedWeather?.windSpeed).toBe(8.3);
      expect(savedWeather?.stationId).toBe('101982');
      expect(savedWeather?.stationName).toBe('Pallastunturi');
    });

    it('should handle null values correctly', async () => {
      const weatherData = {
        temperature: null,
        windSpeed: null,
        windDirection: null,
        airPressure: null,
        snowDepth: null,
        relativeHumidity: null,
        dewPoint: null,
        precipitation: null,
        visibility: null,
        cloudCover: null,
        stationId: '101982',
        stationName: 'Test Station',
      };

      const savedWeather = await weatherService.saveWeatherData(weatherData);

      expect(savedWeather).not.toBeNull();
      expect(savedWeather?.temperature).toBeNull();
      expect(savedWeather?.stationId).toBe('101982');
    });
  });

  describe('getLatestWeather', () => {
    it('should return the most recent weather data', async () => {
      const now = new Date();
      const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);

      // Create old weather data
      await testPrisma.weather.create({
        data: {
          timestamp: yesterday,
          temperature: 10.0,
          stationId: '101982',
          stationName: 'Test Station',
        },
      });

      // Create recent weather data
      await testPrisma.weather.create({
        data: {
          timestamp: now,
          temperature: 20.0,
          stationId: '101982',
          stationName: 'Test Station',
        },
      });

      const latest = await weatherService.getLatestWeather();

      expect(latest).not.toBeNull();
      expect(latest?.temperature).toBe(20.0);
    });

    it('should return null when no weather data exists', async () => {
      const latest = await weatherService.getLatestWeather();

      expect(latest).toBeNull();
    });
  });

  describe('getWeatherHistory', () => {
    it('should return weather history with default limit', async () => {
      const baseTime = new Date('2024-01-01T12:00:00Z');

      // Create 10 weather records with simple ascending temperatures
      for (let i = 0; i < 10; i++) {
        const timestamp = new Date(baseTime.getTime() - i * 60 * 60 * 1000);
        await testPrisma.weather.create({
          data: {
            timestamp,
            temperature: i * 2, // 0, 2, 4, 6, 8, 10, 12, 14, 16, 18
            stationId: '101982',
            stationName: 'Test Station',
          },
        });
      }

      const history = await weatherService.getWeatherHistory();

      expect(history).toHaveLength(10);
      // Most recent record (i=0) has temperature 0
      expect(history[0].temperature).toBe(0);
      // Oldest record (i=9) has temperature 18
      expect(history[9].temperature).toBe(18);
    });

    it('should return weather history with custom limit', async () => {
      const baseTime = new Date('2024-01-01T12:00:00Z');

      // Create 20 weather records
      for (let i = 0; i < 20; i++) {
        const timestamp = new Date(baseTime.getTime() - i * 60 * 60 * 1000);
        await testPrisma.weather.create({
          data: {
            timestamp,
            temperature: i * 5, // 0, 5, 10, 15, 20, 25, ... 95
            stationId: '101982',
            stationName: 'Test Station',
          },
        });
      }

      const history = await weatherService.getWeatherHistory(5);

      expect(history).toHaveLength(5);
      // Should return 5 most recent records: 0, 5, 10, 15, 20
      expect(history[0].temperature).toBe(0); // Most recent
      expect(history[4].temperature).toBe(20); // 5th most recent
    });

    it('should return empty array when no weather data exists', async () => {
      const history = await weatherService.getWeatherHistory();

      expect(history).toEqual([]);
    });

    it('should return results sorted by timestamp descending', async () => {
      const now = new Date();

      await testPrisma.weather.create({
        data: {
          timestamp: new Date(now.getTime() - 5 * 60 * 60 * 1000),
          temperature: 10.0,
          stationId: '101982',
          stationName: 'Test Station',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: new Date(now.getTime() - 2 * 60 * 60 * 1000),
          temperature: 15.0,
          stationId: '101982',
          stationName: 'Test Station',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: now,
          temperature: 20.0,
          stationId: '101982',
          stationName: 'Test Station',
        },
      });

      const history = await weatherService.getWeatherHistory(3);

      expect(history[0].temperature).toBe(20.0);
      expect(history[1].temperature).toBe(15.0);
      expect(history[2].temperature).toBe(10.0);
    });
  });

  describe('getAverageForItem', () => {
    it('calculates arithmetic average for wind speed', async () => {
      const now = new Date('2024-01-10T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      for (let i = 0; i < 3; i++) {
        await testPrisma.weather.create({
          data: {
            timestamp: new Date(now.getTime() - i * 24 * 60 * 60 * 1000),
            windSpeed: 5 + i, // 5,6,7 -> average 6
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        });
      }

      const average = await weatherService.getAverageForItem('windSpeed', 3);
      expect(average).toBeCloseTo(6);
    });

    it('calculates circular average for wind direction across north', async () => {
      const now = new Date('2024-01-05T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await testPrisma.weather.createMany({
        data: [
          {
            timestamp: new Date(now.getTime() - 24 * 60 * 60 * 1000),
            windDirection: 0,
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
          {
            timestamp: now,
            windDirection: 270,
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        ],
      });

      const average = await weatherService.getAverageForItem('windDirection', 3);
      expect(average).toBeCloseTo(315);
    });
  });

  describe('getMinimumForItem', () => {
    it('returns coldest temperature within window', async () => {
      const now = new Date('2024-02-01T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      const temps = [-2, -10, 1];
      for (let i = 0; i < temps.length; i++) {
        await testPrisma.weather.create({
          data: {
            timestamp: new Date(now.getTime() - i * 24 * 60 * 60 * 1000),
            temperature: temps[i],
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        });
      }

      const min = await weatherService.getMinimumForItem(3);
      expect(min).toBe(-10);
    });
  });

  describe('getMaximumForItem', () => {
    it('returns warmest temperature', async () => {
      const now = new Date('2024-02-10T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      const temps = [-5, 0, 3, 8];
      for (let i = 0; i < temps.length; i++) {
        await testPrisma.weather.create({
          data: {
            timestamp: new Date(now.getTime() - i * 24 * 60 * 60 * 1000),
            temperature: temps[i],
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        });
      }

      const maxTemp = await weatherService.getMaximumForItem('temperature', 4);
      expect(maxTemp).toBe(8);
    });

    it('returns strongest wind speed', async () => {
      const now = new Date('2024-02-20T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      const windSpeeds = [3, 12, 7];
      for (let i = 0; i < windSpeeds.length; i++) {
        await testPrisma.weather.create({
          data: {
            timestamp: new Date(now.getTime() - i * 24 * 60 * 60 * 1000),
            windSpeed: windSpeeds[i],
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        });
      }

      const maxWind = await weatherService.getMaximumForItem('windSpeed', 3);
      expect(maxWind).toBe(12);
    });
  });

  describe('getChangeForItem', () => {
    it('returns latest minus earliest snow depth', async () => {
      const now = new Date('2024-03-01T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await testPrisma.weather.createMany({
        data: [
          {
            timestamp: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000),
            snowDepth: 40,
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
          {
            timestamp: new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000),
            snowDepth: 60,
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
          {
            timestamp: now,
            snowDepth: 55,
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        ],
      });

      const change = await weatherService.getChangeForItem('snowDepth', 7);
      expect(change).toBe(15); // 55 - 40
    });

    it('returns null when insufficient data', async () => {
      const now = new Date('2024-03-10T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await testPrisma.weather.create({
        data: {
          timestamp: now,
          snowDepth: 50,
          stationId: 'station',
          stationName: 'Pallastunturi',
        },
      });

      const change = await weatherService.getChangeForItem('snowDepth', 3);
      expect(change).toBeNull();
    });
  });

  describe('getDaysWhereAverageTemperatureExceedsThreshold', () => {
    it('filters days whose averages are above threshold', async () => {
      const now = new Date('2024-04-04T12:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      const makeEntry = async (date: string, temperature: number) => {
        await testPrisma.weather.create({
          data: {
            timestamp: new Date(date),
            temperature,
            stationId: 'station',
            stationName: 'Pallastunturi',
          },
        });
      };

      await makeEntry('2024-04-02T06:00:00Z', -2);
      await makeEntry('2024-04-02T12:00:00Z', -1);
      await makeEntry('2024-04-03T08:00:00Z', 1);
      await makeEntry('2024-04-03T12:00:00Z', 2);
      await makeEntry('2024-04-03T18:00:00Z', 3);
      await makeEntry('2024-04-04T09:00:00Z', 0.5);

      const matches = await weatherService.getDaysWhereAverageTemperatureExceedsThreshold(3, 0);

      expect(matches).toHaveLength(2);
      expect(matches[0].date).toBe('2024-04-03T00:00:00.000Z');
      expect(matches[0].averageTemperature).toBeCloseTo(2);
      expect(matches[1].date).toBe('2024-04-04T00:00:00.000Z');
      expect(matches[1].averageTemperature).toBeCloseTo(0.5);
    });

    it('returns empty array when no days exceed threshold', async () => {
      const now = new Date('2024-04-10T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await testPrisma.weather.create({
        data: {
          timestamp: now,
          temperature: -5,
          stationId: 'station',
          stationName: 'Pallastunturi',
        },
      });

      const matches = await weatherService.getDaysWhereAverageTemperatureExceedsThreshold(3, 0);
      expect(matches).toEqual([]);
    });
  });

  describe('fetchFmiWeatherData', () => {
    it('should handle API errors gracefully', async () => {
      // Mock fetch to simulate API failure
      const originalFetch = global.fetch;
      global.fetch = vi.fn().mockRejectedValue(new Error('Network error'));

      const result = await weatherService.fetchFmiWeatherData();

      expect(result).toBeNull();

      global.fetch = originalFetch;
    });

    it('should return null when API returns non-ok status', async () => {
      const originalFetch = global.fetch;
      global.fetch = vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
      } as any);

      const result = await weatherService.fetchFmiWeatherData();

      expect(result).toBeNull();

      global.fetch = originalFetch;
    });
  });

  describe('updateWeatherData', () => {
    it('should return null when fetch fails', async () => {
      const originalFetch = global.fetch;
      global.fetch = vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
      } as any);

      const result = await weatherService.updateWeatherData();

      expect(result).toBeNull();

      global.fetch = originalFetch;
    });
  });

  describe('error handling', () => {
    it('should handle database errors gracefully', async () => {
      const weatherData = {
        temperature: null,
        windSpeed: null,
        windDirection: null,
        airPressure: null,
        snowDepth: null,
        relativeHumidity: null,
        dewPoint: null,
        precipitation: null,
        visibility: null,
        cloudCover: null,
        stationId: '', // Empty stationId might cause error
        stationName: 'Test Station',
      };

      // This should not throw an error, but might return null
      const result = await weatherService.saveWeatherData(weatherData);

      // The result depends on database constraints
      // We just verify it doesn't throw
      expect(result).not.toBeUndefined();
    });
  });
});
