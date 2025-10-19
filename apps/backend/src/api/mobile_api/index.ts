import express from 'express';
import { PrismaClient } from '@prisma/client';

const router = express.Router();
const prisma = new PrismaClient();

/**
 * @swagger
 * /mobile-api/v1/location:
 *   post:
 *     summary: Update mobile user location
 *     description: Update or create mobile user location data for tracking and rescue purposes
 *     tags: [Mobile]
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
 *                 status:
 *                   type: string
 *                   example: ok
 *       500:
 *         description revealed: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/mobile-api/v1/location', async (req, res) => {
  try {
    const { timestamp, devId, firstName, lastName, gpsCoord, phoneNumber } = req.body;
    const ipAddress = `${req.ip},${process.env.PORT || 3001}`;

    // Create or update user (mobile user)
    await prisma.user.upsert({
      where: { devId },
      update: { 
        ipAddress,
        updatedAt: new Date()
      },
      create: {
        devId,
        firstName,
        lastName,
        ipAddress,
        phoneNumber,
        role: 'NORMAL'
      }
    });

    // Create location data entry
    // Get user to get their UUID
    const user = await prisma.user.findUnique({
      where: { devId },
      select: { id: true }
    });

    if (!user) {
      res.status(404).json({ error: { code: 'USER_NOT_FOUND', message: 'User not found' } });
      return;
    }

    const parsedTimestamp = Number.isFinite(Number(timestamp))
      ? Number(timestamp)
      : Math.floor(Date.now() / 1000);

    await prisma.locationData.create({
      data: {
        timestamp: parsedTimestamp,
        gpsCoord,
        user: {
          connect: { id: user.id }
        }
      }
    });

    res.json({ status: 'ok' });
  } catch (error) {
    console.error('Error updating location:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to update location' }
    });
  }
});

/**
 * @swagger
 * /mobile-api/v1/help:
 *   post:
 *     summary: Create help request
 *     description: Create a help request for emergency or assistance
 *     tags: [Mobile]
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
 *                 status:
 *                   type: string
 *                   example: ok
 *                 nearbyUsers:
 *                   type: number
 *                   description: Number of nearby users found
 *       500:
 *         description: Internal server error
 */
router.post('/mobile-api/v1/help', async (req, res) => {
  try {
    const { timestamp, devId, gpsCoord, helpType, chatRoomId } = req.body;

    // Get user to get their UUID
    const user = await prisma.user.findUnique({
      where: { devId },
      select: { id: true }
    });

    if (!user) {
      res.status(404).json({ error: { code: 'USER_NOT_FOUND', message: 'User not found' } });
      return;
    }

    // Create or update help request
    await prisma.helpRequest.upsert({
      where: { userId: user.id },
      update: {
        timestamp: parseInt(timestamp),
        gpsCoord,
        helpType,
        roomId: chatRoomId,
        updatedAt: new Date()
      },
      create: {
        userId: user.id,
        timestamp: parseInt(timestamp),
        gpsCoord,
        helpType,
        roomId: chatRoomId,
      }
    });

    // Find nearby users (simplified version of the legacy logic)
    const maxDistance = helpType === 'seriousEmerg' ? 1 : 3;
    
    // Get recent users within time window
    const twoHoursAgo = Math.floor(Date.now() / 1000) - 7200;
    const nearbyUsers = await prisma.locationData.findMany({
      where: {
        timestamp: { gte: twoHoursAgo },
        userId: { not: user.id }
      },
      include: {
        user: true
      }
    });

    // Create nearby user entries for help coordination
    for (const nearbyUser of nearbyUsers) {
      try {
        await prisma.nearbyUser.create({
          data: {
            helpGiver: nearbyUser.userId,
            helpRequester: user.id,
            state: 0, // Pending
          }
        });
      } catch (error) {
        // Ignore duplicate entries
      }
    }

    res.json({ status: 'ok', nearbyUsers: nearbyUsers.length });
  } catch (error) {
    console.error('Error creating help request:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to create help request' }
    });
  }
});

/**
 * @swagger
 * /mobile-api/v1/help-requests:
 *   get:
 *     summary: Get help requests
 *     description: Retrieve all help requests for rescue interface
 *     tags: [Mobile]
 *     responses:
 *       200:
 *         description: Help requests retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/HelpRequest'
 *       500:
 *         description: Internal server error
 */
