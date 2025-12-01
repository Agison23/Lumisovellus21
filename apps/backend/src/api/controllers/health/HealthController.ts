import { Request, Response } from 'express';
import { HealthService } from '../../services/health/HealthService.js';
import { ApiResponseHandler } from '../../middleware/responseHandler.js';
import { asyncHandler } from '../../middleware/errorHandler.js';
import { healthResponseSchema } from '../../openapi/schemas.js';

export class HealthController {
  private healthService: HealthService;

  constructor() {
    this.healthService = new HealthService();
  }

  getHealth = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const healthData = await this.healthService.getHealthStatus();
      ApiResponseHandler.success(res, healthData, 200, undefined, healthResponseSchema);
    }
  );
}
