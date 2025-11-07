import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import reviewsRoutes from '../../api/routes/reviews/reviewsRoutes';
import jwt from 'jsonwebtoken';

// Create test app
const app = express();
app.use(express.json());
app.use('/', reviewsRoutes);

// Mock JWT secret for testing
const JWT_SECRET = 'test_jwt_secret_key_for_testing_only';

describe('Reviews API Integration Tests', () => {
  let authToken: string;
  let userId: string;

  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.userReview.deleteMany();
    await testPrisma.snowType.deleteMany();
    await testPrisma.segment.deleteMany();
    await testPrisma.user.deleteMany();

    // Create test user
    const user = await testPrisma.user.create({
      data: {
        id: 'test-user-123',
        devId: 'device-123',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        role: 'NORMAL',
      },
    });

    userId = user.id;

    // Generate JWT token
    authToken = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '1h' });
  });

  describe('GET /api/v1/snow-types', () => {
    it('should return all snow types successfully', async () => {
      // Create test snow types
      await testPrisma.snowType.createMany({
        data: [
          {
            id: '1',
            name: 'Powder',
            colour: '#FFFFFF',
            skiability: 5,
            categoryId: 1,
            explanation: 'Fresh powder snow',
          },
          {
            id: '2',
            name: 'Ice',
            colour: '#CCCCCC',
            skiability: 1,
            categoryId: 2,
            explanation: 'Hard ice surface',
          },
        ],
      });

      const response = await request(app).get('/api/v1/snow-types').expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: expect.any(Array),
        meta: {
          timestamp: expect.any(String),
        },
      });

      expect(response.body.data).toHaveLength(2);
      expect(response.body.data[0]).toEqual({
        id: '1',
        name: 'Powder',
        colour: '#FFFFFF',
        skiability: 5,
        categoryId: 1,
        explanation: 'Fresh powder snow',
      });
    });

    it('should return empty array when no snow types exist', async () => {
      const response = await request(app).get('/api/v1/snow-types').expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });
  });

  describe('GET /api/v1/reviews', () => {
    it('should return latest reviews successfully', async () => {
      // Create test segments
      await testPrisma.segment.createMany({
        data: [
          {
            id: '1',
            name: 'Test Segment 1',
            terrain: 'Easy',
            avalancheDanger: false,
            isLowerSegment: 0,
          },
          {
            id: '2',
            name: 'Test Segment 2',
            terrain: 'Difficult',
            avalancheDanger: true,
            isLowerSegment: 1,
          },
        ],
      });

      // Create test snow types
      await testPrisma.snowType.createMany({
        data: [
          {
            id: '1',
            name: 'Powder',
            colour: '#FFFFFF',
            skiability: 5,
            categoryId: 1,
            explanation: 'Fresh powder',
          },
          {
            id: '2',
            name: 'Ice',
            colour: '#CCCCCC',
            skiability: 1,
            categoryId: 2,
            explanation: 'Hard ice',
          },
        ],
      });

      // Create test reviews with different timestamps
      const now = new Date();
      const twoDaysAgo = new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000);
      const fourDaysAgo = new Date(now.getTime() - 4 * 24 * 60 * 60 * 1000);

      await testPrisma.userReview.createMany({
        data: [
          {
            id: 'review-1',
            segment: '1',
            snowType: '1',
            secondarySnowType: '2',
            hazards: ['stones', 'branches'],
            comment: 'Great conditions',
            time: twoDaysAgo,
          },
          {
            id: 'review-2',
            segment: '2',
            snowType: null,
            secondarySnowType: null,
            hazards: ['branches'],
            comment: 'Poor visibility',
            time: twoDaysAgo,
          },
          {
            id: 'review-3',
            segment: '1',
            snowType: '1',
            secondarySnowType: null,
            hazards: ['stones', 'branches'],
            comment: 'Excellent',
            time: fourDaysAgo,
          },
        ],
      });

      const response = await request(app).get('/api/v1/reviews').expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: expect.any(Array),
        meta: {
          timestamp: expect.any(String),
        },
      });

      // Should return observations grouped by segment
      expect(response.body.data.length).toBeGreaterThanOrEqual(1);
      
      // Check structure of first observation
      const observation = response.body.data[0];
      expect(observation).toHaveProperty('segmentId');
      expect(observation).toHaveProperty('guideUpdate');
      expect(observation).toHaveProperty('userReviews');
      expect(Array.isArray(observation.userReviews)).toBe(true);
      
      // Check user review structure
      if (observation.userReviews.length > 0) {
        const userReview = observation.userReviews[0];
        expect(userReview).toHaveProperty('submittedAt');
        expect(userReview).toHaveProperty('snowTypeId');
        expect(userReview).toHaveProperty('hazards');
        expect(Array.isArray(userReview.hazards)).toBe(true);
      }
    });

    it('should use custom days parameter', async () => {
      const response = await request(app)
        .get('/api/v1/reviews?days=7')
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it('should use custom limit parameter', async () => {
      // Create test data
      const segment = await testPrisma.segment.create({
        data: {
          id: 'limit-test-segment',
          name: 'Limit Test Segment',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const snowType = await testPrisma.snowType.create({
        data: {
          id: 'limit-test-snow',
          name: 'Test Snow',
          colour: '#FFFFFF',
          skiability: 5,
        },
      });

      const now = new Date();
      const oneDayAgo = new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000);

      // Create 5 reviews
      await testPrisma.userReview.createMany({
        data: [
          { id: 'r1', segment: segment.id, snowType: snowType.id, time: oneDayAgo },
          { id: 'r2', segment: segment.id, snowType: snowType.id, time: oneDayAgo },
          { id: 'r3', segment: segment.id, snowType: snowType.id, time: oneDayAgo },
          { id: 'r4', segment: segment.id, snowType: snowType.id, time: oneDayAgo },
          { id: 'r5', segment: segment.id, snowType: snowType.id, time: oneDayAgo },
        ],
      });

      const response = await request(app)
        .get('/api/v1/reviews?limit=2')
        .expect(200);

      expect(response.body.success).toBe(true);
      
      // Find the observation for our test segment
      const observation = response.body.data.find((obs: any) => obs.segmentId === segment.id);
      expect(observation).toBeDefined();
      // Should be limited to 2 reviews
      expect(observation.userReviews.length).toBeLessThanOrEqual(2);
    });

    it('should return empty array when no reviews exist', async () => {
      const response = await request(app).get('/api/v1/reviews').expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });
  });

  describe('POST /api/v1/segments/:id/reviews', () => {
    it('should create a review successfully', async () => {
      // Create test segment
      const segment = await testPrisma.segment.create({
        data: {
          id: '1',
          name: 'Test Segment',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const snowType = await testPrisma.snowType.create({
        data: {
          id: '1',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
          categoryId: 1,
          explanation: 'Fresh powder',
        },
      });

      // Create secondary snow type
      const secondarySnowType = await testPrisma.snowType.create({
        data: {
          id: '2',
          name: 'Ice',
          colour: '#CCCCCC',
          skiability: 1,
          categoryId: 2,
          explanation: 'Hard ice',
        },
      });

      const reviewData = {
        snowType: '1',
        secondarySnowType: '2',
        hazards: ['stones', 'branches'],
        comment: 'Great conditions today!',
      };

      const response = await request(app)
        .post('/api/v1/segments/1/reviews')
        .set('Authorization', `Bearer ${authToken}`)
        .send(reviewData)
        .expect(201);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          id: expect.any(String),
          time: expect.any(String),
          segment: '1',
          snowType: '1',
          hazards: ['stones', 'branches'],
          comment: 'Great conditions today!',
          userId: null,
        },
        meta: {
          timestamp: expect.any(String),
        },
      });

      // Verify review was created in database
      const createdReview = await testPrisma.userReview.findFirst({
        where: { segment: '1' },
      });

      expect(createdReview).toBeTruthy();
      expect(createdReview?.segment).toBe('1');
      expect(createdReview?.snowType).toBe('1');
      expect(createdReview?.secondarySnowType).toBe('2');
      expect(createdReview?.hazards).toEqual(['stones', 'branches']);
      expect(createdReview?.comment).toBe('Great conditions today!');
    });

    it('should create review with optional secondary snow type', async () => {
      const segment = await testPrisma.segment.create({
        data: {
          id: '2',
          name: 'Test Segment 2',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const primarySnowType = await testPrisma.snowType.create({
        data: {
          id: '3',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
          categoryId: 1,
          explanation: 'Fresh powder',
        },
      });

      const secondarySnowType = await testPrisma.snowType.create({
        data: {
          id: '4',
          name: 'Harsi',
          colour: '#F0F0F0',
          skiability: 4,
          categoryId: 2,
          explanation: 'Surface hoar',
        },
      });

      // Test with secondary snow type
      const reviewDataWithSecondary = {
        snowType: '3',
        secondarySnowType: '4',
        hazards: ['stones'],
        comment: 'Review with secondary snow type',
      };

      const response = await request(app)
        .post('/api/v1/segments/2/reviews')
        .set('Authorization', `Bearer ${authToken}`)
        .send(reviewDataWithSecondary)
        .expect(201);

      expect(response.body.success).toBe(true);
      const createdReview = await testPrisma.userReview.findFirst({
        where: { segment: '2' },
      });
      expect(createdReview?.snowType).toBe('3');
      expect(createdReview?.secondarySnowType).toBe('4');

      // Test without secondary snow type
      const reviewDataWithoutSecondary = {
        snowType: '3',
        hazards: ['branches'],
        comment: 'Review without secondary snow type',
      };

      await request(app)
        .post('/api/v1/segments/2/reviews')
        .set('Authorization', `Bearer ${authToken}`)
        .send(reviewDataWithoutSecondary)
        .expect(201);

      const reviewWithoutSecondary = await testPrisma.userReview.findMany({
        where: { segment: '2' },
        orderBy: { time: 'desc' },
      });

      expect(reviewWithoutSecondary[0].snowType).toBe('3');
      expect(reviewWithoutSecondary[0].secondarySnowType).toBeNull();
    });

    it('should create review with minimal data', async () => {
      const segment = await testPrisma.segment.create({
        data: {
          id: '1',
          name: 'Test Segment',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const reviewData = {
        snowType: null,
        hazards: [],
        comment: null,
      };

      const response = await request(app)
        .post('/api/v1/segments/1/reviews')
        .set('Authorization', `Bearer ${authToken}`)
        .send(reviewData)
        .expect(201);

      expect(response.body.success).toBe(true);
      expect(response.body.data.segment).toBe('1');
      expect(response.body.data.snowType).toBeUndefined();
      expect(response.body.data.hazards).toEqual([]); // Empty hazards array
      expect(response.body.data.comment).toBeNull();
    });

    // Removed test: "segment ID mismatch" - no longer applicable since segment comes from URL

    it('should return 401 without authentication', async () => {
      const reviewData = {
        snowType: '1',
        hazards: ['stones'],
        comment: 'Great conditions',
      };

      await request(app)
        .post('/api/v1/segments/1/reviews')
        .send(reviewData)
        .expect(401);
    });

    it('should return 401 with invalid token', async () => {
      const reviewData = {
        snowType: '1',
        hazards: ['stones'],
        comment: 'Great conditions',
      };

      await request(app)
        .post('/api/v1/segments/1/reviews')
        .set('Authorization', 'Bearer invalid-token')
        .send(reviewData)
        .expect(401);
    });
  });
});
