import { Router } from 'express';
import { SnowTypesController } from '../../controllers/snowTypes/SnowTypesController';
import { authenticateToken, requireAdmin } from '../../middleware/auth';

const router = Router();
const snowTypesController = new SnowTypesController();

/**
 * @swagger
 * /api/v1/snow-types:
 *   get:
 *     summary: Get all snow types (primary and secondary)
 *     description: Retrieve all snow types including both primary and secondary snow types in a flat list.
 *     tags: [Snow Types]
 *     responses:
 *       200:
 *         description: Snow types retrieved successfully
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
 *                       name:
 *                         type: string
 *                       colour:
 *                         type: string
 *                       skiability:
 *                         type: integer
 *                         nullable: true
 *                       primarySnowTypeId:
 *                         type: string
 *                         nullable: true
 *                         format: uuid
 *                       explanation:
 *                         type: string
 *                         nullable: true
 *                 meta:
 *                   type: object
 *                   properties:
 *                     timestamp:
 *                       type: string
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
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
router.get('/api/v1/snow-types', snowTypesController.getAllSnowTypesFlat);
router.post(
  '/api/v1/snow-types',
  authenticateToken,
  requireAdmin,
  snowTypesController.createSnowType
);

/**
 * @swagger
 * /api/v1/snow-types/primary:
 *   get:
 *     summary: Get all primary snow types
 *     description: Retrieve all primary snow types (primarySnowTypeId: null) for reviews. Each primary snow type includes an array of its secondary snow types.
 *     tags: [Snow Types]
 *     responses:
 *       200:
 *         description: Snow types retrieved successfully
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
 *                       name:
 *                         type: string
 *                       colour:
 *                         type: string
 *                       skiability:
 *                         type: integer
 *                         nullable: true
 *                       primarySnowTypeId:
 *                         type: string
 *                         nullable: true
 *                         format: uuid
 *                       explanation:
 *                         type: string
 *                         nullable: true
 *                       secondaryTypes:
 *                         type: array
 *                         items:
 *                           type: object
 *                           description: Array of secondary snow types for this snow type
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
router.get('/api/v1/snow-types/primary', snowTypesController.getPrimarySnowTypes);

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

