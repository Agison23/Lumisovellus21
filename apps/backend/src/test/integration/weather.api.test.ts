import { describe, it, expect, beforeEach, afterEach, vi } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import weatherRoutes from '../../api/routes/weather/weatherRoutes';
import { errorHandler } from '../../api/middleware/errorHandler';

const app = express();
app.use(express.json());
app.use('/', weatherRoutes);
app.use(errorHandler);

const DAY_IN_MS = 24 * 60 * 60 * 1000;

async function addWeatherEntry({
  timestamp,
  temperature = null,
  windSpeed = null,
  windDirection = null,
  snowDepth = null,
}: {
  timestamp: Date;
  temperature?: number | null;
  windSpeed?: number | null;
  windDirection?: number | null;
  snowDepth?: number | null;
}) {
  await testPrisma.weather.create({
    data: {
      timestamp,
      temperature,
      windSpeed,
      windDirection,
      snowDepth,
      stationId: 'station',
      stationName: 'Pallastunturi',
    },
  });
}

describe('Weather API Integration Tests', () => {
  beforeEach(async () => {
    await testPrisma.weather.deleteMany();
    vi.useRealTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
  });

  describe('GET /weather/average', () => {
    it('returns rolling average wind speed', async () => {
      const now = new Date('2024-05-01T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: new Date(now.getTime() - DAY_IN_MS), windSpeed: 5 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - 2 * DAY_IN_MS), windSpeed: 7 });
      await addWeatherEntry({ timestamp: now, windSpeed: 9 });

      const response = await request(app)
        .get('/weather/average')
        .query({ item: 'windSpeed', days: 3 });

      expect(response.status).toBe(200);
      expect(response.body.data).toMatchObject({
        type: 'average',
        item: 'windSpeed',
        unit: 'metersPerSecond',
        days: 3,
      });
      expect(response.body.data.value).toBeCloseTo(7);
      expect(response.body.data.location.name).toBe('Pallastunturi');
    });

    it('computes circular average for wind direction', async () => {
      const now = new Date('2024-05-05T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: now, windDirection: 0 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - DAY_IN_MS), windDirection: 270 });

      const response = await request(app)
        .get('/weather/average')
        .query({ item: 'windDirection', days: 2 });

      expect(response.status).toBe(200);
      expect(response.body.data.value).toBeCloseTo(315);
    });

    it('returns 400 for missing item', async () => {
      const response = await request(app).get('/weather/average');

      expect(response.status).toBe(400);
      expect(response.body.success).toBe(false);
    });

    it('returns 404 when no data exists', async () => {
      const response = await request(app)
        .get('/weather/average')
        .query({ item: 'windSpeed', days: 3 });

      expect(response.status).toBe(404);
    });
  });

  describe('GET /weather/minimum', () => {
    it('returns coldest temperature', async () => {
      const now = new Date('2024-06-01T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: now, temperature: -2 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - DAY_IN_MS), temperature: -8 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - 2 * DAY_IN_MS), temperature: 1 });

      const response = await request(app)
        .get('/weather/minimum')
        .query({ item: 'temperature', days: 3 });

      expect(response.status).toBe(200);
      expect(response.body.data.value).toBe(-8);
      expect(response.body.data.item).toBe('temperature');
      expect(response.body.data.unit).toBe('celsius');
    });
  });

  describe('GET /weather/maximum', () => {
    it('returns strongest wind speed', async () => {
      const now = new Date('2024-06-10T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: now, windSpeed: 3 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - DAY_IN_MS), windSpeed: 12 });

      const response = await request(app)
        .get('/weather/maximum')
        .query({ item: 'windSpeed', days: 2 });

      expect(response.status).toBe(200);
      expect(response.body.data.value).toBe(12);
      expect(response.body.data.unit).toBe('metersPerSecond');
    });

    it('returns warmest temperature', async () => {
      const now = new Date('2024-06-15T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: now, temperature: 5 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - DAY_IN_MS), temperature: 8 });
      await addWeatherEntry({ timestamp: new Date(now.getTime() - 2 * DAY_IN_MS), temperature: 10 });

      const response = await request(app)
        .get('/weather/maximum')
        .query({ item: 'temperature', days: 3 });

      expect(response.status).toBe(200);
      expect(response.body.data.value).toBe(10);
      expect(response.body.data.unit).toBe('celsius');
    });
  });

  describe('GET /weather/change', () => {
    it('returns snow depth delta', async () => {
      const now = new Date('2024-07-01T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: new Date(now.getTime() - 7 * DAY_IN_MS), snowDepth: 30 });
      await addWeatherEntry({ timestamp: now, snowDepth: 45 });

      const response = await request(app)
        .get('/weather/change')
        .query({ item: 'snowDepth', days: 7 });

      expect(response.status).toBe(200);
      expect(response.body.data.value).toBe(15);
      expect(response.body.data.unit).toBe('centimeters');
    });

    it('responds 404 when insufficient snow depth data', async () => {
      const now = new Date('2024-07-05T00:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: now, snowDepth: 40 });

      const response = await request(app)
        .get('/weather/change')
        .query({ item: 'snowDepth', days: 7 });

      expect(response.status).toBe(404);
    });
  });

  describe('GET /weather/filterDays', () => {
    it('returns dates whose daily averages exceed threshold', async () => {
      const now = new Date('2024-08-04T12:00:00Z');
      vi.useFakeTimers();
      vi.setSystemTime(now);

      await addWeatherEntry({ timestamp: new Date('2024-08-02T06:00:00Z'), temperature: -2 });
      await addWeatherEntry({ timestamp: new Date('2024-08-02T12:00:00Z'), temperature: -1 });
      await addWeatherEntry({ timestamp: new Date('2024-08-03T08:00:00Z'), temperature: 2 });
      await addWeatherEntry({ timestamp: new Date('2024-08-03T12:00:00Z'), temperature: 4 });
      await addWeatherEntry({ timestamp: new Date('2024-08-04T09:00:00Z'), temperature: 0.5 });

      const response = await request(app)
        .get('/weather/filterDays')
        .query({ item: 'temperature', threshold: 0, days: 3 });

      expect(response.status).toBe(200);
      expect(response.body.data.matches).toHaveLength(2);
      expect(response.body.data.matches[0].date).toBe('2024-08-03T00:00:00.000Z');
      expect(response.body.data.matches[0].averageTemperature).toBeCloseTo(3);
      expect(response.body.data.matches[1].date).toBe('2024-08-04T00:00:00.000Z');
      expect(response.body.data.matches[1].averageTemperature).toBeCloseTo(0.5);
    });

    it('validates required threshold parameter', async () => {
      const response = await request(app)
        .get('/weather/filterDays')
        .query({ item: 'temperature', days: 3 });

      expect(response.status).toBe(400);
    });
  });
});
