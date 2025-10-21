import { Router } from "express";
import { SegmentsController } from "../../controllers/segments/SegmentsController";

const router = Router();
const segmentsController = new SegmentsController();

/**
 * @swagger
 * /api/v1/segments:
 *   get:
 *     summary: Get all segments
 *     description: Retrieve all ski segments with their coordinates and terrain information
 *     tags: [Segments]
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
router.get("/api/v1/segments", segmentsController.getAllSegments);

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
  "/api/v1/segments/:id/updates",
  segmentsController.getSegmentUpdates,
);

/**
 * @swagger
 * /api/v1/updates:
 *   get:
 *     summary: Get latest updates for all segments
 *     description: Retrieve the most recent updates for all segments from the last 3 days
 *     tags: [Updates]
 *     parameters:
 *       - in: query
 *         name: days
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 30
 *           default: 3
 *         description: Number of days to look back for updates
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
router.get("/api/v1/updates", segmentsController.getAllUpdates);

export default router;
