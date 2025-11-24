import { Router } from 'express';
import { ReviewsController } from '../../controllers/reviews/ReviewsController';
import { authenticateToken } from '../../middleware/auth';

const router = Router();
const reviewsController = new ReviewsController();

/**
 * @swagger
 * /api/v1/observations:
 *   get:
 *     summary: Get observations for all segments
 *     description: Retrieve observations (reviews and guide updates) for all segments from the last N days, grouped by segment. Supports pagination of segments.
 *     tags: [Reviews]
 *     parameters:
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 30
 *           default: 3
 *         description: Number of days to look back for reviews and guide updates
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 10
 *           default: 3
 *         description: Maximum number of user reviews to return per segment
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number for paginated results (segments)
 *       - in: query
 *         name: pageSize
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *         description: Number of segments per page
 *     responses:
 *       200:
 *         description: Observations retrieved successfully
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
 *                     properties:
 *                       segmentId:
 *                         type: string
 *                         format: uuid
 *                       guideUpdate:
 *                         type: object
 *                         nullable: true
 *                         properties:
 *                           description:
 *                             type: string
 *                             nullable: true
 *                           primarySnowTypeIds:
 *                             type: array
 *                             items:
 *                               type: string
 *                               format: uuid
 *                             maxItems: 2
 *                           secondarySnowTypeIds:
 *                             type: array
 *                             items:
 *                               type: string
 *                               format: uuid
 *                             maxItems: 2
 *                       userReviews:
 *                         type: array
 *                         items:
 *                           type: object
 *                           properties:
 *                             submittedAt:
 *                               type: string
 *                               format: date-time
 *                             snowTypeId:
 *                               type: string
 *                               format: uuid
 *                             hazards:
 *                               type: array
 *                               items:
 *                                 type: string
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *                     pagination:
 *                       type: object
 *                       properties:
 *                         page:
 *                           type: integer
 *                         limit:
 *                           type: integer
 *                         total:
 *                           type: integer
 *                         totalPages:
 *                           type: integer
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/api/v1/observations', reviewsController.getLatestReviews);

/**
 * @swagger
 * /api/v1/segments/{id}/observations:
 *   get:
 *     summary: Get observations for a specific segment
 *     description: Retrieve guide updates and user reviews for a single segment within the requested time window.
 *     tags: [Reviews]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Segment ID (UUID)
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 30
 *           default: 3
 *         description: Number of days to look back for observations
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 10
 *           default: 3
 *         description: Maximum number of user reviews to include
 *     responses:
 *       200:
 *         description: Observations retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   $ref: '#/definitions/Observation'
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       404:
 *         description: No observations exist for the requested segment
 */
router.get(
  '/api/v1/segments/:id/observations',
  reviewsController.getSegmentObservations
);

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
router.post(
  '/api/v1/segments/:id/reviews',
  authenticateToken,
  reviewsController.createReview
);

export default router;
