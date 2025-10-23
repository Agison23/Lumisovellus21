import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import segmentsRoutes from '../../api/routes/segments/segmentsRoutes';

// Create test app
const app = express();
app.use(express.json());
app.use('/', segmentsRoutes);

describe('Segments API Integration Tests', () => {
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
  });

  describe('GET /api/v1/segments', () => {
    it('should return all segments successfully', async () => {
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

      // Add coordinates
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
        ],
      });

      const response = await request(app).get('/api/v1/segments').expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: expect.arrayContaining([
          {
            id: segment1.id,
            name: 'Beginner Slope',
            terrain: 'Easy',
            avalancheDanger: false,
            isLowerSegment: 0,
            Points: [
              { lat: 65.0121, lng: 25.4651 },
              { lat: 65.0122, lng: 25.4652 },
            ],
          },
          {
            id: segment2.id,
            name: 'Advanced Slope',
            terrain: 'Difficult',
            avalancheDanger: true,
            isLowerSegment: 1,
            Points: [],
          },
        ]),
      });

      expect(response.body.data).toHaveLength(2);
    });

    it('should return empty array when no segments exist', async () => {
      const response = await request(app).get('/api/v1/segments').expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: [],
      });
    });

    it('should return segments with coordinates in correct order', async () => {
      const segment = await testPrisma.segment.create({
        data: {
          id: 'segment-coords',
          name: 'Coordinate Test',
          terrain: 'Medium',
          avalancheDanger: false,
        },
      });

      // Add coordinates in reverse order
      await testPrisma.coordinate.createMany({
        data: [
          {
            id: 'coord-2',
            segment: segment.id,
            order: 2,
            latitude: 65.0222,
            longitude: 25.4752,
          },
          {
            id: 'coord-1',
            segment: segment.id,
            order: 1,
            latitude: 65.0121,
            longitude: 25.4651,
          },
        ],
      });

      const response = await request(app).get('/api/v1/segments').expect(200);

      expect(response.body.data[0].Points).toEqual([
        { lat: 65.0121, lng: 25.4651 },
        { lat: 65.0222, lng: 25.4752 },
      ]);
    });
  });

  describe('GET /api/v1/segments/:id/updates', () => {
    beforeEach(async () => {
      // Create test user and segment
      await testPrisma.user.create({
        data: {
          id: 'test-user-updates',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@test.com',
          password: 'hashedpassword',
          role: 'NORMAL',
        },
      });

      await testPrisma.segment.create({
        data: {
          id: 'segment-updates',
          name: 'Updates Test Segment',
          terrain: 'Medium',
          avalancheDanger: false,
        },
      });

      await testPrisma.snowType.create({
        data: {
          id: 'powder-snow',
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
          creator: 'test-user-updates',
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
          snowType: 'powder-snow',
          layer: 'SURFACE',
          depth: 20.0,
          coverage: 80,
          quality: 4,
          hardness: 2,
          moisture: 1,
          notes: 'Excellent powder conditions',
        },
      });

      const response = await request(app)
        .get('/api/v1/segments/segment-updates/updates')
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveLength(1);

      const update = response.body.data[0];
      expect(update).toMatchObject({
        segment: 'segment-updates',
        description: 'Great conditions today',
        weather: 'Sunny',
        temperature: -5.0,
        windSpeed: 10.0,
        visibility: 5,
        status: 'ACTIVE',
        priority: 1,
      });

      expect(update.snowConditions).toHaveLength(1);
      expect(update.snowConditions[0]).toMatchObject({
        snowType: 'Powder',
        layer: 'SURFACE',
        depth: 20.0,
        coverage: 80,
        quality: 4,
        hardness: 2,
        moisture: 1,
        notes: 'Excellent powder conditions',
      });
    });

    it('should return empty array for segment with no updates', async () => {
      const response = await request(app)
        .get('/api/v1/segments/non-existent-segment/updates')
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: [],
      });
    });

    it('should return only the latest update', async () => {
      // Create multiple updates
      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-old',
            creator: 'test-user-updates',
            segment: 'segment-updates',
            time: new Date('2024-01-10T10:00:00Z'),
            description: 'Old update',
            status: 'ACTIVE',
          },
          {
            id: 'update-new',
            creator: 'test-user-updates',
            segment: 'segment-updates',
            time: new Date('2024-01-15T10:00:00Z'),
            description: 'New update',
            status: 'ACTIVE',
          },
        ],
      });

      const response = await request(app)
        .get('/api/v1/segments/segment-updates/updates')
        .expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].description).toBe('New update');
    });
  });

  describe('GET /api/v1/updates', () => {
    beforeEach(async () => {
      // Create test user and segments
      await testPrisma.user.create({
        data: {
          id: 'test-user-all-updates',
          firstName: 'All',
          lastName: 'Updates',
          email: 'all@test.com',
          password: 'hashedpassword',
          role: 'NORMAL',
        },
      });

      await testPrisma.segment.createMany({
        data: [
          {
            id: 'segment-all-1',
            name: 'Segment All 1',
            terrain: 'Easy',
            avalancheDanger: false,
          },
          {
            id: 'segment-all-2',
            name: 'Segment All 2',
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
            id: 'update-recent-all',
            creator: 'test-user-all-updates',
            segment: 'segment-all-1',
            time: twoDaysAgo,
            description: 'Recent update',
            status: 'ACTIVE',
          },
          {
            id: 'update-old-all',
            creator: 'test-user-all-updates',
            segment: 'segment-all-2',
            time: fourDaysAgo,
            description: 'Old update',
            status: 'ACTIVE',
          },
        ],
      });

      const response = await request(app).get('/api/v1/updates').expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].description).toBe('Recent update');
    });

    it('should return updates from custom number of days', async () => {
      const now = new Date();
      const fiveDaysAgo = new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000);

      await testPrisma.snowUpdate.create({
        data: {
          id: 'update-5-days-all',
          creator: 'test-user-all-updates',
          segment: 'segment-all-1',
          time: fiveDaysAgo,
          description: '5 days ago update',
          status: 'ACTIVE',
        },
      });

      const response = await request(app)
        .get('/api/v1/updates?days=7')
        .expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].description).toBe('5 days ago update');
    });

    it('should only return ACTIVE updates', async () => {
      const now = new Date();

      await testPrisma.snowUpdate.createMany({
        data: [
          {
            id: 'update-active-all',
            creator: 'test-user-all-updates',
            segment: 'segment-all-1',
            time: now,
            description: 'Active update',
            status: 'ACTIVE',
          },
          {
            id: 'update-draft-all',
            creator: 'test-user-all-updates',
            segment: 'segment-all-2',
            time: now,
            description: 'Draft update',
            status: 'DRAFT',
          },
        ],
      });

      const response = await request(app).get('/api/v1/updates').expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].status).toBe('ACTIVE');
    });

    it('should return empty array when no updates exist', async () => {
      const response = await request(app).get('/api/v1/updates').expect(200);

      expect(response.body.data).toEqual([]);
    });

    it('should include segment and creator information', async () => {
      const now = new Date();

      await testPrisma.snowUpdate.create({
        data: {
          id: 'update-with-info-all',
          creator: 'test-user-all-updates',
          segment: 'segment-all-1',
          time: now,
          description: 'Update with info',
          status: 'ACTIVE',
        },
      });

      const response = await request(app).get('/api/v1/updates').expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0]).toMatchObject({
        segment: 'segment-all-1',
        segmentName: 'Segment All 1',
        creator: {
          firstName: 'All',
          lastName: 'Updates',
        },
      });
    });

    it('should handle invalid days parameter gracefully', async () => {
      const response = await request(app)
        .get('/api/v1/updates?days=invalid')
        .expect(200);

      // Should default to 3 days
      expect(response.body.success).toBe(true);
    });

    it('should handle negative days parameter', async () => {
      const response = await request(app)
        .get('/api/v1/updates?days=-1')
        .expect(200);

      // Should default to 3 days
      expect(response.body.success).toBe(true);
    });
  });
});
