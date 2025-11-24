import { Router } from 'express';
import { UsersController } from '../../controllers/users/UsersController';
import {
  authenticateToken,
  requireRole,
  requireAdmin,
} from '../../middleware/auth';

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
router.post(
  '/api/v1/users/:deviceId/location',
  authenticateToken,
  usersController.updateLocation
);

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
router.post(
  '/api/v1/users/:deviceId/battery',
  authenticateToken,
  usersController.updateBattery
);

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
router.post(
  '/api/v1/users/:deviceId/role',
  authenticateToken,
  requireRole(['ADMIN']),
  usersController.updateRole
);

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
router.get(
  '/api/v1/users/:deviceId/role',
  authenticateToken,
  usersController.getUserRole
);

/**
 * @swagger
 * /api/v1/users:
 *   get:
 *     summary: List all users
 *     description: Get a list of all users (admin only)
 *     tags: [Users]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: Users retrieved successfully
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
 *                       id:
 *                         type: string
 *                         example: "550e8400-e29b-41d4-a716-446655440001"
 *                       firstName:
 *                         type: string
 *                         example: "John"
 *                       lastName:
 *                         type: string
 *                         example: "Doe"
 *                       email:
 *                         type: string
 *                         example: "john@example.com"
 *                       role:
 *                         type: string
 *                         example: "NORMAL"
 *                       phoneNumber:
 *                         type: string
 *                         example: "+1234567890"
 *                       lowBattery:
 *                         type: number
 *                         example: 0
 *                       createdAt:
 *                         type: string
 *                         format: date-time
 *                       updatedAt:
 *                         type: string
 *                         format: date-time
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       401:
 *         description: Authentication required
 *       403:
 *         description: Admin access required
 */
router.get(
  '/api/v1/users',
  authenticateToken,
  requireAdmin,
  usersController.getAllUsers
);

/**
 * @swagger
 * /api/v1/users/me:
 *   get:
 *     summary: Get current user details
 *     description: Get details of the currently authenticated user
 *     tags: [Users]
 *     security:
 *       - BearerAuth: []
 *     responses:
 *       200:
 *         description: User details retrieved successfully
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
 *                     id:
 *                       type: string
 *                       example: "550e8400-e29b-41d4-a716-446655440001"
 *                     firstName:
 *                       type: string
 *                       example: "John"
 *                     lastName:
 *                       type: string
 *                       example: "Doe"
 *                     email:
 *                       type: string
 *                       example: "john@example.com"
 *                     role:
 *                       type: string
 *                       example: "NORMAL"
 *                     phoneNumber:
 *                       type: string
 *                       example: "+1234567890"
 *                     lowBattery:
 *                       type: number
 *                       example: 0
 *                     createdAt:
 *                       type: string
 *                       format: date-time
 *                     updatedAt:
 *                       type: string
 *                       format: date-time
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       401:
 *         description: Authentication required
 */
router.get(
  '/api/v1/users/me',
  authenticateToken,
  usersController.getCurrentUser
);

/**
 * @swagger
 * /api/v1/users/{id}:
 *   put:
 *     summary: Update a user
 *     description: Update user information (admin only)
 *     tags: [Users]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               firstName:
 *                 type: string
 *                 example: "John"
 *               lastName:
 *                 type: string
 *                 example: "Doe"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "john@example.com"
 *               role:
 *                 type: string
 *                 example: "NORMAL"
 *               phoneNumber:
 *                 type: string
 *                 example: "+1234567890"
 *     responses:
 *       200:
 *         description: User updated successfully
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
 *                     id:
 *                       type: string
 *                       example: "550e8400-e29b-41d4-a716-446655440001"
 *                     firstName:
 *                       type: string
 *                       example: "John"
 *                     lastName:
 *                       type: string
 *                       example: "Doe"
 *                     email:
 *                       type: string
 *                       example: "john@example.com"
 *                     role:
 *                       type: string
 *                       example: "NORMAL"
 *                     phoneNumber:
 *                       type: string
 *                       example: "+1234567890"
 *                     lowBattery:
 *                       type: number
 *                       example: 0
 *                     createdAt:
 *                       type: string
 *                       format: date-time
 *                     updatedAt:
 *                       type: string
 *                       format: date-time
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       401:
 *         description: Authentication required
 *       403:
 *         description: Admin access required
 *       404:
 *         description: User not found
 */
router.put(
  '/api/v1/users/:id',
  authenticateToken,
  requireAdmin,
  usersController.updateUser
);

/**
 * @swagger
 * /api/v1/users/{id}:
 *   delete:
 *     summary: Delete a user
 *     description: Delete a user and all related data (admin only)
 *     tags: [Users]
 *     security:
 *       - BearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: User deleted successfully
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
 *                     message:
 *                       type: string
 *                       example: "User deleted successfully"
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       401:
 *         description: Authentication required
 *       403:
 *         description: Admin access required
 *       404:
 *         description: User not found
 */
router.delete(
  '/api/v1/users/:id',
  authenticateToken,
  requireAdmin,
  usersController.deleteUser
);

export default router;
