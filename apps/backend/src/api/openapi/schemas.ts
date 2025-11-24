import 'zod-openapi';
import { z } from 'zod';

// Common response wrapper schemas
export const successResponseSchema = <T extends z.ZodTypeAny>(dataSchema: T) =>
  z
    .object({
      success: z.boolean().meta({ description: 'Indicates if the request was successful', example: true }),
      data: dataSchema,
      meta: z
        .object({
          timestamp: z.string().datetime().meta({ description: 'Response timestamp', example: '2024-01-15T10:30:00.000Z' }),
          message: z.string().optional().meta({ description: 'Optional success message' }),
        })
        .passthrough()
        .meta({ description: 'Response metadata' }),
    });

export const errorResponseSchema = z
  .object({
    success: z.boolean().meta({ description: 'Indicates if the request was successful', example: false }),
    error: z
      .object({
        code: z.string().meta({ description: 'Error code', example: 'VALIDATION_ERROR' }),
        message: z.string().meta({ description: 'Error message', example: 'Validation failed' }),
        details: z.any().optional().meta({ description: 'Additional error details' }),
      })
      .meta({ description: 'Error information' }),
    meta: z
      .object({
        timestamp: z.string().datetime().meta({ description: 'Response timestamp', example: '2024-01-15T10:30:00.000Z' }),
      })
      .meta({ description: 'Response metadata' }),
  })
  .meta({ id: 'ErrorResponse' });

// Health response
export const healthResponseSchema = z
  .object({
    status: z.string().meta({ description: 'Server status', example: 'ok' }),
    version: z.string().meta({ description: 'API version', example: '2.0.0' }),
  })
  .meta({ id: 'HealthResponse' });

