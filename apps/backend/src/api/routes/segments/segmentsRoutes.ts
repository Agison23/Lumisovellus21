import { Router } from 'express';
import { SegmentsController } from '../../controllers/segments/SegmentsController';
import { authenticateToken, requireAdmin } from '../../middleware/auth';

const router = Router();
const segmentsController = new SegmentsController();

/**
 * @swagger
 * /api/v1/segments:
 *   get:
 *     summary: Get all segments
 *     description: Retrieve all ski segments with their coordinates and terrain information. Supports filtering by bounding box, search, and updatedSince.
 *     tags: [Segments]
 *     parameters:
 *       - in: query
 *         name: bbox
 *         schema:
 *           type: string
 *         description: Bounding box to filter segments (format: "minLat,minLng,maxLat,maxLng")
 *         example: "64.0,25.0,66.0,30.0"
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search term to filter segments by name
 *         example: "tunturi"
 *       - in: query
 *         name: updatedSince
 *         schema:
 *           type: string
 *           format: date-time
 *         description: Return only segments updated since this date (ISO 8601 format)
 *         example: "2024-01-01T00:00:00Z"
 *     responses:
 *       200:
 *         description: Segments retrieved successfully
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
 *                     $ref: '#/definitions/Segment'
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
router.get('/api/v1/segments', segmentsController.getAllSegments);

/**
 * @swagger
 * /api/v1/segments/{id}/updates:
 *   get:
 *     summary: Get latest updates for a segment
 *     description: Retrieve the most recent updates for a specific segment
 *     tags: [Segments]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Segment ID (UUID)
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 3
 *         description: Maximum number of updates to return
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 3
 *         description: Number of days to look back
 *     responses:
 *       200:
 *         description: Updates retrieved successfully
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
router.get(
  '/api/v1/segments/:id/updates',
  segmentsController.getSegmentUpdates
);

/**
 * @swagger
 * /api/v1/updates:
 *   get:
 *     summary: Get updates for segments
 *     description: Get updates filtered by updatedSince or time range; include review details.
 *     tags: [Updates]
 *     parameters:
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 30
 *           default: 3
 *         description: Number of days to look back (ignored if updatedSince/from/to provided)
 *       - in: query
 *         name: segmentId
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Filter updates by a specific segment ID
 *       - in: query
 *         name: updatedSince
 *         schema:
 *           type: string
 *           format: date-time
 *         description: Return updates since this timestamp (ISO 8601)
 *       - in: query
 *         name: from
 *         schema:
 *           type: string
 *           format: date-time
 *         description: Start of time range (ISO 8601). If provided, overrides days/updatedSince.
 *       - in: query
 *         name: to
 *         schema:
 *           type: string
 *           format: date-time
 *         description: End of time range (ISO 8601). If provided, overrides days/updatedSince.
 *     responses:
 *       200:
 *         description: Updates retrieved successfully, with review details included
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
router.get('/api/v1/updates', segmentsController.getAllUpdates);

/**
 * @swagger
 * /api/v1/segments/{id}/guideUpdate:
 *   post:
 *     summary: Create or update a guide update for a segment (Admin only)
 *     description: Creates a new guide update or updates the existing one for a segment. Only admins can create guide updates.
 *     tags: [Segments]
 *     security:
 *       - bearerAuth: []
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
 *             type: object
 *             required:
 *               - primarySnowTypeIds
 *               - secondarySnowTypeIds
 *             properties:
 *               description:
 *                 type: string
 *                 nullable: true
 *                 description: Description of the guide update
 *               primarySnowTypeIds:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: uuid
 *                 maxItems: 2
 *                 description: Array of primary snow type IDs (max 2)
 *                 example: ["uuid1", "uuid2"]
 *               secondarySnowTypeIds:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: uuid
 *                 maxItems: 2
 *                 description: Array of secondary snow type IDs (max 2)
 *                 example: ["uuid1", "uuid2"]
 *     responses:
 *       200:
 *         description: Guide update created/updated successfully
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
 *                   properties:
 *                     description:
 *                       type: string
 *                       nullable: true
 *                     primarySnowTypeIds:
 *                       type: array
 *                       items:
 *                         type: string
 *                     secondarySnowTypeIds:
 *                       type: array
 *                       items:
 *                         type: string
 *       401:
 *         description: Unauthorized - Authentication required
 *       403:
 *         description: Forbidden - Admin access required
 *       400:
 *         description: Bad request - Invalid input
 *       500:
 *         description: Internal server error
 */
router.post(
  '/api/v1/segments/:id/guideUpdate',
  authenticateToken,
  requireAdmin,
  segmentsController.createOrUpdateGuideUpdate
);

export default router;
