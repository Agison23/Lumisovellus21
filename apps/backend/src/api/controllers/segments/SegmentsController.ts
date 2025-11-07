import { Request, Response } from 'express';
import {
  SegmentsService,
  SegmentQueryParams,
} from '../../services/segments/SegmentsService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';
import { AuthenticatedRequest } from '../../types';
import { GuideUpdate } from '../../types';

export class SegmentsController {
  private segmentsService: SegmentsService;

  constructor() {
    this.segmentsService = new SegmentsService();
  }

  getAllSegments = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const queryParams: SegmentQueryParams = {
        bbox: req.query.bbox as string | undefined,
        search: req.query.search as string | undefined,
        updatedSince: req.query.updatedSince as string | undefined,
      };

      const segments = await this.segmentsService.getAllSegments(queryParams);
      ApiResponseHandler.success(res, segments);
    }
  );

  getSegmentUpdates = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { id } = req.params;
      const limit = parseInt(req.query.limit as string) || 3;
      const days = parseInt(req.query.days as string) || 3;
      const updates = await this.segmentsService.getSegmentUpdates(id, limit, days);
      ApiResponseHandler.success(res, updates);
    }
  );

  getAllUpdates = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const days = parseInt(req.query.days as string) || 3;
      const segmentId = (req.query.segmentId as string) || undefined;
      const updatedSince = (req.query.updatedSince as string) || undefined;
      const from = (req.query.from as string) || undefined;
      const to = (req.query.to as string) || undefined;
      const updates = await this.segmentsService.getAllUpdates(days, {
        segmentId,
        updatedSince,
        from,
        to,
      });
      ApiResponseHandler.success(res, updates);
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
