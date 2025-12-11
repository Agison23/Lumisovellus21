import { BaseService } from '../BaseService.js';
import { HealthResponse } from '../../types';

export class HealthService extends BaseService {
  async getHealthStatus(): Promise<HealthResponse> {
    // You could add database connectivity check here
    // await this.prisma.$queryRaw`SELECT 1`;

    return {
      status: 'ok',
      version: '2.0.0',
    };
  }
}
