import { describe, it, expect } from 'vitest';
import request from 'supertest';
import express from 'express';
import healthRoutes from '../../api/routes/health/healthRoutes';

// Create test app
const app = express();
app.use(express.json());
app.use('/', healthRoutes);

describe('Health API Integration Tests', () => {
  describe('GET /health', () => {
    it('should return health status successfully', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          status: 'ok',
          version: '2.0.0',
        },
        meta: {
          timestamp: expect.any(String),
        },
      });
    });

    it('should always return the same health status', async () => {
      const response1 = await request(app)
        .get('/health')
        .expect(200);

      const response2 = await request(app)
        .get('/health')
        .expect(200);

      expect(response1.body.data).toEqual(response2.body.data);
    });

    it('should return valid JSON response structure', async () => {
      const response = await request(app)
        .get('/health')
        .expect(200);

      expect(response.body).toHaveProperty('success');
      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('meta');
      expect(typeof response.body.success).toBe('boolean');
      expect(typeof response.body.data.status).toBe('string');
      expect(typeof response.body.data.version).toBe('string');
    });

    it('should handle multiple concurrent requests', async () => {
      const promises = Array.from({ length: 5 }, () =>
        request(app).get('/health').expect(200)
      );

      const responses = await Promise.all(promises);

      responses.forEach(response => {
        expect(response.body.success).toBe(true);
        expect(response.body.data.status).toBe('ok');
        expect(response.body.data.version).toBe('2.0.0');
      });
    });
  });
});
