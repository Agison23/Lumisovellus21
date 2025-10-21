import { Request, Response } from "express";
import { HealthService } from "../../services/health/HealthService";
import { ApiResponseHandler } from "../../middleware/responseHandler";
import { asyncHandler } from "../../middleware/errorHandler";

export class HealthController {
  private healthService: HealthService;

  constructor() {
    this.healthService = new HealthService();
  }

  getHealth = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const healthData = await this.healthService.getHealthStatus();
      ApiResponseHandler.success(res, healthData);
    },
  );
}
