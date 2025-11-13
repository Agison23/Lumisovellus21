import { Router } from 'express';
import { SnowTypesController } from '../../controllers/snowTypes/SnowTypesController';
import { authenticateToken, requireAdmin } from '../../middleware/auth';

const router = Router();
const snowTypesController = new SnowTypesController();

/**
 * @swagger
 * /api/v1/snow-types:
 *   post:
 *     summary: Create a new snow type
 *     description: Create a new snow type with the provided information. Requires authentication and admin role.
 *     tags: [Snow Types]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateSnowTypeRequest'
 *     responses:
 *       201:
 *         description: Snow type created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   $ref: '#/components/schemas/SnowType'
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
 *       403:
 *         description: Forbidden - Admin role required
 *         schema:
 *           $ref: '#/definitions/Error'
 *       409:
 *         description: Snow type with this name already exists
 *         schema:
 *           $ref: '#/definitions/Error'
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.post(
  '/api/v1/snow-types',
  authenticateToken,
  requireAdmin,
  snowTypesController.createSnowType
);

/**
 * @swagger
 * /api/v1/snow-types/{id}/secondary:
 *   post:
 *     summary: Add secondary snow types to a snow type
 *     description: Associate one or more existing snow types as secondary types for the specified snow type. All entities are SnowTypes - "secondary" refers only to the relationship. Requires authentication and admin role.
 *     tags: [Snow Types]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Snow type ID (UUID) - the snow type that will have secondary types added
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/AddSecondarySnowTypesRequest'
 *     responses:
 *       200:
 *         description: Secondary snow types added successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   $ref: '#/components/schemas/SnowType'
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       400:
 *         description: Validation error or invalid request
 *         schema:
 *           $ref: '#/definitions/Error'
 *       401:
 *         description: Unauthorized
 *         schema:
 *           $ref: '#/definitions/Error'
 *       403:
 *         description: Forbidden - Admin role required
 *         schema:
 *           $ref: '#/definitions/Error'
 *       404:
 *         description: Snow type not found
 *         schema:
 *           $ref: '#/definitions/Error'
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.post(
  '/api/v1/snow-types/:id/secondary',
  authenticateToken,
  requireAdmin,
  snowTypesController.addSecondarySnowTypes
);

export default router;

