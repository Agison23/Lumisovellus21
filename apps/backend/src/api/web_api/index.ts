import express from 'express';
import { PrismaClient } from '@prisma/client';
import { z } from 'zod';

const router = express.Router();
const prisma = new PrismaClient();

// Validation schemas
const reviewSchema = z.object({
  segment: z.number().int().positive(),
  snowType: z.number().int().positive(),
  details: z.number().int().min(1).max(5),
  comment: z.string().max(1000),
});

// Test comment to trigger Swagger regeneration

// Extend Express Request type for authentication
declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string | null;
        firstName: string;
        lastName: string | null;
        role: string;
      };
    }
  }
}

// Authentication middleware (will be imported from shared)
const authenticateToken = async (req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  const JWT_SECRET = process.env.JWT_SECRET || 'Lumihiriv0';

  if (!token) {
    res.status(401).json({
      error: { code: 'UNAUTHORIZED', message: 'Access token required' }
    });
    return;
  }

  try {
    const jwt = await import('jsonwebtoken');
    const decoded = jwt.verify(token, JWT_SECRET) as any;
    const user = await prisma.user.findUnique({
      where: { id: decoded.id },
      select: { id: true, email: true, firstName: true, lastName: true, role: true }
    });

    if (!user) {
      res.status(401).json({
        error: { code: 'UNAUTHORIZED', message: 'Invalid token' }
      });
      return;
    }

    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({
      error: { code: 'UNAUTHORIZED', message: 'Invalid token' }
    });
    return;
  }
};


/**
 * @swagger
 * /web-api/v1/segments:
 *   get:
 *     summary: Get all segments
 *     description: Retrieve all ski segments with their coordinates and terrain information
 *     tags: [Web API - Segments]
 *     responses:
 *       200:
 *         description: Segments retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/definitions/Segment'
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/web-api/v1/segments', async (req, res) => {
  try {
    const segments = await prisma.segment.findMany({
      include: {
        coordinates: {
          orderBy: { order: 'asc' }
        },
      },
    });

    // Transform coordinates to match legacy format
    const transformedSegments = segments.map(segment => ({
      id: segment.id,
      name: segment.name,
      terrain: segment.terrain,
      avalancheDanger: segment.avalancheDanger,
      isLowerSegment: segment.isLowerSegment,
      Points: segment.coordinates.map(coord => ({
        lat: coord.latitude,
        lng: coord.longitude
      }))
    }));

    res.json({ data: transformedSegments });
  } catch (error) {
    console.error('Error fetching segments:', error);
    res.status(500).json({ 
      error: { 
        code: 'INTERNAL_SERVER_ERROR', 
        message: 'Failed to fetch segments' 
      } 
    });
  }
});

/**
 * @swagger
 * /web-api/v1/segments/{id}/updates:
 *   get:
 *     summary: Get latest updates for a segment
 *     description: Retrieve the most recent updates for a specific segment
 *     tags: [Web API - Updates]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Segment ID
 *     responses:
 *       200:
 *         description: Updates retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/web-api/v1/segments/:id/updates', async (req, res) => {
  try {
    const segmentId = parseInt(req.params.id);
    
    const updates = await prisma.update.findMany({
      where: { segment: segmentId },
      orderBy: { time: 'desc' },
      take: 1,
      include: {
        creatorRel: {
          select: { firstName: true, lastName: true }
        },
        primarySnowType: true,
        secondarySnowType: true,
        review1: true,
        review2: true,
        review3: true,
      }
    });

    res.json({ data: updates });
  } catch (error) {
    console.error('Error fetching segment updates:', error);
    res.status(500).json({ 
      error: { 
        code: 'INTERNAL_SERVER_ERROR', 
        message: 'Failed to fetch updates' 
      } 
    });
  }
});

/**
 * @swagger
 * /web-api/v1/updates:
 *   get:
 *     summary: Get latest updates for all segments
 *     description: Retrieve the most recent updates for all segments from the last 3 days
 *     tags: [Web API - Updates]
 *     responses:
 *       200:
 *         description: Updates retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/web-api/v1/updates', async (req, res) => {
  try {
    // Get latest updates for each segment from the last 3 days
    const threeDaysAgo = new Date();
    threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);

    const updates = await prisma.$queryRaw`
      SELECT P.segment, P.time, P.description, P.snowTypeId1, P.snowTypeId2, P.secondaryId1, P.secondaryId2,
        a1.time AS a1Time, a1.snowType AS a1SnowType, a1.details AS a1Details,
        a2.time AS a2Time, a2.snowType AS a2SnowType, a2.details AS a2Details,
        a3.time AS a3Time, a3.snowType AS a3SnowType, a3.details AS a3Details
      FROM updates P
      LEFT JOIN userReviews a1 ON P.reviewId1 = a1.id
      LEFT JOIN userReviews a2 ON P.reviewId2 = a2.id
      LEFT JOIN userReviews a3 ON P.reviewId3 = a3.id
      WHERE (P.segment, P.time) IN (
        SELECT segment, MAX(time)
        FROM updates
        GROUP BY segment
      )
      AND P.time > ${threeDaysAgo}
      ORDER BY P.segment
    `;

    res.json({ data: updates });
  } catch (error) {
    console.error('Error fetching updates:', error);
    res.status(500).json({ 
      error: { 
        code: 'INTERNAL_SERVER_ERROR', 
        message: 'Failed to fetch updates' 
      } 
    });
  }
});


/**
 * @swagger
 * /web-api/v1/reviews:
 *   get:
 *     summary: Get latest reviews for all segments
 *     description: Retrieve the most recent reviews for all segments from the last 3 days
 *     tags: [Web API - Reviews]
 *     responses:
 *       200:
 *         description: Reviews retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/web-api/v1/reviews', async (req, res) => {
  try {
    // Get latest reviews for each segment from the last 3 days
    const threeDaysAgo = new Date();
    threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);

    const reviews = await prisma.$queryRaw`
      SELECT id, time, segment, snowType, details, comment
      FROM userReviews
      WHERE (segment, time) IN (
        SELECT segment, MAX(time)
        FROM userReviews
        GROUP BY segment
      )
      AND time > ${threeDaysAgo}
      ORDER BY segment
    `;

    res.json({ data: reviews });
  } catch (error) {
    console.error('Error fetching reviews:', error);
    res.status(500).json({ 
      error: { 
        code: 'INTERNAL_SERVER_ERROR', 
        message: 'Failed to fetch reviews' 
      } 
    });
  }
});

/**
 * @swagger
 * /web-api/v1/allReviews:
 *   get:
 *     summary: Get all reviews from last week
 *     description: Retrieve all reviews from the last week with segment and snow type information
 *     tags: [Web API - Reviews]
 *     responses:
 *       200:
 *         description: All reviews retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Internal server error
 */
