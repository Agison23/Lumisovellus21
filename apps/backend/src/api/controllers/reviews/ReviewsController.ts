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
      const reviews = await this.reviewsService.getLatestReviews(days);
      ApiResponseHandler.success(res, reviews);
    }
  );

  getAllReviews = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const days = parseInt(req.query.days as string) || 7;
      const reviews = await this.reviewsService.getAllReviews(days);
      ApiResponseHandler.success(res, reviews);
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
