import { describe, it, expect, beforeEach, vi } from 'vitest';
import { WeatherService } from '../../api/services/weather/WeatherService';
import { testPrisma } from '../vitest.setup';

describe('WeatherService Unit Tests', () => {
  let weatherService: WeatherService;

  beforeEach(async () => {
    // Clean up data before each test
    await testPrisma.weather.deleteMany();

    weatherService = new WeatherService();
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
        stationName: 'Muonio Laukukero',
      };

      const savedWeather = await weatherService.saveWeatherData(weatherData);

      expect(savedWeather).not.toBeNull();
      expect(savedWeather?.temperature).toBe(15.5);
      expect(savedWeather?.windSpeed).toBe(8.3);
      expect(savedWeather?.stationId).toBe('101982');
      expect(savedWeather?.stationName).toBe('Muonio Laukukero');
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
