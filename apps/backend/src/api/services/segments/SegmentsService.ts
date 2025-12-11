import { BaseService } from '../BaseService.js';
import { Segment, GuideUpdate, UserReviewItem, HazardType } from '../../types';

export interface SegmentQueryParams {
  bbox?: string; // Format: "minLat,minLng,maxLat,maxLng"
  minLat?: number;
  minLng?: number;
  maxLat?: number;
  maxLng?: number;
  search?: string;
  updatedSince?: string; // ISO 8601 date string
  observationDays?: number;
}

export class SegmentsService extends BaseService {
  private resolveBoundingBox(
    queryParams?: SegmentQueryParams
  ): [number, number, number, number] | null {
    if (!queryParams) {
      return null;
    }

    const hasSeparateParams =
      typeof queryParams.minLat === 'number' &&
      typeof queryParams.minLng === 'number' &&
      typeof queryParams.maxLat === 'number' &&
      typeof queryParams.maxLng === 'number' &&
      !Number.isNaN(queryParams.minLat) &&
      !Number.isNaN(queryParams.minLng) &&
      !Number.isNaN(queryParams.maxLat) &&
      !Number.isNaN(queryParams.maxLng);

    if (hasSeparateParams) {
      return [
        queryParams.minLat!,
        queryParams.minLng!,
        queryParams.maxLat!,
        queryParams.maxLng!,
      ];
    }

    if (queryParams.bbox) {
      const bboxParts = queryParams.bbox.split(',').map(Number);
      if (bboxParts.length === 4 && bboxParts.every((num) => !isNaN(num))) {
        // Interpret bbox according to OGC order: minLng,minLat,maxLng,maxLat
        const [minLng, minLat, maxLng, maxLat] = bboxParts;
        return [minLat, minLng, maxLat, maxLng];
      }
    }

    return null;
  }

  /**
   * Get the latest guide update (SnowUpdate created by admin or guide) for a segment
   */
  private async getGuideUpdateForSegment(
    segmentId: string,
    since?: Date
  ): Promise<GuideUpdate | null> {
    try {
      // Get the latest active SnowUpdate created by an admin or guide
      const guideUpdate = await this.prisma.snowUpdate.findFirst({
        where: {
          segment: segmentId,
          status: 'ACTIVE',
          creatorRel: {
            role: { in: ['ADMIN', 'GUIDE'] },
          },
          ...(since
            ? {
                time: {
                  gte: since,
                },
              }
            : {}),
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
        if (
          condition.snowType &&
          !primarySnowTypeIds.includes(condition.snowType)
        ) {
          primarySnowTypeIds.push(condition.snowType);
        }
        if (
          condition.secondarySnowType &&
          !secondarySnowTypeIds.includes(condition.secondarySnowType)
        ) {
          secondarySnowTypeIds.push(condition.secondarySnowType);
        }
      }

      // Parse hazards from JSON if it exists
      const hazards = (guideUpdate as any).hazards
        ? Array.isArray((guideUpdate as any).hazards)
          ? ((guideUpdate as any).hazards as HazardType[])
          : JSON.parse((guideUpdate as any).hazards as string)
        : [];

      // Limit to max 2 each
      return {
        description: guideUpdate.description,
        primarySnowTypeIds: primarySnowTypeIds.slice(0, 2),
        secondarySnowTypeIds: secondarySnowTypeIds.slice(0, 2),
        hazards: hazards,
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
  private async getUserReviewsForSegment(
    segmentId: string,
    limit: number = 3,
    observationDays: number = 3
  ): Promise<UserReviewItem[]> {
    try {
      const where: any = { segment: segmentId };

      if (observationDays) {
        const cutoff = new Date();
        cutoff.setDate(cutoff.getDate() - observationDays);
        where.time = { gte: cutoff };
      }

      const reviews = await this.prisma.userReview.findMany({
        where,
        orderBy: { time: 'desc' },
        take: limit,
      });

      return reviews.map((review) => {
        const hazards = review.hazards
          ? Array.isArray(review.hazards)
            ? (review.hazards as HazardType[])
            : JSON.parse(review.hazards as string)
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

      const bboxParams = this.resolveBoundingBox(queryParams);

      // Parse updatedSince date if provided
      let updatedSinceDate: Date | null = null;
      if (queryParams?.updatedSince) {
        updatedSinceDate = new Date(queryParams.updatedSince);
        if (isNaN(updatedSinceDate.getTime())) {
          updatedSinceDate = null;
        }
      }

      const observationDays = queryParams?.observationDays || 3;
      const observationsSince = new Date()
      observationsSince.setDate(observationsSince.getDate() - observationDays);

      // Transform and filter segments
      // First, get guide updates and user reviews for all segments in parallel
      const segmentsWithExtras = await Promise.all(
        segments.map(async (segment) => { 
          const [guideUpdate, userReviews] = await Promise.all([
            this.getGuideUpdateForSegment(segment.id, observationsSince),
            this.getUserReviewsForSegment(segment.id, 3, observationDays),
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
      hazards: HazardType[];
    }
  ): Promise<GuideUpdate> {
    // Declare outside try block for error logging
    let conditionsToCreate: Array<{
      id: string;
      snowType: string;
      secondarySnowType?: string;
      layer: 'SURFACE' | 'MIDDLE' | 'BASE';
    }> = [];

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
        },
        data: {
          status: 'ARCHIVED',
        },
      });

      // Prepare snow conditions to create
      // Strategy: Use SURFACE layer for first primary (with first secondary if exists)
      //           Use MIDDLE layer for second primary (with second secondary if exists)
      //           Use BASE layer if we have more secondary types than primary types
      conditionsToCreate = [];

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
      if (
        guideUpdateData.secondarySnowTypeIds.length >
        guideUpdateData.primarySnowTypeIds.length
      ) {
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
          ...(guideUpdateData.hazards.length > 0 && {
            hazards: guideUpdateData.hazards,
          }),
          snowConditions: {
            create: conditionsToCreate,
          },
        },
        include: {
          snowConditions: true,
        },
      } as any);

      // Return the guide update in the expected format
      return {
        description: newUpdate.description,
        primarySnowTypeIds: guideUpdateData.primarySnowTypeIds,
        secondarySnowTypeIds: guideUpdateData.secondarySnowTypeIds,
        hazards: guideUpdateData.hazards,
      };
    } catch (error) {
      console.error('Failed to create guide update:', error);
      console.error(
        'Conditions to create:',
        JSON.stringify(conditionsToCreate, null, 2)
      );
      console.error(
        'Guide update data:',
        JSON.stringify(guideUpdateData, null, 2)
      );
      if (error instanceof Error) {
        throw error;
      }
      throw new Error('Failed to create guide update');
    }
  }
}