router.get('/web-api/v1/allReviews', async (req, res) => {
  try {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const reviews = await prisma.$queryRaw`
      SELECT userReviews.time, userReviews.details, userReviews.snowType, userReviews.comment, 
             snowTypes.name AS snow, segments.name AS segment
      FROM userReviews
      LEFT JOIN snowTypes ON userReviews.snowType = snowTypes.id
      LEFT JOIN segments ON userReviews.segment = segments.id
      WHERE time > ${oneWeekAgo}
      ORDER BY time DESC
    `;

    res.json({ data: reviews });
  } catch (error) {
    console.error('Error fetching all reviews:', error);
    res.status(500).json({ 
      error: { 
        code: 'INTERNAL_SERVER_ERROR', 
        message: 'Failed to fetch reviews' 
      } 
    });
  }
});


/**
 * @swagger
 * /web-api/v1/snow-types:
 *   get:
 *     summary: Get all snow types
 *     description: Retrieve all available snow types for reviews
 *     tags: [Web API - Reviews]
 *     responses:
 *       200:
 *         description: Snow types retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.get('/web-api/v1/snow-types', async (req, res) => {
  try {
    const snowTypes = await prisma.snowType.findMany();
    res.json({ data: snowTypes });
  } catch (error) {
    console.error('Error fetching snow types:', error);
    res.status(500).json({ 
      error: { 
        code: 'INTERNAL_SERVER_ERROR', 
        message: 'Failed to fetch snow types' 
      } 
    });
  }
});

/**
 * @swagger
 * /web-api/v1/segments/{id}/reviews:
 *   post:
 *     summary: Create a review for a segment
 *     description: Submit a snow condition review for a specific segment
 *     tags: [Web API - Reviews]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: Segment ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/definitions/ReviewRequest'
 *     responses:
 *       201:
 *         description: Review created successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 data:
 *                   type: object
 *       400:
 *         description: Validation error
 *         schema:
 *           $ref: '#/definitions/Error'
 *       401:
 *         description: Unauthorized
 *         schema:
 *           $ref: '#/definitions/Error'
 *       500:
 *         description: Internal server error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.post('/web-api/v1/segments/:id/reviews', authenticateToken, async (req, res): Promise<void> => {
  try {
    const segmentId = parseInt(req.params.id!);
    const reviewData = reviewSchema.parse(req.body);

    if (reviewData.segment !== segmentId) {
      res.status(400).json({
        error: { code: 'VALIDATION_ERROR', message: 'Segment ID mismatch' }
      });
      return;
    }

    const review = await prisma.userReview.create({
      data: {
        segment: reviewData.segment,
        snowType: reviewData.snowType,
        details: reviewData.details,
        comment: reviewData.comment,
        userId: req.user!.id,
        time: new Date(),
      },
      include: {
        segmentRel: true,
        snowTypeRel: true,
      }
    });

    res.status(201).json({ data: review });
  } catch (error) {
    console.error('Error creating review:', error);
    res.status(400).json({
      error: { code: 'VALIDATION_ERROR', message: 'Invalid review data' }
    });
  }
});

export default router;
