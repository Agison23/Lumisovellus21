import { Request, Response } from 'express';
import { SegmentsService, SegmentQueryParams } from '../../services/segments/SegmentsService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';
import { AuthenticatedRequest } from '../../types';
import { segmentQuerySchema } from '../../middleware/validation';

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
      ApiResponseHandler.success(res, normalizedSegments);
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
      } = req.body;

      // Validate request body
      if (
        !Array.isArray(guideUpdateData.primarySnowTypeIds) ||
        !Array.isArray(guideUpdateData.secondarySnowTypeIds)
      ) {
        ApiResponseHandler.badRequest(
          res,
          'primarySnowTypeIds and secondarySnowTypeIds must be arrays'
        );
        return;
      }

      if (guideUpdateData.primarySnowTypeIds.length > 2) {
        ApiResponseHandler.badRequest(
          res,
          'Maximum 2 primary snow types allowed'
        );
        return;
      }

      if (guideUpdateData.secondarySnowTypeIds.length > 2) {
        ApiResponseHandler.badRequest(
          res,
          'Maximum 2 secondary snow types allowed'
        );
        return;
      }

      const guideUpdate = await this.segmentsService.createOrUpdateGuideUpdate(
        id,
        req.user.id,
        guideUpdateData
      );
      ApiResponseHandler.success(res, guideUpdate);
    }
  );
}
