import { BaseService } from '../BaseService';
import { Segment, SegmentUpdate } from '../../types';

export interface SegmentQueryParams {
  bbox?: string; // Format: "minLat,minLng,maxLat,maxLng"
  search?: string;
  updatedSince?: string; // ISO 8601 date string
}

export class SegmentsService extends BaseService {
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
      const transformedSegments = segments
        .map((segment) => ({
          id: segment.id.toString(),
          name: segment.name,
          terrain: segment.terrain,
          avalancheDanger: segment.avalancheDanger,
          isLowerSegment: segment.isLowerSegment,
          Points: segment.coordinates.map((coord) => ({
            lat: coord.latitude,
            lng: coord.longitude,
          })),
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
            const withinBounds = segment.Points.some(
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

  async getSegmentUpdates(segmentId: string): Promise<SegmentUpdate[]> {
    try {
      const updates = await this.prisma.snowUpdate.findMany({
        where: { segment: segmentId },
        orderBy: { time: 'desc' },
        take: 1,
        include: {
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
      });

      return updates.map((update) => ({
        id: `${update.time.getTime()}-${update.segment}`,
        segment: update.segment,
        time: update.time,
        description: update.description || undefined,
        weather: update.weather,
        temperature: update.temperature,
        windSpeed: update.windSpeed,
        visibility: update.visibility,
        status: update.status,
        priority: update.priority,
        snowConditions: update.snowConditions.map((condition) => ({
          snowType: condition.snowTypeRel?.name,
          layer: condition.layer,
          depth: condition.depth,
          coverage: condition.coverage,
          quality: condition.quality,
          hardness: condition.hardness,
          moisture: condition.moisture,
          notes: condition.notes,
        })),
        reviewReferences: update.reviewReferences.map((ref) => ({
          reviewId: ref.reviewId,
          relevance: ref.relevance,
          notes: ref.notes,
          review: ref.reviewRel,
        })),
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
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
        snowConditions: update.snowConditions,
        reviewReferences: update.reviewReferences,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
