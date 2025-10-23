import { describe, it, expect, beforeEach } from 'vitest';
import { SegmentsService } from '../../api/services/segments/SegmentsService';
import { testPrisma } from '../vitest.setup';

describe('SegmentsService Unit Tests', () => {
  let segmentsService: SegmentsService;

  beforeEach(async () => {
    // Clean up data before each test
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
        Points: [
          { lat: 65.0121, lng: 25.4651 },
          { lat: 65.0122, lng: 25.4652 },
        ],
      });

      expect(segments[1]).toMatchObject({
        id: segment2.id,
        name: 'Advanced Slope',
        terrain: 'Difficult',
        avalancheDanger: true,
        isLowerSegment: 1,
        Points: [{ lat: 65.0221, lng: 25.4751 }],
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
        Points: [],
      });
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
      // Create snow update
      const snowUpdate = await testPrisma.snowUpdate.create({
        data: {
          id: 'update-1',
          creator: 'test-user-1',
          segment: 'segment-updates',
          time: new Date('2024-01-15T10:00:00Z'),
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

    it('should return empty array for segment with no updates', async () => {
      const updates = await segmentsService.getSegmentUpdates(
        'non-existent-segment'
      );
      expect(updates).toEqual([]);
    });

    it('should return only the latest update', async () => {
      // Create multiple updates
      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-old',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date('2024-01-10T10:00:00Z'),
            description: 'Old update',
            status: 'ACTIVE',
          },
          {
            id: 'update-new',
            creator: 'test-user-1',
            segment: 'segment-updates',
            time: new Date('2024-01-15T10:00:00Z'),
            description: 'New update',
            status: 'ACTIVE',
          },
        ],
      });

      const updates =
        await segmentsService.getSegmentUpdates('segment-updates');

      expect(updates).toHaveLength(1);
      expect(updates[0].description).toBe('New update');
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
