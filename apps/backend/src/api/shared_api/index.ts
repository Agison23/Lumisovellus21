import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
import { z } from 'zod';

const router = express.Router();
const prisma = new PrismaClient();

const JWT_SECRET = process.env.JWT_SECRET || 'Lumihiriv0';
const SALT_ROUNDS = 15;

// Validation schemas
const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

// Extend Express Request type
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

/**
 * @swagger
 * /health:
 *   get:
 *     tags:
 *       - Health
 *     summary: Health check endpoint
 *     description: Returns the current status of the API server
 *     responses:
 *       200:
 *         description: Server is healthy
 *         schema:
 *           type: object
 *           properties:
 *             status:
 *               type: string
 *               example: ok
 *             timestamp:
 *               type: string
 *               example: "2024-01-15T10:30:00.000Z"
 *             version:
 *               type: string
 *               example: "2.0.0"
 */
router.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    version: '2.0.0'
  });
});

/**
 * @swagger
 * /api/v1/auth/login:
 *   post:
 *     tags:
 *       - Authentication
 *     summary: User login
 *     description: Authenticate user with email and password, returns JWT token for API access
 *     parameters:
 *       - in: body
 *         name: body
 *         description: Login credentials
 *         required: true
 *         schema:
 *           $ref: '#/definitions/LoginRequest'
 *         x-examples:
 *           application/json:
 *             email: user@example.com
 *             password: password123
 *     responses:
 *       200:
 *         description: Login successful
 *         schema:
 *           $ref: '#/definitions/LoginResponse'
 *       401:
 *         description: Invalid credentials
 *         schema:
 *           $ref: '#/definitions/Error'
 *       400:
 *         description: Validation error
 *         schema:
 *           $ref: '#/definitions/Error'
 */
router.post('/api/v1/auth/login', async (req, res): Promise<void> => {
  try {
    const { email, password } = loginSchema.parse(req.body);
    
    const user = await prisma.user.findUnique({
      where: { email }
    });

    if (!user || !user.password) {
      res.status(401).json({
        error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' }
      });
      return;
    }

    const isValidPassword = await bcrypt.compare(password, user.password);
    
    if (!isValidPassword) {
      res.status(401).json({
        error: { code: 'INVALID_CREDENTIALS', message: 'Invalid email or password' }
      });
      return;
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      JWT_SECRET,
      { algorithm: 'HS256', expiresIn: '24h' }
    );

    res.json({
      data: {
        token,
        user: {
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          role: user.role.toLowerCase(),
        },
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(400).json({
      error: { code: 'VALIDATION_ERROR', message: 'Invalid input data' }
    });
  }
});

// Authentication middleware
export const authenticateToken = async (req: express.Request, res: express.Response, next: express.NextFunction): Promise<void> => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    res.status(401).json({
      error: { code: 'UNAUTHORIZED', message: 'Access token required' }
    });
    return;
  }

  try {
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

export default router;
