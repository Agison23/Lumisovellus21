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

      // Create test snow type
      await testPrisma.snowType.create({
        data: {
          id: '1',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
          categoryId: 1,
          explanation: 'Fresh powder',
        },
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
            details: 4,
            comment: 'Great conditions',
            time: twoDaysAgo,
          },
          {
            id: 'review-2',
            segment: '2',
            snowType: null,
            details: 2,
            comment: 'Poor visibility',
            time: twoDaysAgo,
          },
          {
            id: 'review-3',
            segment: '1',
            snowType: '1',
            details: 5,
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

      expect(response.body.data).toHaveLength(2); // Only reviews from last 3 days
    });

    it('should use custom days parameter', async () => {
      const response = await request(app)
        .get('/api/v1/reviews?days=7')
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });

    it('should return empty array when no reviews exist', async () => {
      const response = await request(app).get('/api/v1/reviews').expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });
  });

  describe('GET /api/v1/reviews/all', () => {
    it('should return all reviews with snow type and segment names', async () => {
      // Create test data
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

      const now = new Date();
      const oneDayAgo = new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000);

      await testPrisma.userReview.create({
        data: {
          id: 'review-1',
          segment: '1',
          snowType: '1',
          details: 4,
          comment: 'Great conditions',
          time: oneDayAgo,
        },
      });

      const response = await request(app)
        .get('/api/v1/reviews/all')
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: expect.any(Array),
        meta: {
          timestamp: expect.any(String),
        },
      });

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0]).toMatchObject({
        time: oneDayAgo.toISOString(),
        details: 4,
        snowType: '1',
        comment: 'Great conditions',
        snow: 'Powder',
        segment: 'Test Segment',
      });
    });

    it('should use custom days parameter', async () => {
      const response = await request(app)
        .get('/api/v1/reviews/all?days=14')
        .expect(200);

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

      const reviewData = {
        snowType: '1',
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
          details: 3, // stones=1 + branches=2
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
      expect(createdReview?.details).toBe(3); // stones=1 + branches=2
      expect(createdReview?.comment).toBe('Great conditions today!');
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
      expect(response.body.data.details).toBeNull(); // Empty hazards array = null
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
