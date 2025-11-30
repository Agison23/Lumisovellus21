import { Router } from 'express';
import { HelpController } from '../../controllers/help/HelpController.js';
import { authenticateToken } from '../../middleware/auth.js';

const router = Router();
const helpController = new HelpController();

/**
 * @swagger
 * /help/events:
 *   post:
 *     summary: Create a new help event
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/HelpEventCreate'
 *     responses:
 *       201:
 *         description: Help event created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/HelpEventRescueeView'
 */
router.post('/help/events', authenticateToken, helpController.createHelpEvent);

/**
 * @swagger
 * /help/events/nearby:
 *   get:
 *     summary: List nearby active help events
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: query
 *         name: lat
 *         required: true
 *         schema:
 *           type: number
 *           format: double
 *       - in: query
 *         name: lng
 *         required: true
 *         schema:
 *           type: number
 *           format: double
 *       - in: query
 *         name: accuracy
 *         schema:
 *           type: integer
 *           default: 3000
 *           description: Search radius in meters
 *     responses:
 *       200:
 *         description: List of nearby help events
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/HelpEventSummary'
 */
router.get(
  '/help/events/nearby',
  authenticateToken,
  helpController.listNearbyHelpEvents
);

/**
 * @swagger
 * /help/events/{eventId}/view:
 *   get:
 *     summary: Get a help event view for the current user
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: eventId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Context-aware help event view
 *         content:
 *           application/json:
 *             schema:
 *               oneOf:
 *                 - $ref: '#/components/schemas/HelpEventRescueeView'
 *                 - $ref: '#/components/schemas/HelpEventRescuerView'
 *       403:
 *         description: User is not part of this event
 */
router.get(
  '/help/events/:eventId/view',
  authenticateToken,
  helpController.getHelpEventView
);

/**
 * @swagger
 * /help/events/{eventId}/acceptance:
 *   post:
 *     summary: Accept (join) a help event
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: eventId
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/HelpEventAcceptance'
 *     responses:
 *       200:
 *         description: Updated help event view for the rescuer
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/HelpEventRescuerView'
 */
router.post(
  '/help/events/:eventId/acceptance',
  authenticateToken,
  helpController.acceptHelpEvent
);

/**
 * @swagger
 * /help/events/{eventId}/acceptance:
 *   delete:
 *     summary: Withdraw from a help event
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: eventId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Updated help event view for the rescuer
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/HelpEventRescuerView'
 */
router.delete(
  '/help/events/:eventId/acceptance',
  authenticateToken,
  helpController.withdrawHelpEvent
);

/**
 * @swagger
 * /help/events/{eventId}:
 *   patch:
 *     summary: Update help event status
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: eventId
 *         required: true
 *         schema:
 *           type: string
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/HelpEventStatusUpdate'
 *     responses:
 *       200:
 *         description: Updated help event view for the rescuee
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/HelpEventRescueeView'
 */
router.patch(
  '/help/events/:eventId',
  authenticateToken,
  helpController.updateHelpEventStatus
);

/**
 * @swagger
 * /help/events/{eventId}/stream:
 *   get:
 *     summary: Subscribe to real-time help event updates
 *     tags: [Help Events]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: eventId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       501:
 *         description: Streaming not yet implemented
 */
router.get(
  '/help/events/:eventId/stream',
  authenticateToken,
  helpController.streamHelpEvent
);

export default router;
