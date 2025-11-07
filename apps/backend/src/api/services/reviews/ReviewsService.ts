import { BaseService } from '../BaseService';
import { Review, ReviewRequest, SnowType, HazardType, Observation, GuideUpdate } from '../../types';

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

  /**
   * Get the latest guide update (SnowUpdate created by admin) for a segment
   */
  private async getGuideUpdateForSegment(segmentId: string): Promise<GuideUpdate | null> {
    try {
      // First, find admin users who created updates for this segment
      const adminUsers = await this.prisma.user.findMany({
        where: { role: 'ADMIN' },
        select: { id: true },
      });
      const adminUserIds = adminUsers.map((u) => u.id);

      if (adminUserIds.length === 0) {
        return null;
      }

      // Get the latest active SnowUpdate created by an admin
      const guideUpdate = await this.prisma.snowUpdate.findFirst({
        where: {
          segment: segmentId,
          status: 'ACTIVE',
          creator: { in: adminUserIds },
        },
        orderBy: { time: 'desc' },
        include: {
          snowConditions: true,
        },
      });

      if (!guideUpdate || !guideUpdate.snowConditions || guideUpdate.snowConditions.length === 0) {
        return null;
      }

      // Extract primary and secondary snow type IDs directly from the condition fields
      const primarySnowTypeIds: string[] = [];
      const secondarySnowTypeIds: string[] = [];

      for (const condition of guideUpdate.snowConditions) {
        if (condition.snowType && !primarySnowTypeIds.includes(condition.snowType)) {
          primarySnowTypeIds.push(condition.snowType);
        }
        if (condition.secondarySnowType && !secondarySnowTypeIds.includes(condition.secondarySnowType)) {
          secondarySnowTypeIds.push(condition.secondarySnowType);
        }
      }

      // Limit to max 2 each
      return {
        description: guideUpdate.description,
        primarySnowTypeIds: primarySnowTypeIds.slice(0, 2),
        secondarySnowTypeIds: secondarySnowTypeIds.slice(0, 2),
      };
    } catch (error) {
      // If there's an error, return null rather than failing the entire request
      console.error('Error fetching guide update:', error);
      return null;
    }
  }

  async getLatestReviews(days: number = 3, limit: number = 3): Promise<Observation[]> {
    try {
      const daysAgo = new Date();
      daysAgo.setDate(daysAgo.getDate() - days);

      // Get all segments that have reviews or guide updates within the last N days
      // First, get segments with reviews
      const reviews = await this.prisma.userReview.findMany({
        where: {
          time: { gt: daysAgo },
        },
        select: {
          segment: true,
        },
        distinct: ['segment'],
      });

      // Get segments with active guide updates (SnowUpdates created by admin)
      // Note: Guide updates are shown if they're active, regardless of when created
      const adminUsers = await this.prisma.user.findMany({
        where: { role: 'ADMIN' },
        select: { id: true },
      });
      const adminUserIds = adminUsers.map((u) => u.id);

      const guideUpdateSegments = adminUserIds.length > 0
        ? await this.prisma.snowUpdate.findMany({
            where: {
              status: 'ACTIVE',
              creator: { in: adminUserIds },
            },
            select: {
              segment: true,
            },
            distinct: ['segment'],
          })
        : [];

      // Combine unique segment IDs
      const segmentIds = new Set<string>();
      reviews.forEach((r) => segmentIds.add(r.segment));
      guideUpdateSegments.forEach((g) => segmentIds.add(g.segment));

      // Build observations for each segment
      const observations: Observation[] = [];

      for (const segmentId of segmentIds) {
        // Get guide update for this segment
        const guideUpdate = await this.getGuideUpdateForSegment(segmentId);

        // Get user reviews for this segment (limited and filtered by date)
        const segmentReviews = await this.prisma.userReview.findMany({
          where: {
            segment: segmentId,
            time: { gt: daysAgo },
          },
          orderBy: { time: 'desc' },
          take: limit,
        });

        const userReviews = segmentReviews.map((review) => {
          const hazards = review.hazards
            ? (Array.isArray(review.hazards)
                ? (review.hazards as HazardType[])
                : JSON.parse(review.hazards as string))
            : [];

          return {
            submittedAt: review.time,
            snowTypeId: review.snowType || '',
            hazards: hazards,
          };
        });

        // Only include segments that have at least user reviews or a guide update
        if (userReviews.length > 0 || guideUpdate !== null) {
          observations.push({
            segmentId: segmentId,
            guideUpdate: guideUpdate,
            userReviews: userReviews,
          });
        }
      }

      return observations;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async createReview(
    reviewData: ReviewRequest,
    segmentId: string
  ): Promise<Review> {
    try {
      const review = await this.prisma.userReview.create({
        data: {
          id: crypto.randomUUID(),
          segment: segmentId, // Get segment ID from URL path parameter
          snowType: reviewData.snowType,
          secondarySnowType: reviewData.secondarySnowType || null,
          hazards: reviewData.hazards.length > 0 ? reviewData.hazards : undefined,
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

      // Parse hazards from JSON if it exists
      const hazards = review.hazards
        ? (Array.isArray(review.hazards)
            ? (review.hazards as HazardType[])
            : JSON.parse(review.hazards as string))
        : [];

      return {
        id: review.id.toString(),
        time: review.time,
        segment: review.segment.toString(),
        snowType: review.snowType?.toString(),
        hazards: hazards,
        comment: review.comment,
        userId: review.userId,
      };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
