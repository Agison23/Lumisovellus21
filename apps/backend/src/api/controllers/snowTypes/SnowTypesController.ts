import { Request, Response } from 'express';
import { z } from 'zod';
import { SnowTypesService } from '../../services/snowTypes/SnowTypesService.js';
import { ApiResponseHandler } from '../../middleware/responseHandler.js';
import { asyncHandler } from '../../middleware/errorHandler.js';
import {
  createSnowTypeSchema,
  snowTypeIdSchema,
  addSecondarySnowTypesSchema,
  snowTypeResponseSchema,
  primarySnowTypeResponseSchema,
} from '../../middleware/validation.js';

export class SnowTypesController {
  private snowTypesService: SnowTypesService;

  constructor() {
    this.snowTypesService = new SnowTypesService();
  }

  createSnowType = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      // Validate request body
      const validatedData = createSnowTypeSchema.parse(req.body);

      const snowType = await this.snowTypesService.createSnowType(validatedData);
      ApiResponseHandler.success(res, snowType, 201, undefined, snowTypeResponseSchema);
    }
  );

  addSecondarySnowTypes = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      // Validate path parameter - this is the snow type that will have secondary types added
      const { id } = snowTypeIdSchema.parse({ id: req.params.id });
      
      // Validate request body - these are the snow type IDs that will become secondary types
      const { secondarySnowTypeIds } = addSecondarySnowTypesSchema.parse(req.body);

      const snowType = await this.snowTypesService.addSecondarySnowTypes(
        id,
        secondarySnowTypeIds
      );
      ApiResponseHandler.success(res, snowType, 200, undefined, snowTypeResponseSchema);
    }
  );

  getAllSnowTypesFlat = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const snowTypes = await this.snowTypesService.getAllSnowTypesFlat();
      ApiResponseHandler.success(res, snowTypes, 200, undefined, z.array(snowTypeResponseSchema));
    }
  );

  getPrimarySnowTypes = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const snowTypes = await this.snowTypesService.getPrimarySnowTypes();
      ApiResponseHandler.success(res, snowTypes, 200, undefined, z.array(primarySnowTypeResponseSchema));
    }
  );
}

