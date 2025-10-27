import { describe, it, expect, beforeEach, vi } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import weatherRoutes from '../../api/routes/weather/weatherRoutes';
import { errorHandler } from '../../api/middleware/errorHandler';

// Create test app
const app = express();
app.use(express.json());
app.use('/', weatherRoutes);
app.use(errorHandler);

describe('Weather API Integration Tests', () => {
  beforeEach(async () => {
    // Clean up data before each test
    await testPrisma.weather.deleteMany();
  });

  describe('GET /weather', () => {
    it('should return the latest weather data', async () => {
      const now = new Date();
      const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);

      // Create old weather data
      await testPrisma.weather.create({
        data: {
          timestamp: yesterday,
          temperature: 10.0,
          windSpeed: 5.0,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      // Create recent weather data
      await testPrisma.weather.create({
        data: {
          timestamp: now,
          temperature: 20.0,
          windSpeed: 10.0,
          windDirection: 180,
          airPressure: 1013.2,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      const response = await request(app).get('/weather');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data.temperature).toBe(20.0);
      expect(response.body.data.windSpeed).toBe(10.0);
      expect(response.body.data.stationId).toBe('101982');
    });

    it('should return null when no weather data exists', async () => {
      const response = await request(app).get('/weather');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toBeNull();
    });

    it('should return most recent weather data when multiple records exist', async () => {
      // Create weather records with increasing timestamps
      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T10:00:00Z'),
          temperature: 10,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T11:00:00Z'),
          temperature: 20,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T12:00:00Z'),
          temperature: 30,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T13:00:00Z'),
          temperature: 40,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      const response = await request(app).get('/weather');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      // Should return the most recent record (latest timestamp)
      expect(response.body.data.temperature).toBe(40);
    });
  });

  describe('GET /weather/history', () => {
    it('should return weather history with default limit', async () => {
      const baseTime = new Date('2024-01-01T12:00:00Z');

      // Create 15 weather records with simple temperatures
      for (let i = 0; i < 15; i++) {
        const timestamp = new Date(baseTime.getTime() - i * 60 * 60 * 1000);
        await testPrisma.weather.create({
          data: {
            timestamp,
            temperature: i, // 0, 1, 2, 3, ..., 14
            stationId: '101982',
            stationName: 'Muonio Laukukero',
          },
        });
      }

      const response = await request(app).get('/weather/history');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveLength(15);
      // Most recent record is i=0 (temperature 0)
      expect(response.body.data[0].temperature).toBe(0);
      // Oldest record is i=14 (temperature 14)
      expect(response.body.data[14].temperature).toBe(14);
    });

    it('should return weather history with custom limit', async () => {
      const baseTime = new Date('2024-01-01T12:00:00Z');

      // Create 20 weather records
      for (let i = 0; i < 20; i++) {
        const timestamp = new Date(baseTime.getTime() - i * 60 * 60 * 1000);
        await testPrisma.weather.create({
          data: {
            timestamp,
            temperature: i * 2, // 0, 2, 4, 6, ... 38
            stationId: '101982',
            stationName: 'Muonio Laukukero',
          },
        });
      }

      const response = await request(app)
        .get('/weather/history')
        .query({ limit: 5 });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveLength(5);
      // Should return 5 most recent: 0, 2, 4, 6, 8
      expect(response.body.data[0].temperature).toBe(0); // Most recent
      expect(response.body.data[4].temperature).toBe(8); // 5th most recent
    });

    it('should return empty array when no weather data exists', async () => {
      const response = await request(app).get('/weather/history');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });

    it('should handle invalid limit parameter', async () => {
      const response = await request(app)
        .get('/weather/history')
        .query({ limit: 'invalid' });

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      // Should default to 100
    });

    it('should return results sorted by timestamp descending', async () => {
      // Create records with timestamps in ascending order (oldest first)
      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T10:00:00Z'),
          temperature: 10,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T11:00:00Z'),
          temperature: 20,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      await testPrisma.weather.create({
        data: {
          timestamp: new Date('2024-01-01T12:00:00Z'),
          temperature: 30,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      const response = await request(app).get('/weather/history');

      expect(response.status).toBe(200);
      // Results should be sorted descending by timestamp (newest first)
      expect(response.body.data[0].temperature).toBe(30); // 12:00 (newest)
      expect(response.body.data[1].temperature).toBe(20); // 11:00
      expect(response.body.data[2].temperature).toBe(10); // 10:00 (oldest)
    });
  });

  describe('POST /weather/update', () => {
    it('should update weather data successfully', async () => {
      // Mock the fetch function to return valid XML response
      const mockXmlResponse = `<?xml version="1.0" encoding="UTF-8"?>
        <wfs:FeatureCollection>
          <wfs:member>
            <om:Observation>
              <omResult>
                <measurementSeries>
                  <item gml:id="obs-obs-1-1-t2m">
                    <value>15.5</value>
                  </item>
                  <item gml:id="obs-obs-1-1-ws_10min">
                    <value>8.3</value>
                  </item>
                  <item gml:id="obs-obs-1-1-wd_10min">
                    <value>180</value>
                  </item>
                </measurementSeries>
              </omResult>
            </om:Observation>
          </wfs:member>
        </wfs:FeatureCollection>`;

      const originalFetch = global.fetch;
      global.fetch = vi.fn().mockResolvedValue({
        ok: true,
        text: async () => mockXmlResponse,
      } as any);

      const response = await request(app).post('/weather/update');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).not.toBeNull();

      global.fetch = originalFetch;
    });

    it('should handle API errors gracefully', async () => {
      const originalFetch = global.fetch;
      global.fetch = vi.fn().mockRejectedValue(new Error('Network error'));

      const response = await request(app).post('/weather/update');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toBeNull();

      global.fetch = originalFetch;
    });

    it('should handle non-ok API responses', async () => {
      const originalFetch = global.fetch;
      global.fetch = vi.fn().mockResolvedValue({
        ok: false,
        status: 500,
      } as any);

      const response = await request(app).post('/weather/update');

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
      expect(response.body.data).toBeNull();

      global.fetch = originalFetch;
    });
  });

  describe('API response format', () => {
    it('should return correct response structure for successful requests', async () => {
      await testPrisma.weather.create({
        data: {
          temperature: 15.0,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      const response = await request(app).get('/weather');

      expect(response.body).toHaveProperty('success');
      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('meta');
      expect(response.body.success).toBe(true);
      expect(response.body.meta).toHaveProperty('timestamp');
    });

    it('should include meta information in response', async () => {
      await testPrisma.weather.create({
        data: {
          temperature: 15.0,
          stationId: '101982',
          stationName: 'Muonio Laukukero',
        },
      });

      const response = await request(app).get('/weather');

      expect(response.body.meta).toBeDefined();
      expect(response.body.meta.timestamp).toBeDefined();
      expect(typeof response.body.meta.timestamp).toBe('string');
    });
  });

  describe('data integrity', () => {
    it('should preserve all weather data fields', async () => {
      const weatherData = {
        timestamp: new Date(),
        temperature: 15.5,
        windSpeed: 8.3,
        windDirection: 180,
        airPressure: 1013.2,
        snowDepth: 50.0,
        relativeHumidity: 65,
        dewPoint: 5.2,
        precipitation: 0.0,
        visibility: 10.0,
        cloudCover: 3,
        stationId: '101982',
        stationName: 'Muonio Laukukero',
      };

      await testPrisma.weather.create({ data: weatherData });

      const response = await request(app).get('/weather');

      expect(response.body.data.temperature).toBe(15.5);
      expect(response.body.data.windSpeed).toBe(8.3);
      expect(response.body.data.windDirection).toBe(180);
      expect(response.body.data.airPressure).toBe(1013.2);
      expect(response.body.data.snowDepth).toBe(50.0);
      expect(response.body.data.relativeHumidity).toBe(65);
      expect(response.body.data.dewPoint).toBe(5.2);
      expect(response.body.data.precipitation).toBe(0.0);
      expect(response.body.data.visibility).toBe(10.0);
      expect(response.body.data.cloudCover).toBe(3);
    });
  });
});
