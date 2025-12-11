import { Response } from 'express';

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    pagination?: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
    timestamp: string;
  };
}

export class ApiResponseHandler {
  static success<T>(
    res: Response,
    data: T,
    statusCode: number = 200,
    meta?: any
  ): void {
    const response: ApiResponse<T> = {
      success: true,
      data,
      meta: {
        ...meta,
        timestamp: new Date().toISOString(),
      },
    };
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
}
