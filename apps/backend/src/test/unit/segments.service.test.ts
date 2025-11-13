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

  describe('getSegmentUpdates', () => {
    beforeEach(async () => {
      // Create test user and segment
      await testPrisma.user.create({
        data: {
          id: 'test-user-1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@test.com',
          password: 'hashedpassword',
          role: 'NORMAL',
        },
      });

      await testPrisma.segment.create({
        data: {
          id: 'segment-updates',
          name: 'Test Segment',
          terrain: 'Medium',
          avalancheDanger: false,
        },
      });

      await testPrisma.snowType.create({
        data: {
          id: 'snow-type-1',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
        },
      });
    });

    it('should return latest updates for a segment', async () => {
      // Create snow update with recent date
      const now = new Date();
      const snowUpdate = await testPrisma.snowUpdate.create({
        data: {
          id: 'update-1',
          creator: 'test-user-1',
          segment: 'segment-updates',
          time: new Date(now.getTime() - 1 * 60 * 60 * 1000), // 1 hour ago
          description: 'Great conditions today',
          weather: 'Sunny',
          temperature: -5.0,
          windSpeed: 10.0,
          visibility: 5,
          status: 'ACTIVE',
          priority: 1,
        },
      });

      // Create snow condition
      await testPrisma.snowUpdateCondition.create({
        data: {
          id: 'condition-1',
          updateId: snowUpdate.id,
          snowType: 'snow-type-1',
          layer: 'SURFACE',
          depth: 20.0,
          coverage: 80,
          quality: 4,
          hardness: 2,
          moisture: 1,
          notes: 'Excellent powder conditions',
        },
      });

      const updates =
        await segmentsService.getSegmentUpdates('segment-updates');

      expect(updates).toHaveLength(1);
      expect(updates[0]).toMatchObject({
        segment: 'segment-updates',
        description: 'Great conditions today',
        weather: 'Sunny',
        temperature: -5.0,
        windSpeed: 10.0,
        visibility: 5,
        status: 'ACTIVE',
        priority: 1,
        snowConditions: [
          {
            snowType: 'Powder',
            secondarySnowType: null,
            layer: 'SURFACE',
            depth: 20.0,
            coverage: 80,
            quality: 4,
            hardness: 2,
            moisture: 1,
            notes: 'Excellent powder conditions',
          },
        ],
      });
    });

    it('should return updates with secondary snow type', async () => {
      // Create secondary snow type
      await testPrisma.snowType.create({
        data: {
          id: 'snow-type-2',
          name: 'Ice',
          colour: '#CCCCCC',
          skiability: 1,
        },
      });

      // Create snow update with recent date
      const now = new Date();
      const snowUpdate = await testPrisma.snowUpdate.create({
        data: {
          id: 'update-2',
          creator: 'test-user-1',
          segment: 'segment-updates',
          time: new Date(now.getTime() - 2 * 60 * 60 * 1000), // 2 hours ago
          description: 'Mixed conditions',
          weather: 'Cloudy',
          temperature: -2.0,
          windSpeed: 15.0,
          visibility: 3,
          status: 'ACTIVE',
          priority: 1,
        },
      });

      // Create snow condition with secondary snow type
      await testPrisma.snowUpdateCondition.create({
        data: {
          id: 'condition-2',
          updateId: snowUpdate.id,
          snowType: 'snow-type-1',
          secondarySnowType: 'snow-type-2',
          layer: 'SURFACE',
          depth: 15.0,
          coverage: 70,
          quality: 3,
          hardness: 3,
          moisture: 2,
          notes: 'Powder with ice patches',
        },
      });

      const updates =
        await segmentsService.getSegmentUpdates('segment-updates');

      expect(updates).toHaveLength(1);
      expect(updates[0].snowConditions[0]).toMatchObject({
        snowType: 'Powder',
        secondarySnowType: 'Ice',
        layer: 'SURFACE',
        depth: 15.0,
        coverage: 70,
        quality: 3,
        hardness: 3,
        moisture: 2,
        notes: 'Powder with ice patches',
      });
    });

    it('should return empty array for segment with no updates', async () => {
      const updates = await segmentsService.getSegmentUpdates(
        'non-existent-segment'
      );
      expect(updates).toEqual([]);
    });

    it('should return only the latest update when limit is 1', async () => {
      // Create multiple updates with recent dates
      const now = new Date();
      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-old',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 2 * 60 * 60 * 1000), // 2 hours ago
            description: 'Old update',
            status: 'ACTIVE',
          },
          {
            id: 'update-new',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 1 * 60 * 60 * 1000), // 1 hour ago
            description: 'New update',
            status: 'ACTIVE',
          },
        ],
      });

      const updates =
        await segmentsService.getSegmentUpdates('segment-updates', 1, 30);

      expect(updates).toHaveLength(1);
      expect(updates[0].description).toBe('New update');
    });

    it('should respect limit parameter', async () => {
      // Create multiple updates
      const now = new Date();
      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-1',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000), // 1 day ago
            description: 'Update 1',
            status: 'ACTIVE',
          },
          {
            id: 'update-2',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000), // 2 days ago
            description: 'Update 2',
            status: 'ACTIVE',
          },
          {
            id: 'update-3',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 3 * 24 * 60 * 60 * 1000), // 3 days ago
            description: 'Update 3',
            status: 'ACTIVE',
          },
        ],
      });

      const updates =
        await segmentsService.getSegmentUpdates('segment-updates', 2, 30);

      expect(updates).toHaveLength(2);
      expect(updates[0].description).toBe('Update 1');
      expect(updates[1].description).toBe('Update 2');
    });

    it('should respect days parameter', async () => {
      // Create updates with different dates
      const now = new Date();
      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-recent',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000), // 1 day ago
            description: 'Recent update',
            status: 'ACTIVE',
          },
          {
            id: 'update-old',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000), // 5 days ago
            description: 'Old update',
            status: 'ACTIVE',
          },
        ],
      });

      const updates =
        await segmentsService.getSegmentUpdates('segment-updates', 10, 3);

      expect(updates).toHaveLength(1);
      expect(updates[0].description).toBe('Recent update');
    });
  });

  describe('getAllUpdates', () => {
    beforeEach(async () => {
      // Create test user and segments
      await testPrisma.user.create({
        data: {
          id: 'test-user-2',
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'jane@test.com',
          password: 'hashedpassword',
          role: 'NORMAL',
        },
      });

      await testPrisma.segment.createMany({
        data: [
          {
            id: 'segment-1',
            name: 'Segment 1',
            terrain: 'Easy',
            avalancheDanger: false,
          },
          {
            id: 'segment-2',
            name: 'Segment 2',
            terrain: 'Difficult',
            avalancheDanger: true,
          },
        ],
      });
    });

    it('should return updates from the last 3 days by default', async () => {
      const now = new Date();
      const twoDaysAgo = new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000);
      const fourDaysAgo = new Date(now.getTime() - 4 * 24 * 60 * 60 * 1000);

      // Create updates - one recent, one old
      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-recent',
            creator: 'test-user-2',
            segment: 'segment-1',
            time: twoDaysAgo,
            description: 'Recent update',
            status: 'ACTIVE',
          },
          {
            id: 'update-old',
            creator: 'test-user-2',
            segment: 'segment-2',
            time: fourDaysAgo,
            description: 'Old update',
            status: 'ACTIVE',
          },
        ],
      });

      const updates = await segmentsService.getAllUpdates();

      expect(updates).toHaveLength(1);
      expect(updates[0].description).toBe('Recent update');
    });

    it('should return updates from custom number of days', async () => {
      const now = new Date();
      const fiveDaysAgo = new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000);

      await testPrisma.snowUpdate.create({
        data: {
          id: 'update-5-days',
          creator: 'test-user-2',
          segment: 'segment-1',
          time: fiveDaysAgo,
          description: '5 days ago update',
          status: 'ACTIVE',
        },
      });

      const updates = await segmentsService.getAllUpdates(7); // Look back 7 days

      expect(updates).toHaveLength(1);
      expect(updates[0].description).toBe('5 days ago update');
    });

    it('should only return ACTIVE updates', async () => {
      const now = new Date();

      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-active',
            creator: 'test-user-2',
            segment: 'segment-1',
            time: now,
            description: 'Active update',
            status: 'ACTIVE',
          },
          {
            id: 'update-draft',
            creator: 'test-user-2',
            segment: 'segment-2',
            time: now,
            description: 'Draft update',
            status: 'DRAFT',
          },
        ],
      });

      const updates = await segmentsService.getAllUpdates();

      expect(updates).toHaveLength(1);
      expect(updates[0].status).toBe('ACTIVE');
    });

    it('should return empty array when no updates exist', async () => {
      const updates = await segmentsService.getAllUpdates();
      expect(updates).toEqual([]);
    });

    it('should include segment and creator information', async () => {
      const now = new Date();

      await testPrisma.snowUpdate.create({
        data: {
          id: 'update-with-info',
          creator: 'test-user-2',
          segment: 'segment-1',
          time: now,
          description: 'Update with info',
          status: 'ACTIVE',
        },
      });

      const updates = await segmentsService.getAllUpdates();

      expect(updates).toHaveLength(1);
      expect(updates[0]).toMatchObject({
        segment: 'segment-1',
        segmentName: 'Segment 1',
        creator: {
          firstName: 'Jane',
          lastName: 'Smith',
        },
      });
    });
  });
});
