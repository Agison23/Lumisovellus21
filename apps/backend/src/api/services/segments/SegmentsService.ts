import { BaseService } from '../BaseService';
import { Segment, SegmentUpdate, GuideUpdate, UserReviewItem, HazardType } from '../../types';

export interface SegmentQueryParams {
  bbox?: string; // Format: "minLat,minLng,maxLat,maxLng"
  search?: string;
  updatedSince?: string; // ISO 8601 date string
}

export class SegmentsService extends BaseService {

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

      if (!guideUpdate || !guideUpdate.snowConditions) {
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

  /**
   * Get user reviews for a segment (limited to 3 most recent)
   */
  private async getUserReviewsForSegment(segmentId: string): Promise<UserReviewItem[]> {
    try {
      const reviews = await this.prisma.userReview.findMany({
        where: {
          segment: segmentId,
        },
        orderBy: { time: 'desc' },
        take: 3,
      });

      return reviews.map((review) => {
        // Parse hazards from JSON if it exists
        const hazards = review.hazards
          ? (Array.isArray(review.hazards)
              ? (review.hazards as HazardType[])
              : JSON.parse(review.hazards as string))
          : [];

        return {
          submittedAt: review.time,
          snowTypeId: review.snowType || '',
          secondarySnowTypeId: review.secondarySnowType || null,
          hazards: hazards,
        };
      });
    } catch (error) {
      console.error('Error fetching user reviews:', error);
      return [];
    }
  }

  async getAllSegments(queryParams?: SegmentQueryParams): Promise<Segment[]> {
    try {
      const segments = await this.prisma.segment.findMany({
        include: {
          coordinates: {
            orderBy: { order: 'asc' },
          },
          snowUpdates: {
            orderBy: { time: 'desc' },
            take: 1,
          },
        },
      });

      // Parse bounding box if provided
      let bboxParams: [number, number, number, number] | null = null;
      if (queryParams?.bbox) {
        const bboxParts = queryParams.bbox.split(',').map(Number);
        if (bboxParts.length === 4 && bboxParts.every((num) => !isNaN(num))) {
          bboxParams = [bboxParts[0], bboxParts[1], bboxParts[2], bboxParts[3]];
        }
      }

      // Parse updatedSince date if provided
      let updatedSinceDate: Date | null = null;
      if (queryParams?.updatedSince) {
        updatedSinceDate = new Date(queryParams.updatedSince);
        if (isNaN(updatedSinceDate.getTime())) {
          updatedSinceDate = null;
        }
      }

      // Transform and filter segments
      // First, get guide updates and user reviews for all segments in parallel
      const segmentsWithExtras = await Promise.all(
        segments.map(async (segment) => {
          const [guideUpdate, userReviews] = await Promise.all([
            this.getGuideUpdateForSegment(segment.id),
            this.getUserReviewsForSegment(segment.id),
          ]);

          return {
            segment,
            guideUpdate,
            userReviews,
          };
        })
      );

      const transformedSegments = segmentsWithExtras
        .map(({ segment, guideUpdate, userReviews }) => ({
          id: segment.id.toString(),
          name: segment.name,
          terrain: segment.terrain,
          avalancheDanger: segment.avalancheDanger,
          isLowerSegment: segment.isLowerSegment,
          points: segment.coordinates.map((coord) => ({
            lat: coord.latitude,
            lng: coord.longitude,
          })),
          guideUpdate,
          userReviews,
          lastUpdated:
            segment.snowUpdates.length > 0
              ? segment.snowUpdates[0].time
              : segment.updatedAt,
          updatedAt: segment.updatedAt,
        }))
        .filter((segment) => {
          // Filter by search term
          if (queryParams?.search) {
            const searchLower = queryParams.search.toLowerCase();
            if (!segment.name.toLowerCase().includes(searchLower)) {
              return false;
            }
          }

          // Filter by bounding box
          if (bboxParams) {
            const [minLat, minLng, maxLat, maxLng] = bboxParams;
            const withinBounds = segment.points.some(
              (point) =>
                point.lat >= minLat &&
                point.lat <= maxLat &&
                point.lng >= minLng &&
                point.lng <= maxLng
            );
            if (!withinBounds) {
              return false;
            }
          }

          // Filter by updatedSince
          if (updatedSinceDate) {
            const segmentUpdatedAt = segment.lastUpdated || segment.updatedAt;
            if (segmentUpdatedAt < updatedSinceDate) {
              return false;
            }
          }

          return true;
        })
        .map((segment) => {
          // Remove internal fields before returning
          const { lastUpdated, updatedAt, ...rest } = segment;
          return rest;
        });

      return transformedSegments;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getSegmentUpdates(
    segmentId: string,
    limit: number = 3,
    days: number = 3
  ): Promise<any[]> {
    try {
      const where: any = { 
        status: 'ACTIVE',
        segment: segmentId 
      };

      // Apply days filter
      const daysAgo = new Date();
      daysAgo.setDate(daysAgo.getDate() - days);
      where.time = { gte: daysAgo };

      const updates = await this.prisma.snowUpdate.findMany({
        where,
        include: {
          segmentRel: true,
          creatorRel: {
            select: { firstName: true, lastName: true },
          },
          snowConditions: {
            include: {
              snowTypeRel: true,
            },
          },
          reviewReferences: {
            include: {
              reviewRel: true,
            },
          },
        },
        orderBy: { time: 'desc' },
        take: limit,
      });

      // Fetch secondary snow types separately for conditions that have them
      const secondarySnowTypeIds = new Set<string>();
      updates.forEach((update) => {
        update.snowConditions.forEach((condition) => {
          if (condition.secondarySnowType) {
            secondarySnowTypeIds.add(condition.secondarySnowType);
          }
        });
      });

      const secondarySnowTypesMap = new Map<string, string>();
      if (secondarySnowTypeIds.size > 0) {
        const secondarySnowTypes = await this.prisma.snowType.findMany({
          where: {
            id: { in: Array.from(secondarySnowTypeIds) },
          },
          select: { id: true, name: true },
        });
        secondarySnowTypes.forEach((st) => {
          secondarySnowTypesMap.set(st.id, st.name);
        });
      }

      return updates.map((update) => ({
        id: update.id,
        segment: update.segment,
        time: update.time,
        description: update.description,
        weather: update.weather,
        temperature: update.temperature,
        windSpeed: update.windSpeed,
        visibility: update.visibility,
        status: update.status,
        priority: update.priority,
        creator: update.creatorRel,
        segmentName: update.segmentRel.name,
        snowConditions: update.snowConditions.map((condition) => ({
          id: condition.id,
          snowType: condition.snowTypeRel?.name,
          secondarySnowType: condition.secondarySnowType
            ? secondarySnowTypesMap.get(condition.secondarySnowType) || null
            : null,
          layer: condition.layer,
          depth: condition.depth,
          coverage: condition.coverage,
          quality: condition.quality,
          hardness: condition.hardness,
          moisture: condition.moisture,
          notes: condition.notes,
          createdAt: condition.createdAt,
        })),
        reviewReferences: update.reviewReferences,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  /**
   * Create or update a guide update for a segment (admin only)
   * This will create a new SnowUpdate with ACTIVE status or update the existing one
   */
  async createOrUpdateGuideUpdate(
    segmentId: string,
    creatorId: string,
    guideUpdateData: {
      description: string | null;
      primarySnowTypeIds: string[];
      secondarySnowTypeIds: string[];
    }
  ): Promise<GuideUpdate> {
    try {
      // Validate snow type IDs exist
      if (guideUpdateData.primarySnowTypeIds.length > 2) {
        throw new Error('Maximum 2 primary snow types allowed');
      }
      if (guideUpdateData.secondarySnowTypeIds.length > 2) {
        throw new Error('Maximum 2 secondary snow types allowed');
      }

      // Verify all snow type IDs exist
      const allSnowTypeIds = [
        ...guideUpdateData.primarySnowTypeIds,
        ...guideUpdateData.secondarySnowTypeIds,
      ];
      if (allSnowTypeIds.length > 0) {
        const existingSnowTypes = await this.prisma.snowType.findMany({
          where: {
            id: { in: allSnowTypeIds },
          },
        });
        if (existingSnowTypes.length !== allSnowTypeIds.length) {
          throw new Error('One or more snow type IDs are invalid');
        }
      }

      // Check if segment exists
      const segment = await this.prisma.segment.findUnique({
        where: { id: segmentId },
      });
      if (!segment) {
        throw new Error('Segment not found');
      }

      // Archive any existing active guide updates for this segment
      await this.prisma.snowUpdate.updateMany({
        where: {
          segment: segmentId,
          status: 'ACTIVE',
          creatorRel: {
            role: 'ADMIN',
          },
        },
        data: {
          status: 'ARCHIVED',
        },
      });

      // Prepare snow conditions to create
      // Strategy: Use SURFACE layer for first primary (with first secondary if exists)
      //           Use MIDDLE layer for second primary (with second secondary if exists)
      //           Use BASE layer if we have more secondary types than primary types
      const conditionsToCreate: Array<{
        id: string;
        snowType: string;
        secondarySnowType?: string;
        layer: 'SURFACE' | 'MIDDLE' | 'BASE';
      }> = [];

      // Handle primary snow types
      guideUpdateData.primarySnowTypeIds.forEach((primaryId, index) => {
        const layer: 'SURFACE' | 'MIDDLE' | 'BASE' =
          index === 0 ? 'SURFACE' : index === 1 ? 'MIDDLE' : 'BASE';
        const secondaryId =
          index < guideUpdateData.secondarySnowTypeIds.length
            ? guideUpdateData.secondarySnowTypeIds[index]
            : undefined;

        conditionsToCreate.push({
          id: crypto.randomUUID(),
          snowType: primaryId,
          secondarySnowType: secondaryId,
          layer,
        });
      });

      // Handle remaining secondary snow types (if we have more secondaries than primaries)
      if (guideUpdateData.secondarySnowTypeIds.length > guideUpdateData.primarySnowTypeIds.length) {
        // We need to attach remaining secondary types
        // Use the first primary type as base, or if no primaries, use the first secondary as base
        const basePrimaryType =
          guideUpdateData.primarySnowTypeIds[0] ||
          guideUpdateData.secondarySnowTypeIds[0];

        for (
          let i = guideUpdateData.primarySnowTypeIds.length;
          i < guideUpdateData.secondarySnowTypeIds.length;
          i++
        ) {
          const layer: 'SURFACE' | 'MIDDLE' | 'BASE' =
            guideUpdateData.primarySnowTypeIds.length === 0
              ? i === 0
                ? 'SURFACE'
                : i === 1
                  ? 'MIDDLE'
                  : 'BASE'
              : 'BASE';

          conditionsToCreate.push({
            id: crypto.randomUUID(),
            snowType: basePrimaryType,
            secondarySnowType: guideUpdateData.secondarySnowTypeIds[i],
            layer,
          });
        }
      }

      // Create new guide update
      const newUpdate = await this.prisma.snowUpdate.create({
        data: {
          id: crypto.randomUUID(),
          creator: creatorId,
          segment: segmentId,
          description: guideUpdateData.description,
          status: 'ACTIVE',
          priority: 1,
          time: new Date(),
          snowConditions: {
            create: conditionsToCreate,
          },
        },
        include: {
          snowConditions: true,
        },
      });

      // Return the guide update in the expected format
      return {
        description: newUpdate.description,
        primarySnowTypeIds: guideUpdateData.primarySnowTypeIds,
        secondarySnowTypeIds: guideUpdateData.secondarySnowTypeIds,
      };
    } catch (error) {
      if (error instanceof Error) {
        throw error;
      }
      throw new Error('Failed to create guide update');
    }
  }

  async getAllUpdates(
    days: number = 3,
    options?: {
      segmentId?: string;
      updatedSince?: string;
      from?: string;
      to?: string;
    }
  ): Promise<any[]> {
    try {
      const where: any = { status: 'ACTIVE' };

      if (options?.segmentId) {
        where.segment = options.segmentId;
      }

      // Determine time filter precedence: from/to > updatedSince > days
      if (options?.from || options?.to) {
        const fromDate = options.from ? new Date(options.from) : undefined;
        const toDate = options.to ? new Date(options.to) : undefined;
        where.time = {
          ...(fromDate && !isNaN(fromDate.getTime()) ? { gte: fromDate } : {}),
          ...(toDate && !isNaN(toDate.getTime()) ? { lte: toDate } : {}),
        };
      } else if (options?.updatedSince) {
        const sinceDate = new Date(options.updatedSince);
        if (!isNaN(sinceDate.getTime())) {
          where.time = { gte: sinceDate };
        }
      } else {
        const daysAgo = new Date();
        daysAgo.setDate(daysAgo.getDate() - days);
        where.time = { gte: daysAgo };
      }

      const updates = await this.prisma.snowUpdate.findMany({
        where,
        include: {
          segmentRel: true,
          creatorRel: {
            select: { firstName: true, lastName: true },
          },
          snowConditions: {
            include: {
              snowTypeRel: true,
            },
          },
          reviewReferences: {
            include: {
              reviewRel: true,
            },
          },
        },
        orderBy: { time: 'desc' },
      });

      // Fetch secondary snow types separately for conditions that have them
      const secondarySnowTypeIds = new Set<string>();
      updates.forEach((update) => {
        update.snowConditions.forEach((condition) => {
          if (condition.secondarySnowType) {
            secondarySnowTypeIds.add(condition.secondarySnowType);
          }
        });
      });

      const secondarySnowTypesMap = new Map<string, string>();
      if (secondarySnowTypeIds.size > 0) {
        const secondarySnowTypes = await this.prisma.snowType.findMany({
          where: {
            id: { in: Array.from(secondarySnowTypeIds) },
          },
          select: { id: true, name: true },
        });
        secondarySnowTypes.forEach((st) => {
          secondarySnowTypesMap.set(st.id, st.name);
        });
      }

      return updates.map((update) => ({
        id: update.id,
        segment: update.segment,
        time: update.time,
        description: update.description,
        weather: update.weather,
        temperature: update.temperature,
        windSpeed: update.windSpeed,
        visibility: update.visibility,
        status: update.status,
        priority: update.priority,
        creator: update.creatorRel,
        segmentName: update.segmentRel.name,
        snowConditions: update.snowConditions.map((condition) => ({
          id: condition.id,
          snowType: condition.snowTypeRel?.name,
          secondarySnowType: condition.secondarySnowType
            ? secondarySnowTypesMap.get(condition.secondarySnowType) || null
            : null,
          layer: condition.layer,
          depth: condition.depth,
          coverage: condition.coverage,
          quality: condition.quality,
          hardness: condition.hardness,
          moisture: condition.moisture,
          notes: condition.notes,
          createdAt: condition.createdAt,
        })),
        reviewReferences: update.reviewReferences,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
