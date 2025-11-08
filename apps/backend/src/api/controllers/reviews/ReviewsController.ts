import { Request, Response } from 'express';
import { ReviewsService } from '../../services/reviews/ReviewsService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';

export class ReviewsController {
  private reviewsService: ReviewsService;

  constructor() {
    this.reviewsService = new ReviewsService();
  }

  getAllSnowTypes = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const snowTypes = await this.reviewsService.getAllSnowTypes();
      ApiResponseHandler.success(res, snowTypes);
    }
  );

  getLatestReviews = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const days = parseInt(req.query.days as string) || 3;
      const reviewLimit = parseInt(req.query.limit as string) || 3;
      const page = parseInt(req.query.page as string) || 1;
      const pageSize = parseInt(req.query.pageSize as string) || 20;

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
      });
    }
  );

  createReview = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { id } = req.params;
      const reviewData = req.body;
      const review = await this.reviewsService.createReview(reviewData, id);
      ApiResponseHandler.success(res, review, 201);
    }
  );
}
