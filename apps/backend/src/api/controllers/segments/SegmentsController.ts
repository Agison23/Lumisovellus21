import { Request, Response } from 'express';
import { z } from 'zod';
import { SegmentsService, SegmentQueryParams } from '../../services/segments/SegmentsService.js';
import { ApiResponseHandler } from '../../middleware/responseHandler.js';
import { asyncHandler } from '../../middleware/errorHandler.js';
import { AuthenticatedRequest, HazardType } from '../../types';
import { segmentQuerySchema, segmentSchema, guideUpdateSchema } from '../../middleware/validation.js';

export class SegmentsController {
  private segmentsService: SegmentsService;

  constructor() {
    this.segmentsService = new SegmentsService();
  }

  getAllSegments = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const parsed = segmentQuerySchema.safeParse(req.query);
      if (!parsed.success) {
        ApiResponseHandler.validationError(
          res,
          'Invalid segment query parameters',
          parsed.error.flatten()
        );
        return;
      }

      const queryParams: SegmentQueryParams = parsed.data;

      const segments = await this.segmentsService.getAllSegments(queryParams);
      const normalizedSegments = segments.map((segment) => ({
        ...segment,
        isLowerSegment:
          typeof segment.isLowerSegment === 'number' && !Number.isNaN(segment.isLowerSegment)
            ? segment.isLowerSegment.toString()
            : null,
      }));
      ApiResponseHandler.success(res, normalizedSegments, 200, undefined, z.array(segmentSchema));
    }
  );

  createOrUpdateGuideUpdate = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      const { id } = req.params;
      
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const guideUpdateData: {
        description: string | null;
        primarySnowTypeIds: string[];
        secondarySnowTypeIds: string[];
        hazards?: string[];
      } = req.body;

      // Validate request body
      if (
        !Array.isArray(guideUpdateData.primarySnowTypeIds) ||
        !Array.isArray(guideUpdateData.secondarySnowTypeIds)
      ) {
        ApiResponseHandler.validationError(
          res,
          'primarySnowTypeIds and secondarySnowTypeIds must be arrays'
        );
        return;
      }

      // Ensure hazards is an array (default to empty array if not provided)
      if (guideUpdateData.hazards === undefined) {
        guideUpdateData.hazards = [];
      } else if (!Array.isArray(guideUpdateData.hazards)) {
        ApiResponseHandler.validationError(
          res,
          'hazards must be an array'
        );
        return;
      }

      if (guideUpdateData.primarySnowTypeIds.length > 2) {
        ApiResponseHandler.validationError(
          res,
          'Maximum 2 primary snow types allowed'
        );
        return;
      }

      if (guideUpdateData.secondarySnowTypeIds.length > 2) {
        ApiResponseHandler.validationError(
          res,
          'Maximum 2 secondary snow types allowed'
        );
        return;
      }

      // Validate hazards are valid HazardType values
      const validHazards = ['stones', 'branches'];
      const invalidHazards = guideUpdateData.hazards.filter(
        (h) => !validHazards.includes(h)
      );
      if (invalidHazards.length > 0) {
        ApiResponseHandler.validationError(
          res,
          `Invalid hazard types: ${invalidHazards.join(', ')}. Valid types are: ${validHazards.join(', ')}`
        );
        return;
      }

      const guideUpdate = await this.segmentsService.createOrUpdateGuideUpdate(
        id,
        req.user.id,
        {
          description: guideUpdateData.description,
          primarySnowTypeIds: guideUpdateData.primarySnowTypeIds,
          secondarySnowTypeIds: guideUpdateData.secondarySnowTypeIds,
          hazards: guideUpdateData.hazards as HazardType[],
        }
      );
      ApiResponseHandler.success(res, guideUpdate, 200, undefined, guideUpdateSchema);
    }
  );
}
