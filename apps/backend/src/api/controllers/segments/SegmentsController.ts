import { Request, Response } from 'express';
import {
  SegmentsService,
  SegmentQueryParams,
} from '../../services/segments/SegmentsService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';

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
      const updates = await this.segmentsService.getSegmentUpdates(id);
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
}
