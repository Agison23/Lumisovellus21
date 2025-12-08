import { Router } from 'express';
import { SegmentsController } from '../../controllers/segments/SegmentsController.js';
import {
  authenticateToken,
  requireAdmin,
  requireRole,
} from '../../middleware/auth.js';

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
 *         description: Bounding box to filter segments (OGC order: "minLng,minLat,maxLng,maxLat")
 *         example: "25.0,64.0,30.0,66.0"
 *       - in: query
 *         name: minLat
 *         schema:
 *           type: number
 *         description: Minimum latitude of bounding box
 *         example: 64.0
 *       - in: query
 *         name: minLng
 *         schema:
 *           type: number
 *         description: Minimum longitude of bounding box
 *         example: 25.0
 *       - in: query
 *         name: maxLat
 *         schema:
 *           type: number
 *         description: Maximum latitude of bounding box
 *         example: 66.0
 *       - in: query
 *         name: maxLng
 *         schema:
 *           type: number
 *         description: Maximum longitude of bounding box
 *         example: 30.0
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
 *               hazards:
 *                 type: array
 *                 items:
 *                   type: string
 *                   enum: [stones, branches]
 *                 description: Array of hazards found on the trail (e.g., ["stones", "branches"])
 *                 example: ["stones"]
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
 *                     hazards:
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
  requireRole(['ADMIN', 'GUIDE']),
  segmentsController.createOrUpdateGuideUpdate
);

export default router;
