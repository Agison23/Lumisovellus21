import { describe, it, expect, beforeEach } from 'vitest';
import { HealthService } from '../../api/services/health/HealthService';
import { testPrisma } from '../vitest.setup';

describe('HealthService Unit Tests', () => {
  let healthService: HealthService;

  beforeEach(async () => {
    healthService = new HealthService();
  });

  describe('getHealthStatus', () => {
    it('should return health status with ok status and version', async () => {
      const result = await healthService.getHealthStatus();

      expect(result).toEqual({
        status: 'ok',
        version: '2.0.0',
      });
    });

    it('should always return the same health status', async () => {
      const result1 = await healthService.getHealthStatus();
      const result2 = await healthService.getHealthStatus();

      expect(result1).toEqual(result2);
    });

    it('should return a valid health response structure', async () => {
      const result = await healthService.getHealthStatus();

      expect(result).toHaveProperty('status');
      expect(result).toHaveProperty('version');
      expect(typeof result.status).toBe('string');
      expect(typeof result.version).toBe('string');
    });
  });
});
