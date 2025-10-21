import { Request, Response } from "express";
import { SegmentsService } from "../../services/segments/SegmentsService";
import { ApiResponseHandler } from "../../middleware/responseHandler";
import { asyncHandler } from "../../middleware/errorHandler";

export class SegmentsController {
  private segmentsService: SegmentsService;

  constructor() {
    this.segmentsService = new SegmentsService();
  }

  getAllSegments = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const segments = await this.segmentsService.getAllSegments();
      ApiResponseHandler.success(res, segments);
    },
  );

  getSegmentUpdates = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { id } = req.params;
      const updates = await this.segmentsService.getSegmentUpdates(id);
      ApiResponseHandler.success(res, updates);
    },
  );

  getAllUpdates = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const days = parseInt(req.query.days as string) || 3;
      const updates = await this.segmentsService.getAllUpdates(days);
      ApiResponseHandler.success(res, updates);
    },
  );
}
