import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { ApiResponseHandler } from './responseHandler';

export const errorHandler = (
  error: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  console.error('Unhandled error:', error);

  // Handle Zod validation errors
  if (error instanceof ZodError) {
    const details = error.errors.map((err) => ({
      field: err.path.join('.'),
      message: err.message,
      code: err.code,
    }));

    ApiResponseHandler.validationError(res, 'Validation failed', details);
    return;
  }

  // Handle Prisma errors
  if (error.name === 'PrismaClientKnownRequestError') {
    const prismaError = error as any;

    switch (prismaError.code) {
      case 'P2002':
        ApiResponseHandler.conflict(res, 'Resource already exists');
        return;
      case 'P2025':
        ApiResponseHandler.notFound(res, 'Resource not found');
        return;
      case 'P2003':
        ApiResponseHandler.validationError(
          res,
          'Invalid reference to related resource'
        );
        return;
      default:
        ApiResponseHandler.internalError(res, 'Database operation failed');
        return;
    }
  }

  // Handle other known errors
  if (error.name === 'JsonWebTokenError') {
    ApiResponseHandler.unauthorized(res, 'Invalid token');
    return;
  }

  if (error.name === 'TokenExpiredError') {
    ApiResponseHandler.unauthorized(res, 'Token expired');
    return;
  }

  // Handle custom errors with statusCode
  const customError = error as any;
  if (customError.statusCode) {
    const message =
      process.env.NODE_ENV !== 'production'
        ? error.message
        : 'An error occurred';

    switch (customError.statusCode) {
      case 400:
        ApiResponseHandler.validationError(res, message);
        return;
      case 401:
        ApiResponseHandler.unauthorized(res, message);
        return;
      case 403:
        ApiResponseHandler.forbidden(res, message);
        return;
      case 404:
        ApiResponseHandler.notFound(res, message);
        return;
      case 409:
        ApiResponseHandler.conflict(res, message);
        return;
      default:
        ApiResponseHandler.error(
          res,
          'ERROR',
          message,
          customError.statusCode
        );
        return;
    }
  }

  // Default error handling
  const message =
    process.env.NODE_ENV !== 'production'
      ? error.message
      : 'An unexpected error occurred';

  ApiResponseHandler.internalError(res, message);
};

export const notFoundHandler = (req: Request, res: Response): void => {
  ApiResponseHandler.notFound(
    res,
    `Endpoint ${req.method} ${req.path} not found`
  );
};

export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<any>
) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};
