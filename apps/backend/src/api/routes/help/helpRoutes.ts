import { Router } from 'express';
import { HelpController } from '../../controllers/help/HelpController';
import { helpRequestSchema, helpResponseSchema } from '../../middleware/validation';

const router = Router();
const helpController = new HelpController();

/**
 * @swagger
 * /api/v1/help-requests:
 *   post:
 *     summary: Create help request
 *     description: Create a help request for emergency or assistance
 *     tags: [Help Requests]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/HelpRequest'
 *     responses:
 *       200:
 *         description: Help request created successfully
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
 *                     status:
 *                       type: string
 *                       example: ok
 *                     nearbyUsers:
 *                       type: number
 *                       description: Number of nearby users found
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 */
router.post('/api/v1/help-requests', helpController.createHelpRequest);

/**
 * @swagger
 * /api/v1/help-requests:
 *   get:
 *     summary: Get help requests
 *     description: Retrieve all help requests for rescue interface
 *     tags: [Help Requests]
 *     responses:
 *       200:
 *         description: Help requests retrieved successfully
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
 *                     $ref: '#/components/schemas/HelpRequest'
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 */
router.get('/api/v1/help-requests', helpController.getAllHelpRequests);

/**
 * @swagger
 * /api/v1/help-responses:
 *   post:
 *     summary: Update help response
 *     description: Update the response status for a help request
 *     tags: [Help Requests]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               helpGiver:
 *                 type: string
 *               helpRequester:
 *                 type: string
 *               state:
 *                 type: integer
 *     responses:
 *       200:
 *         description: Help response updated successfully
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
 *                     status:
 *                       type: string
 *                       example: ok
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 */
router.post('/api/v1/help-responses', helpController.updateHelpResponse);

export default router;
