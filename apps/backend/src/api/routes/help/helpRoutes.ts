import { Router } from 'express';
import { HelpController } from '../../controllers/help/HelpController';
import { authenticateToken, requireRole } from '../../middleware/auth';

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
router.post(
  '/api/v1/help-requests',
  authenticateToken,
  helpController.createHelpRequest
);

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
router.get(
  '/api/v1/help-requests',
  authenticateToken,
  helpController.getAllHelpRequests
);

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
router.post(
  '/api/v1/help-responses',
  authenticateToken,
  helpController.updateHelpResponse
);

/**
 * @swagger
 * /api/v1/help-requests/{id}/helpers:
 *   get:
 *     summary: Get users who can help with a specific help request
 *     description: Retrieve all users who have been notified about a help request with their status and distance
 *     tags: [Help Requests]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Help request ID
 *     responses:
 *       200:
 *         description: Help request helpers retrieved successfully
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
 *                       userId:
 *                         type: string
 *                       firstName:
 *                         type: string
 *                       lastName:
 *                         type: string
 *                       phoneNumber:
 *                         type: string
 *                       distance:
 *                         type: number
 *                         description: Distance in kilometers (-1 if no location data)
 *                       state:
 *                         type: integer
 *                         description: Response state (0: Pending, 1: Accepted, 2: Declined, 3: Completed)
 *                       lowBattery:
 *                         type: integer
 *                         description: Battery status (0: Normal, 1: Low)
 *                       lastSeen:
 *                         type: string
 *                         format: date-time
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       404:
 *         description: Help request not found
 *       500:
 *         description: Internal server error
 */
router.get(
  '/api/v1/help-requests/:id/helpers',
  authenticateToken,
  helpController.getHelpRequestHelpers
);

export default router;
