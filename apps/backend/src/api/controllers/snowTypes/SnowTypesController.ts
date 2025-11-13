import { Request, Response } from 'express';
import { SnowTypesService } from '../../services/snowTypes/SnowTypesService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';
import {
  createSnowTypeSchema,
  snowTypeIdSchema,
  addSecondarySnowTypesSchema,
} from '../../middleware/validation';

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
      ApiResponseHandler.success(res, snowType, 201);
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
      ApiResponseHandler.success(res, snowType, 200);
    }
  );
}

