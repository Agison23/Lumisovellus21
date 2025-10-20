import { Router } from 'express';
import { UsersController } from '../../controllers/users/UsersController';
import { deviceIdSchema, locationUpdateSchema, batteryUpdateSchema, roleUpdateSchema } from '../../middleware/validation';

const router = Router();
const usersController = new UsersController();

/**
 * @swagger
 * /api/v1/users/{deviceId}/location:
 *   post:
 *     summary: Update mobile user location
 *     description: Update or create mobile user location data for tracking and rescue purposes
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: deviceId
 *         required: true
 *         schema:
 *           type: string
 *         description: Device ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/LocationUpdate'
 *     responses:
 *       200:
 *         description: Location updated successfully
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
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/api/v1/users/:deviceId/location', usersController.updateLocation);

/**
 * @swagger
 * /api/v1/users/{deviceId}/battery:
 *   post:
 *     summary: Update battery status
 *     description: Update the battery status for a mobile user
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: deviceId
 *         required: true
 *         schema:
 *           type: string
 *         description: Device ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               batteryStatus:
 *                 type: string
 *                 enum: [low, normal]
 *     responses:
 *       200:
 *         description: Battery status updated successfully
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
router.post('/api/v1/users/:deviceId/battery', usersController.updateBattery);

/**
 * @swagger
 * /api/v1/users/{deviceId}/role:
 *   post:
 *     summary: Update user role
 *     description: Update the role for a mobile user
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: deviceId
 *         required: true
 *         schema:
 *           type: string
 *         description: Device ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               role:
 *                 type: string
 *     responses:
 *       200:
 *         description: User role updated successfully
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
 *                     role:
 *                       type: string
 *                     permissions:
 *                       type: string
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 */
router.post('/api/v1/users/:deviceId/role', usersController.updateRole);

/**
 * @swagger
 * /api/v1/users/{deviceId}/role:
 *   get:
 *     summary: Get user role
 *     description: Retrieve the role and permissions for a mobile user
 *     tags: [Users]
 *     parameters:
 *       - in: path
 *         name: deviceId
 *         required: true
 *         schema:
 *           type: string
 *         description: Device ID
 *     responses:
 *       200:
 *         description: User role retrieved successfully
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
 *                     role:
 *                       type: string
 *                     permissions:
 *                       type: string
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */
router.get('/api/v1/users/:deviceId/role', usersController.getUserRole);

export default router;
