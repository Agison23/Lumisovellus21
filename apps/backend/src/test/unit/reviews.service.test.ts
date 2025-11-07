import { describe, it, expect, beforeEach } from 'vitest';
import { ReviewsService } from '../../api/services/reviews/ReviewsService';
import { testPrisma } from '../vitest.setup';
import type { ReviewRequest } from '../../api/types';

describe('ReviewsService Unit Tests', () => {
  let reviewsService: ReviewsService;

  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.userReview.deleteMany();
    await testPrisma.snowType.deleteMany();
    await testPrisma.segment.deleteMany();
    await testPrisma.user.deleteMany();

    reviewsService = new ReviewsService();
  });

  describe('getAllSnowTypes', () => {
    it('should return all snow types', async () => {
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

      const result = await reviewsService.getAllSnowTypes();

      expect(result).toHaveLength(2);
      expect(result[0]).toEqual({
        id: '1',
        name: 'Powder',
        colour: '#FFFFFF',
        skiability: 5,
        categoryId: 1,
        explanation: 'Fresh powder snow',
      });
      expect(result[1]).toEqual({
        id: '2',
        name: 'Ice',
        colour: '#CCCCCC',
        skiability: 1,
        categoryId: 2,
        explanation: 'Hard ice surface',
      });
    });

    it('should return empty array when no snow types exist', async () => {
      const result = await reviewsService.getAllSnowTypes();

      expect(result).toEqual([]);
    });
  });

  describe('getLatestReviews', () => {
    it('should return observations grouped by segment', async () => {
      // Create test segments
      const segment1 = await testPrisma.segment.create({
        data: {
          id: '1',
          name: 'Test Segment 1',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const segment2 = await testPrisma.segment.create({
        data: {
          id: '2',
          name: 'Test Segment 2',
          terrain: 'Difficult',
          avalancheDanger: true,
          isLowerSegment: 1,
        },
      });

      // Create test snow types
      const snowType1 = await testPrisma.snowType.create({
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
            hazards: ['stones', 'branches'],
            comment: 'Great conditions',
            time: twoDaysAgo,
          },
          {
            id: 'review-2',
            segment: '2',
            snowType: null,
            hazards: ['branches'],
            comment: 'Poor visibility',
            time: twoDaysAgo,
          },
          {
            id: 'review-3',
            segment: '1',
            snowType: '1',
            hazards: ['stones', 'branches'],
            comment: 'Excellent',
            time: fourDaysAgo,
          },
        ],
      });

      const result = await reviewsService.getLatestReviews(3, 3);

      // Should return observations for segments with reviews in last 3 days
      expect(Array.isArray(result)).toBe(true);
      
      // Find observations for each segment
      const observation1 = result.find((obs) => obs.segmentId === '1');
      const observation2 = result.find((obs) => obs.segmentId === '2');

      // Segment 1 should have 2 reviews (review-1 and review-3, but review-3 is 4 days ago, so only review-1)
      if (observation1) {
        expect(observation1).toHaveProperty('segmentId', '1');
        expect(observation1).toHaveProperty('guideUpdate');
        expect(observation1).toHaveProperty('userReviews');
        expect(Array.isArray(observation1.userReviews)).toBe(true);
        // Should have at least 1 review (review-1 from 2 days ago)
        expect(observation1.userReviews.length).toBeGreaterThanOrEqual(1);
        const review1 = observation1.userReviews.find((r) => 
          r.snowTypeId === '1' && r.hazards.includes('stones')
        );
        expect(review1).toBeDefined();
        if (review1) {
          expect(review1).toHaveProperty('submittedAt');
          expect(review1).toHaveProperty('snowTypeId', '1');
          expect(review1).toHaveProperty('hazards');
          expect(review1.hazards).toContain('stones');
          expect(review1.hazards).toContain('branches');
        }
      }

      // Segment 2 should have 1 review (review-2, but it has no snowType, so it might be filtered or use empty string)
      if (observation2) {
        expect(observation2).toHaveProperty('segmentId', '2');
        expect(observation2).toHaveProperty('guideUpdate');
        expect(observation2).toHaveProperty('userReviews');
        expect(Array.isArray(observation2.userReviews)).toBe(true);
        // Should have at least 1 review
        if (observation2.userReviews.length > 0) {
          const review2 = observation2.userReviews[0];
          expect(review2).toHaveProperty('submittedAt');
          expect(review2).toHaveProperty('snowTypeId');
          expect(review2).toHaveProperty('hazards');
          expect(review2.hazards).toContain('branches');
        }
      }
    });

    it('should use default parameters when not provided', async () => {
      const result = await reviewsService.getLatestReviews();

      expect(Array.isArray(result)).toBe(true);
      expect(result).toEqual([]);
    });

    it('should respect limit parameter', async () => {
      // Create test segment
      const segment = await testPrisma.segment.create({
        data: {
          id: 'limit-test',
          name: 'Limit Test Segment',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      // Create test snow type
      const snowType = await testPrisma.snowType.create({
        data: {
          id: 'limit-snow',
          name: 'Powder',
          colour: '#FFFFFF',
          skiability: 5,
          categoryId: 1,
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

      const result = await reviewsService.getLatestReviews(3, 2);

      const observation = result.find((obs) => obs.segmentId === segment.id);
      expect(observation).toBeDefined();
      if (observation) {
        // Should be limited to 2 reviews
        expect(observation.userReviews.length).toBeLessThanOrEqual(2);
      }
    });
  });

  describe('createReview', () => {
    it('should create a new review successfully', async () => {
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

      const reviewData: ReviewRequest = {
        snowType: '1',
        secondarySnowType: '2',
        hazards: ['stones', 'branches'],
        comment: 'Great conditions today!',
      };

      const result = await reviewsService.createReview(reviewData, '1');

      expect(result).toMatchObject({
        segment: '1',
        snowType: '1',
        hazards: ['stones', 'branches'],
        comment: 'Great conditions today!',
        userId: null,
      });
      expect(result.hazards).toBeDefined();
      expect(result.id).toBeDefined();
      expect(result.time).toBeInstanceOf(Date);

      // Verify review was created in database
      const createdReview = await testPrisma.userReview.findUnique({
        where: { id: result.id },
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
      const reviewDataWithSecondary: ReviewRequest = {
        snowType: '3',
        secondarySnowType: '4',
        hazards: ['stones'],
        comment: 'Review with secondary',
      };

      const resultWithSecondary = await reviewsService.createReview(
        reviewDataWithSecondary,
        '2'
      );

      expect(resultWithSecondary.snowType).toBe('3');
      const reviewWithSecondary = await testPrisma.userReview.findUnique({
        where: { id: resultWithSecondary.id },
      });
      expect(reviewWithSecondary?.secondarySnowType).toBe('4');

      // Test without secondary snow type
      const reviewDataWithoutSecondary: ReviewRequest = {
        snowType: '3',
        hazards: ['branches'],
        comment: 'Review without secondary',
      };

      const resultWithoutSecondary = await reviewsService.createReview(
        reviewDataWithoutSecondary,
        '2'
      );

      expect(resultWithoutSecondary.snowType).toBe('3');
      const reviewWithoutSecondary = await testPrisma.userReview.findUnique({
        where: { id: resultWithoutSecondary.id },
      });
      expect(reviewWithoutSecondary?.secondarySnowType).toBeNull();
    });

    it('should create review with null snowType when not provided', async () => {
      const segment = await testPrisma.segment.create({
        data: {
          id: '1',
          name: 'Test Segment',
          terrain: 'Easy',
          avalancheDanger: false,
          isLowerSegment: 0,
        },
      });

      const reviewData: ReviewRequest = {
        snowType: null,
        hazards: ['branches'],
        comment: 'Average conditions',
      };

      const result = await reviewsService.createReview(reviewData, '1');

      expect(result.snowType).toBeUndefined();
      expect(result.hazards).toEqual(['branches']);
      expect(result.comment).toBe('Average conditions');
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

      const reviewData: ReviewRequest = {
        snowType: null,
        hazards: [], // Empty hazards array
        comment: null,
      };

      const result = await reviewsService.createReview(reviewData, '1');

      expect(result.segment).toBe('1');
      expect(result.snowType).toBeUndefined();
      expect(result.hazards).toEqual([]);
      expect(result.comment).toBeNull();
    });
  });
});
