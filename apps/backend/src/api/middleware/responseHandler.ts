import { Response } from 'express';
import { z } from 'zod';
import { ApiResponse } from '../types';
import { successResponseSchema } from '../openapi/schemas';

// Helper to recursively transform Date objects to ISO strings for validation
function transformDatesToISO(obj: any): any {
  if (obj === null || obj === undefined) {
    return obj;
  }
  if (obj instanceof Date) {
    return obj.toISOString();
  }
  if (Array.isArray(obj)) {
    return obj.map(transformDatesToISO);
  }
  if (typeof obj === 'object') {
    const transformed: any = {};
    for (const [key, value] of Object.entries(obj)) {
      transformed[key] = transformDatesToISO(value);
    }
    return transformed;
  }
  return obj;
}

export class ApiResponseHandler {
  static success<T>(
    res: Response,
    data: T,
    statusCode: number = 200,
    meta?: any,
    schema?: z.ZodTypeAny
  ): void {
    const response: ApiResponse<T> = {
      success: true,
      data,
      meta: {
        ...meta,
        timestamp: new Date().toISOString(),
      },
    };

    if (schema) {
      try {
        const responseSchema = successResponseSchema(schema);
        // Transform Date objects to ISO strings before validation
        const transformedResponse = transformDatesToISO(response);
        responseSchema.parse(transformedResponse);
      } catch (error) {
        if (error instanceof z.ZodError) {
          console.error('Response validation failed:', {
            path: res.req.path,
            method: res.req.method,
            errors: error.issues,
            data,
          });
          // In development, we might want to throw or log more aggressively
          // For now, just log the error but still send the response
          if (process.env.NODE_ENV === 'development') {
            console.warn('Response validation failed but sending response anyway');
          }
        }
      }
    }

    res.status(statusCode).json(response);
  }

  static error(
    res: Response,
    code: string,
    message: string,
    statusCode: number = 500,
    details?: any
  ): void {
    const response: ApiResponse = {
      success: false,
      error: {
        code,
        message,
        details,
      },
      meta: {
        timestamp: new Date().toISOString(),
      },
    };
    res.status(statusCode).json(response);
  }

  static notFound(res: Response, message: string = 'Resource not found'): void {
    this.error(res, 'NOT_FOUND', message, 404);
  }

  static validationError(res: Response, message: string, details?: any): void {
    this.error(res, 'VALIDATION_ERROR', message, 400, details);
  }

  static unauthorized(res: Response, message: string = 'Unauthorized'): void {
    this.error(res, 'UNAUTHORIZED', message, 401);
  }

  static forbidden(res: Response, message: string = 'Forbidden'): void {
    this.error(res, 'FORBIDDEN', message, 403);
  }

  static internalError(
    res: Response,
    message: string = 'Internal server error',
    details?: any
  ): void {
    this.error(res, 'INTERNAL_SERVER_ERROR', message, 500, details);
  }

  static conflict(
    res: Response,
    message: string = 'Resource already exists'
  ): void {
    this.error(res, 'CONFLICT', message, 409);
  }

  static tooManyRequests(
    res: Response,
    message: string = 'Too many requests'
  ): void {
    this.error(res, 'TOO_MANY_REQUESTS', message, 429);
  }
}
