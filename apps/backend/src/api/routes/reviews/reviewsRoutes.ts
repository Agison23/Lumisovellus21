import { Router } from 'express';
import { ReviewsController } from '../../controllers/reviews/ReviewsController';
import { reviewSchema, segmentIdSchema, querySchema } from '../../middleware/validation';

const router = Router();
const reviewsController = new ReviewsController();

/**
 * @swagger
 * /api/v1/snow-types:
 *   get:
 *     summary: Get all snow types
 *     description: Retrieve all available snow types for reviews
 *     tags: [Snow Types]
 *     responses:
 *       200:
 *         description: Snow types retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/api/v1/snow-types', reviewsController.getAllSnowTypes);

/**
 * @swagger
 * /api/v1/reviews:
 *   get:
 *     summary: Get latest reviews for all segments
 *     description: Retrieve the most recent reviews for all segments from the last 3 days
 *     tags: [Reviews]
 *     parameters:
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 30
 *           default: 3
 *         description: Number of days to look back for reviews
 *     responses:
 *       200:
 *         description: Reviews retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/api/v1/reviews', reviewsController.getLatestReviews);

/**
 * @swagger
 * /api/v1/reviews/all:
 *   get:
 *     summary: Get all reviews from last week
 *     description: Retrieve all reviews from the last week with segment and snow type information
 *     tags: [Reviews]
 *     parameters:
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 30
 *           default: 7
 *         description: Number of days to look back for reviews
 *     responses:
 *       200:
 *         description: All reviews retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 */
router.get('/api/v1/reviews/all', reviewsController.getAllReviews);

/**
 * @swagger
 * /api/v1/segments/{id}/reviews:
 *   post:
 *     summary: Create a review for a segment
 *     description: Submit a snow condition review for a specific segment
 *     tags: [Reviews]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Segment ID (UUID)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/definitions/ReviewRequest'
 *     responses:
 *       201:
 *         description: Review created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: object
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       400:
 *         description: Validation error
 *         schema:
 *           $ref: '#/definitions/Error'
 *       401:
 *         description: Unauthorized
 *         schema:
 *           $ref: '#/definitions/Error'
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.post('/api/v1/segments/:id/reviews', reviewsController.createReview);

export default router;
