import { Request, Response } from 'express';
import { z } from 'zod';
import { ReviewsService } from '../../services/reviews/ReviewsService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';
import {
  reviewsQuerySchema,
  segmentObservationQuerySchema,
  observationSchema,
  reviewResponseSchema,
  snowTypeResponseSchema,
} from '../../middleware/validation';

export class ReviewsController {
  private reviewsService: ReviewsService;

  constructor() {
    this.reviewsService = new ReviewsService();
  }

  getAllSnowTypes = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const snowTypes = await this.reviewsService.getAllSnowTypes();
      ApiResponseHandler.success(res, snowTypes, 200, undefined, z.array(snowTypeResponseSchema));
    }
  );

  getLatestReviews = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const parsed = reviewsQuerySchema.safeParse(req.query);
      if (!parsed.success) {
        ApiResponseHandler.validationError(
          res,
          'Invalid observation query parameters',
          parsed.error.flatten()
        );
        return;
      }

      const {
        days = 3,
        limit: reviewLimit = 3,
        page = 1,
        pageSize = 20,
      } = parsed.data;

      const { observations, total } = await this.reviewsService.getLatestReviews(
        days,
        reviewLimit,
        page,
        pageSize
      );

      const totalPages = Math.ceil(total / pageSize);

      ApiResponseHandler.success(res, observations, 200, {
        pagination: {
          page,
          limit: pageSize,
          total,
          totalPages,
        },
      }, z.array(observationSchema));
    }
  );

  getSegmentObservations = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const parsed = segmentObservationQuerySchema.safeParse(req.query);
      if (!parsed.success) {
        ApiResponseHandler.validationError(
          res,
          'Invalid observation query parameters',
          parsed.error.flatten()
        );
        return;
      }

      const { days = 3, limit = 3 } = parsed.data;
      const observation = await this.reviewsService.getSegmentObservations(
        req.params.id,
        days,
        limit
      );

      if (!observation) {
        ApiResponseHandler.notFound(res, 'No observations for the requested segment');
        return;
      }

      ApiResponseHandler.success(res, observation, 200, undefined, observationSchema);
    }
  );

  createReview = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { id } = req.params;
      const reviewData = req.body;
      const review = await this.reviewsService.createReview(reviewData, id);
      ApiResponseHandler.success(res, review, 201, undefined, reviewResponseSchema);
    }
  );
}
