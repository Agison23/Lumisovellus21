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
            isLowerSegment: '0',
            points: [
              { lat: 65.0121, lng: 25.4651 },
              { lat: 65.0122, lng: 25.4652 },
            ],
            guideUpdate: null,
            userReviews: [],
          },
          {
            id: segment2.id,
            name: 'Advanced Slope',
            terrain: 'Difficult',
            avalancheDanger: true,
            isLowerSegment: '1',
            points: [],
            guideUpdate: null,
            userReviews: [],
          },
        ]),
      });

      expect(response.body.data).toHaveLength(2);
    });

    it('should return segments with user reviews including secondary snow types', async () => {
      // Create test segment
      const segment = await testPrisma.segment.create({
        data: {
          id: 'segment-reviews',
          name: 'Reviews Test Segment',
          terrain: 'Medium',
          avalancheDanger: false,
          isLowerSegment: null,
        },
      });

      // Create coordinates
      await testPrisma.coordinate.createMany({
        data: [
          {
            id: 'coord-review-1',
            segment: segment.id,
            order: 1,
            latitude: 65.0121,
            longitude: 25.4651,
          },
          {
            id: 'coord-review-2',
            segment: segment.id,
            order: 2,
            latitude: 65.0122,
            longitude: 25.4652,
          },
        ],
      });

      // Create snow types
      const primarySnowType = await testPrisma.snowType.create({
        data: {
          id: 'snow-primary',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
        },
      });

      const secondarySnowType = await testPrisma.snowType.create({
        data: {
          id: 'snow-secondary',
          name: 'Ice',
          colour: '#CCCCCC',
          skiability: 1,
        },
      });

      // Create test user
      const user = await testPrisma.user.create({
        data: {
          id: 'test-user-reviews',
          firstName: 'Test',
          lastName: 'User',
          email: 'test@test.com',
          role: 'NORMAL',
        },
      });

      // Create user reviews (5 total, but only 3 should be returned)
      const now = new Date();
      await testPrisma.userReview.createMany({
        data: [
          {
            id: 'review-1',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: secondarySnowType.id,
            hazards: ['stones'],
            comment: 'Review with secondary',
            userId: user.id,
            time: new Date(now.getTime() - 1 * 60 * 60 * 1000), // 1 hour ago
          },
          {
            id: 'review-2',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: null,
            hazards: ['branches'],
            comment: 'Review without secondary',
            userId: user.id,
            time: new Date(now.getTime() - 2 * 60 * 60 * 1000), // 2 hours ago
          },
          {
            id: 'review-3',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: secondarySnowType.id,
            hazards: ['stones', 'branches'],
            comment: 'Another review with secondary',
            userId: user.id,
            time: new Date(now.getTime() - 3 * 60 * 60 * 1000), // 3 hours ago
          },
          {
            id: 'review-4',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: null,
            hazards: [],
            comment: 'Fourth review',
            userId: user.id,
            time: new Date(now.getTime() - 4 * 60 * 60 * 1000), // 4 hours ago
          },
          {
            id: 'review-5',
            segment: segment.id,
            snowType: primarySnowType.id,
            secondarySnowType: secondarySnowType.id,
            hazards: ['stones'],
            comment: 'Fifth review',
            userId: user.id,
            time: new Date(now.getTime() - 5 * 60 * 60 * 1000), // 5 hours ago
          },
        ],
      });

      const response = await request(app).get('/api/v1/segments').expect(200);

      expect(response.body.success).toBe(true);
      const segmentData = response.body.data.find((s: any) => s.id === segment.id);
      expect(segmentData).toBeDefined();
      expect(segmentData.userReviews).toHaveLength(3); // Limited to 3

      // Check that reviews are sorted by time (newest first)
      expect(segmentData.userReviews[0].submittedAt).toBeDefined();
      expect(segmentData.userReviews[0].snowTypeId).toBe(primarySnowType.id);
      expect(segmentData.userReviews[0].secondarySnowTypeId).toBe(secondarySnowType.id);
      expect(segmentData.userReviews[0].hazards).toEqual(['stones']);

      expect(segmentData.userReviews[1].snowTypeId).toBe(primarySnowType.id);
      expect(segmentData.userReviews[1].secondarySnowTypeId).toBeNull();
      expect(segmentData.userReviews[1].hazards).toEqual(['branches']);

      expect(segmentData.userReviews[2].snowTypeId).toBe(primarySnowType.id);
      expect(segmentData.userReviews[2].secondarySnowTypeId).toBe(secondarySnowType.id);
      expect(segmentData.userReviews[2].hazards).toEqual(['stones', 'branches']);
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

      expect(response.body.data[0].points).toEqual([
        { lat: 65.0121, lng: 25.4651 },
        { lat: 65.0222, lng: 25.4752 },
      ]);
    });
  });


});