router.get('/mobile-api/v1/help-requests', async (req, res) => {
  try {
    const helpRequests = await prisma.helpRequest.findMany({
      include: {
        user: true,
        nearbyUsers: {
          include: {
            giver: true
          }
        }
      },
      orderBy: { timestamp: 'desc' }
    });

    res.json({ data: helpRequests });
  } catch (error) {
    console.error('Error fetching help requests:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to fetch help requests' }
    });
  }
});

/**
 * @swagger
 * /mobile-api/v1/help-response:
 *   post:
 *     summary: Update help response
 *     description: Update the response status for a help request
 *     tags: [Mobile]
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
 *       500:
 *         description: Internal server error
 */
router.post('/mobile-api/v1/help-response', async (req, res) => {
  try {
    const { helpGiver, helpRequester, state } = req.body;

    await prisma.nearbyUser.update({
      where: {
        helpGiver_helpRequester: {
          helpGiver,
          helpRequester
        }
      },
      data: { state: parseInt(state) }
    });

    res.json({ status: 'ok' });
  } catch (error) {
    console.error('Error updating help response:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to update help response' }
    });
  }
});

/**
 * @swagger
 * /mobile-api/v1/battery:
 *   post:
 *     summary: Update battery status
 *     description: Update the battery status for a mobile user
 *     tags: [Mobile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               devId:
 *                 type: string
 *               batteryStatus:
 *                 type: string
 *                 enum: [low, normal]
 *     responses:
 *       200:
 *         description: Battery status updated successfully
 *       500:
 *         description: Internal server error
 */
router.post('/mobile-api/v1/battery', async (req, res) => {
  try {
    const { devId, batteryStatus } = req.body;
    const lowBattery = batteryStatus === 'low' ? 1 : 0;

    await prisma.user.update({
      where: { devId },
      data: { lowBattery }
    });

    res.json({ status: 'ok' });
  } catch (error) {
    console.error('Error updating battery status:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to update battery status' }
    });
  }
});

/**
 * @swagger
 * /mobile-api/v1/role:
 *   post:
 *     summary: Update user role
 *     description: Update the role for a mobile user
 *     tags: [Mobile]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               devId:
 *                 type: string
 *               role:
 *                 type: string
 *     responses:
 *       200:
 *         description: User role updated successfully
 *       500:
 *         description: Internal server error
 */
router.post('/mobile-api/v1/role', async (req, res) => {
  try {
    const { devId, role } = req.body;

    const updatedUser = await prisma.user.update({
      where: { devId },
      data: { role: role as any } // Cast to UserRole enum
    });

    // Get role permissions
    const roleData = await prisma.role.findUnique({
      where: { name: role }
    });

    res.json({ 
      data: {
        role: updatedUser.role,
        permissions: roleData?.permissions || ''
      }
    });
  } catch (error) {
    console.error('Error updating user role:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to update user role' }
    });
  }
});

/**
 * @swagger
 * /mobile-api/v1/role/{devId}:
 *   get:
 *     summary: Get user role
 *     description: Retrieve the role and permissions for a mobile user
 *     tags: [Mobile]
 *     parameters:
 *       - in: path
 *         name: devId
 *         required: true
 *         schema:
 *           type: string
 *         description: Device ID
 *     responses:
 *       200:
 *         description: User role retrieved successfully
 *       404:
 *         description: User not found
 *       500:
 *         description: Internal server error
 */
router.get('/mobile-api/v1/role/:devId', async (req, res): Promise<void> => {
  try {
    const { devId } = req.params;

    const user = await prisma.user.findUnique({
      where: { devId }
    });

    if (!user) {
      res.status(404).json({
        error: { code: 'NOT_FOUND', message: 'User not found' }
      });
      return;
    }

    const roleData = await prisma.role.findUnique({
      where: { name: user.role.toLowerCase() }
    });

    res.json({
      data: {
        role: user.role.toLowerCase(),
        permissions: roleData?.permissions || ''
      }
    });
  } catch (error) {
    console.error('Error fetching user role:', error);
    res.status(500).json({
      error: { code: 'INTERNAL_SERVER_ERROR', message: 'Failed to fetch user role' }
    });
  }
});

export default router;
