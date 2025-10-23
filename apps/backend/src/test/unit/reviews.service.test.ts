import { describe, it, expect, beforeEach } from 'vitest';
import { ReviewsService } from '../../api/services/reviews/ReviewsService';
import { testPrisma } from '../vitest.setup';

describe('ReviewsService Unit Tests', () => {
  let reviewsService: ReviewsService;

  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
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
    it('should return latest reviews within specified days', async () => {
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

      const result = await reviewsService.getLatestReviews(3);

      expect(result).toHaveLength(2); // Only reviews from last 3 days
      expect(result[0]).toMatchObject({
        id: 'review-1',
        segment: '1',
        snowType: '1',
        details: 4,
        comment: 'Great conditions',
      });
      expect(result[1]).toMatchObject({
        id: 'review-2',
        segment: '2',
        snowType: undefined,
        details: 2,
        comment: 'Poor visibility',
      });
    });

    it('should use default 3 days when no parameter provided', async () => {
      const result = await reviewsService.getLatestReviews();

      expect(result).toEqual([]);
    });
  });

  describe('getAllReviews', () => {
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

      const result = await reviewsService.getAllReviews(7);

      expect(result).toHaveLength(1);
      expect(result[0]).toMatchObject({
        time: oneDayAgo,
        details: 4,
        snowType: '1',
        comment: 'Great conditions',
        snow: 'Powder',
        segment: 'Test Segment',
      });
    });

    it('should return empty array when no reviews exist', async () => {
      const result = await reviewsService.getAllReviews(7);

      expect(result).toEqual([]);
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

      const reviewData = {
        segment: '1',
        snowType: '1',
        details: 4,
        comment: 'Great conditions today!',
      };

      const result = await reviewsService.createReview(reviewData, '1');

      expect(result).toMatchObject({
        segment: '1',
        snowType: '1',
        details: 4,
        comment: 'Great conditions today!',
        userId: null,
      });
      expect(result.id).toBeDefined();
      expect(result.time).toBeInstanceOf(Date);

      // Verify review was created in database
      const createdReview = await testPrisma.userReview.findUnique({
        where: { id: result.id },
      });

      expect(createdReview).toBeTruthy();
      expect(createdReview?.segment).toBe('1');
      expect(createdReview?.snowType).toBe('1');
      expect(createdReview?.details).toBe(4);
      expect(createdReview?.comment).toBe('Great conditions today!');
    });

    it('should throw error when segment ID mismatch', async () => {
      const reviewData = {
        segment: '1',
        snowType: 1,
        details: 4,
        comment: 'Test comment',
      };

      await expect(
        reviewsService.createReview(reviewData, '2')
      ).rejects.toThrow('Segment ID mismatch');
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

      const reviewData = {
        segment: '1',
        snowType: null,
        details: 3,
        comment: 'Average conditions',
      };

      const result = await reviewsService.createReview(reviewData, '1');

      expect(result.snowType).toBeUndefined();
      expect(result.details).toBe(3);
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

      const reviewData = {
        segment: '1',
        snowType: null,
        details: null,
        comment: null,
      };

      const result = await reviewsService.createReview(reviewData, '1');

      expect(result.segment).toBe('1');
      expect(result.snowType).toBeUndefined();
      expect(result.details).toBeNull();
      expect(result.comment).toBeNull();
    });
  });
});
