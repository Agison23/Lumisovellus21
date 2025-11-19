import { describe, it, expect, beforeEach } from 'vitest';
import { SegmentsService } from '../../api/services/segments/SegmentsService';
import { testPrisma } from '../vitest.setup';

describe('SegmentsService Unit Tests', () => {
  let segmentsService: SegmentsService;

  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.snowUpdateReviewReference.deleteMany();
    await testPrisma.snowUpdateAttachment.deleteMany();
    await testPrisma.snowUpdateCondition.deleteMany();
    await testPrisma.snowUpdate.deleteMany();
    await testPrisma.userReview.deleteMany();
    await testPrisma.coordinate.deleteMany();
    await testPrisma.segment.deleteMany();
    await testPrisma.snowTypeSecondary.deleteMany();
    await testPrisma.snowType.deleteMany();
    await testPrisma.user.deleteMany();

    segmentsService = new SegmentsService();
  });

  describe('getAllSegments', () => {
    it('should return all segments with coordinates', async () => {
      // Create test segments with coordinates
      const segment1 = await testPrisma.segment.create({
        data: {
          id: 'segment-1',
          name: 'Beginner Slope',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const segment2 = await testPrisma.segment.create({
        data: {
          id: 'segment-2',
          name: 'Advanced Slope',
          terrain: 'Difficult',
          avalancheDanger: true,
          isLowerSegment: 1,
        },
      });

      // Add coordinates to segments
      await testPrisma.coordinate.createMany({
        data: [
          {
            id: 'coord-1',
            segment: segment1.id,
            order: 1,
            latitude: 65.0121,
            longitude: 25.4651,
          },
          {
            id: 'coord-2',
            segment: segment1.id,
            order: 2,
            latitude: 65.0122,
            longitude: 25.4652,
          },
          {
            id: 'coord-3',
            segment: segment2.id,
            order: 1,
            latitude: 65.0221,
            longitude: 25.4751,
          },
        ],
      });

      const segments = await segmentsService.getAllSegments();

      expect(segments).toHaveLength(2);
      expect(segments[0]).toMatchObject({
        id: segment1.id,
        name: 'Beginner Slope',
        terrain: 'Easy',
        avalancheDanger: false,
        isLowerSegment: 0,
        points: [
          { lat: 65.0121, lng: 25.4651 },
          { lat: 65.0122, lng: 25.4652 },
        ],
        guideUpdate: null,
        userReviews: [],
      });

      expect(segments[1]).toMatchObject({
        id: segment2.id,
        name: 'Advanced Slope',
        terrain: 'Difficult',
        avalancheDanger: true,
        isLowerSegment: 1,
        points: [{ lat: 65.0221, lng: 25.4751 }],
        guideUpdate: null,
        userReviews: [],
      });
    });

    it('should return empty array when no segments exist', async () => {
      const segments = await segmentsService.getAllSegments();
      expect(segments).toEqual([]);
    });

    it('should return segments without coordinates if none exist', async () => {
      await testPrisma.segment.create({
        data: {
          id: 'segment-no-coords',
          name: 'No Coordinates Slope',
          terrain: 'Medium',
          avalancheDanger: false,
        },
      });

      const segments = await segmentsService.getAllSegments();

      expect(segments).toHaveLength(1);
      expect(segments[0]).toMatchObject({
        id: 'segment-no-coords',
        name: 'No Coordinates Slope',
        terrain: 'Medium',
        avalancheDanger: false,
        points: [],
        guideUpdate: null,
        userReviews: [],
      });
    });

    it('should return segments with user reviews including secondary snow types', async () => {
      // Create test segment
      const segment = await testPrisma.segment.create({
        data: {
          id: 'segment-with-reviews',
          name: 'Reviews Segment',
          terrain: 'Medium',
          avalancheDanger: false,
        },
      });

      // Create snow types
      const primarySnowType = await testPrisma.snowType.create({
        data: {
          id: 'snow-primary-unit',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
        },
      });

      const secondarySnowType = await testPrisma.snowType.create({
        data: {
          id: 'snow-secondary-unit',
          name: 'Ice',
          colour: '#CCCCCC',
          skiability: 1,
        },
      });

      // Create test user
      const user = await testPrisma.user.create({
        data: {
          id: 'test-user-unit',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@test.com',
          role: 'NORMAL',
        },
      });

      // Create user reviews
      const now = new Date();
      await testPrisma.userReview.createMany({
        data: [
          {
            id: 'review-unit-1',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: secondarySnowType.id,
            hazards: ['stones'],
            userId: user.id,
            time: new Date(now.getTime() - 1 * 60 * 60 * 1000),
          },
          {
            id: 'review-unit-2',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: null,
            hazards: ['branches'],
            userId: user.id,
            time: new Date(now.getTime() - 2 * 60 * 60 * 1000),
          },
          {
            id: 'review-unit-3',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: secondarySnowType.id,
            hazards: ['stones', 'branches'],
            userId: user.id,
            time: new Date(now.getTime() - 3 * 60 * 60 * 1000),
          },
          {
            id: 'review-unit-4',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: null,
            hazards: [],
            userId: user.id,
            time: new Date(now.getTime() - 4 * 60 * 60 * 1000),
          },
        ],
      });

      const segments = await segmentsService.getAllSegments();

      expect(segments).toHaveLength(1);
      expect(segments[0].userReviews).toHaveLength(3); // Limited to 3

      // Check first review (newest)
      expect(segments[0].userReviews[0].snowTypeId).toBe(primarySnowType.id);
      expect(segments[0].userReviews[0].secondarySnowTypeId).toBe(secondarySnowType.id);
      expect(segments[0].userReviews[0].hazards).toEqual(['stones']);

      // Check second review
      expect(segments[0].userReviews[1].snowTypeId).toBe(primarySnowType.id);
      expect(segments[0].userReviews[1].secondarySnowTypeId).toBeNull();
      expect(segments[0].userReviews[1].hazards).toEqual(['branches']);

      // Check third review
      expect(segments[0].userReviews[2].snowTypeId).toBe(primarySnowType.id);
      expect(segments[0].userReviews[2].secondarySnowTypeId).toBe(secondarySnowType.id);
      expect(segments[0].userReviews[2].hazards).toEqual(['stones', 'branches']);
    });
  });


});
