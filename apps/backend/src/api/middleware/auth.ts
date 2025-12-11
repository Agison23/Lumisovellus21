import { Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
import { ApiResponseHandler } from './responseHandler.js';
import { AuthenticatedRequest } from '../types';

const prisma = new PrismaClient();

export interface JWTPayload {
  userId: string;
  email: string;
  role: string;
  iat?: number;
  exp?: number;
}

export const authenticateToken = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
      ApiResponseHandler.unauthorized(res, 'Access token required');
      return;
    }

    const jwtSecret = process.env.JWT_SECRET;
    if (!jwtSecret) {
      console.error('JWT_SECRET not configured');
      ApiResponseHandler.internalError(res, 'Server configuration error');
      return;
    }

    const decoded = jwt.verify(token, jwtSecret) as JWTPayload;

    // Verify user still exists and is active
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        role: true,
        password: false, // Don't include password in user object
      },
    });

    if (!user) {
      ApiResponseHandler.unauthorized(res, 'User not found');
      return;
    }

    // Add user info to request object
    req.user = {
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
    };

    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      ApiResponseHandler.unauthorized(res, 'Invalid token');
      return;
    }

    if (error instanceof jwt.TokenExpiredError) {
      ApiResponseHandler.unauthorized(res, 'Token expired');
      return;
    }

    console.error('Authentication error:', error);
    ApiResponseHandler.internalError(res, 'Authentication failed');
  }
};

export const requireRole = (allowedRoles: string[]) => {
  return (
    req: AuthenticatedRequest,
    res: Response,
    next: NextFunction
  ): void => {
    if (!req.user) {
      ApiResponseHandler.unauthorized(res, 'Authentication required');
      return;
    }

    if (!allowedRoles.includes(req.user.role)) {
      ApiResponseHandler.forbidden(res, 'Insufficient permissions');
      return;
    }

    next();
  };
};

export const requireAdmin = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): void => {
  if (!req.user) {
    ApiResponseHandler.unauthorized(res, 'Authentication required');
    return;
  }

  if (req.user.role !== 'ADMIN') {
    ApiResponseHandler.forbidden(res, 'Admin access required');
    return;
  }

  next();
};

export const optionalAuth = async (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      // No token provided, continue without authentication
      next();
      return;
    }

    const jwtSecret = process.env.JWT_SECRET;
    if (!jwtSecret) {
      next();
      return;
    }

    const decoded = jwt.verify(token, jwtSecret) as JWTPayload;

    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: {
        id: true,
        email: true,
        firstName: true,
        lastName: true,
        role: true,
      },
    });

    if (user) {
      req.user = {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      };
    }

    next();
  } catch (_error) {
    // If token is invalid, continue without authentication
    next();
  }
};
