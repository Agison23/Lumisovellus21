import { BaseService } from '../BaseService';
import { Review, ReviewRequest, SnowType } from '../../types';

export class ReviewsService extends BaseService {
  async getAllSnowTypes(): Promise<SnowType[]> {
    try {
      const snowTypes = await this.prisma.snowType.findMany();

      return snowTypes.map((snowType) => ({
        id: snowType.id.toString(),
        name: snowType.name,
        colour: snowType.colour,
        skiability: snowType.skiability,
        categoryId: snowType.categoryId,
        explanation: snowType.explanation,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getLatestReviews(days: number = 3): Promise<Review[]> {
    try {
      const daysAgo = new Date();
      daysAgo.setDate(daysAgo.getDate() - days);

      const reviews = await this.prisma.$queryRaw<
        Array<{
          id: number;
          time: Date;
          segment: number;
          snowType: number | null;
          details: number | null;
          comment: string | null;
        }>
      >`
        SELECT id, time, segment, snowType, details, comment
        FROM userReviews
        WHERE (segment, time) IN (
          SELECT segment, MAX(time)
          FROM userReviews
          GROUP BY segment
        )
        AND time > ${daysAgo}
        ORDER BY segment
      `;

      return reviews.map((review) => ({
        id: review.id.toString(),
        time: review.time,
        segment: review.segment.toString(),
        snowType: review.snowType?.toString(),
        details: review.details,
        comment: review.comment,
        userId: undefined,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getAllReviews(days: number = 7): Promise<any[]> {
    try {
      const daysAgo = new Date();
      daysAgo.setDate(daysAgo.getDate() - days);

      const reviews = await this.prisma.$queryRaw<
        Array<{
          time: Date;
          details: number | null;
          snowType: number | null;
          comment: string | null;
          snow: string | null;
          segment: string | null;
        }>
      >`
        SELECT userReviews.time, userReviews.details, userReviews.snowType, userReviews.comment, 
               snowTypes.name AS snow, segments.name AS segment
        FROM userReviews
        LEFT JOIN snowTypes ON userReviews.snowType = snowTypes.id
        LEFT JOIN segments ON userReviews.segment = segments.id
        WHERE time > ${daysAgo}
        ORDER BY time DESC
      `;

      return reviews;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async createReview(
    reviewData: ReviewRequest,
    segmentId: string
  ): Promise<Review> {
    try {
      if (reviewData.segment !== segmentId) {
        throw new Error('Segment ID mismatch');
      }

      const review = await this.prisma.userReview.create({
        data: {
          id: crypto.randomUUID(),
          segment: reviewData.segment,
          snowType: reviewData.snowType,
          details: reviewData.details,
          comment: reviewData.comment,
          // Anonymous review while auth is disabled
          userId: undefined,
          time: new Date(),
        },
        include: {
          segmentRel: true,
          snowTypeRel: true,
        },
      });

      return {
        id: review.id.toString(),
        time: review.time,
        segment: review.segment.toString(),
        snowType: review.snowType?.toString(),
        details: review.details,
        comment: review.comment,
        userId: review.userId,
      };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
