import { BaseService } from '../BaseService';
import { Segment, SegmentUpdate } from '../../types';

export class SegmentsService extends BaseService {
  async getAllSegments(): Promise<Segment[]> {
    try {
      const segments = await this.prisma.segment.findMany({
        include: {
          coordinates: {
            orderBy: { order: 'asc' },
          },
        },
      });

      // Transform coordinates to match legacy format
      return segments.map((segment) => ({
        id: segment.id.toString(),
        name: segment.name,
        terrain: segment.terrain,
        avalancheDanger: segment.avalancheDanger,
        isLowerSegment: segment.isLowerSegment,
        Points: segment.coordinates.map((coord) => ({
          lat: coord.latitude,
          lng: coord.longitude,
        })),
      }));
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

  async getAllUpdates(days: number = 3): Promise<any[]> {
    try {
      console.log('DEBUG: prisma object:', typeof this.prisma);
      console.log(
        'DEBUG: snowUpdate property:',
        typeof this.prisma?.snowUpdate
      );
      console.log(
        'DEBUG: Available models:',
        Object.keys(this.prisma || {}).filter(
          (k) => !k.startsWith('_') && !k.startsWith('$')
        )
      );

      const daysAgo = new Date();
      daysAgo.setDate(daysAgo.getDate() - days);

      const updates = await this.prisma.snowUpdate.findMany({
        where: {
          time: { gte: daysAgo },
          status: 'ACTIVE',
        },
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
