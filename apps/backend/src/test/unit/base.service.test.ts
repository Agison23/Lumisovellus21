import { describe, it, expect, beforeEach, vi } from 'vitest';
import { BaseService } from '../../api/services/BaseService';
import { testPrisma } from '../vitest.setup';

// Create a concrete implementation of BaseService for testing
class TestService extends BaseService {
  constructor() {
    super();
    // Override prisma with test instance
    this.prisma = testPrisma;
  }

  // Expose protected method for testing
  public async testHandleDatabaseError(error: any): Promise<never> {
    return this.handleDatabaseError(error);
  }
}

describe('BaseService Unit Tests', () => {
  let testService: TestService;

  beforeEach(() => {
    testService = new TestService();
  });

  describe('constructor', () => {
    it('should initialize with prisma client', () => {
      expect(testService).toBeDefined();
      expect(testService['prisma']).toBeDefined();
    });
  });

  describe('handleDatabaseError', () => {
    it('should log error and re-throw it', async () => {
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});
      const testError = new Error('Test database error');

      await expect(testService.testHandleDatabaseError(testError)).rejects.toThrow('Test database error');

      expect(consoleSpy).toHaveBeenCalledWith('Database error:', testError);

      consoleSpy.mockRestore();
    });

    it('should handle non-Error objects', async () => {
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});
      const testError = 'String error';

      await expect(testService.testHandleDatabaseError(testError)).rejects.toBe(testError);

      expect(consoleSpy).toHaveBeenCalledWith('Database error:', testError);

      consoleSpy.mockRestore();
    });

    it('should handle null errors', async () => {
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});
      const testError = null;

      await expect(testService.testHandleDatabaseError(testError)).rejects.toBe(testError);

      expect(consoleSpy).toHaveBeenCalledWith('Database error:', testError);

      consoleSpy.mockRestore();
    });

    it('should handle undefined errors', async () => {
      const consoleSpy = vi.spyOn(console, 'error').mockImplementation(() => {});
      const testError = undefined;

      await expect(testService.testHandleDatabaseError(testError)).rejects.toBe(testError);

      expect(consoleSpy).toHaveBeenCalledWith('Database error:', testError);

      consoleSpy.mockRestore();
    });
  });

  describe('disconnect', () => {
    it('should disconnect from prisma client', async () => {
      const disconnectSpy = vi.spyOn(testService['prisma'], '$disconnect').mockResolvedValue(undefined);

      await testService.disconnect();

      expect(disconnectSpy).toHaveBeenCalledOnce();

      disconnectSpy.mockRestore();
    });

    it('should handle disconnect errors gracefully', async () => {
      const disconnectSpy = vi.spyOn(testService['prisma'], '$disconnect').mockRejectedValue(new Error('Disconnect failed'));

      await expect(testService.disconnect()).rejects.toThrow('Disconnect failed');

      expect(disconnectSpy).toHaveBeenCalledOnce();

      disconnectSpy.mockRestore();
    });
  });

  describe('prisma property', () => {
    it('should have access to prisma client', () => {
      expect(testService['prisma']).toBeDefined();
      expect(typeof testService['prisma'].$connect).toBe('function');
      expect(typeof testService['prisma'].$disconnect).toBe('function');
    });
  });
});
