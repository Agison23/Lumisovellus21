import { z } from 'zod';

// Health validation
export const healthSchema = z.object({});

// Segment validation
export const segmentIdSchema = z.object({
  id: z.string().uuid('Invalid segment ID format')
});

// Review validation
export const reviewSchema = z.object({
  segment: z.string().uuid('Invalid segment ID format'),
  snowType: z.string().uuid('Invalid snow type ID format'),
  details: z.number().int().min(1).max(5, 'Details must be between 1 and 5'),
  comment: z.string().max(1000, 'Comment must be less than 1000 characters')
});

// User validation
export const deviceIdSchema = z.object({
  deviceId: z.string().min(1, 'Device ID is required')
});

export const locationUpdateSchema = z.object({
  timestamp: z.number().int().positive('Timestamp must be positive'),
  firstName: z.string().min(1, 'First name is required').max(255),
  lastName: z.string().max(255).optional(),
  gpsCoord: z.string().min(1, 'GPS coordinates are required'),
  phoneNumber: z.string().max(20).optional()
});

export const batteryUpdateSchema = z.object({
  batteryStatus: z.enum(['low', 'normal'], {
    errorMap: () => ({ message: 'Battery status must be either "low" or "normal"' })
  })
});

export const roleUpdateSchema = z.object({
  role: z.string().min(1, 'Role is required')
});

// Help request validation
export const helpRequestSchema = z.object({
  timestamp: z.number().int().positive('Timestamp must be positive'),
  deviceId: z.string().min(1, 'Device ID is required'),
  gpsCoord: z.string().min(1, 'GPS coordinates are required'),
  helpType: z.enum(['seriousEmerg', 'help'], {
    errorMap: () => ({ message: 'Help type must be either "seriousEmerg" or "help"' })
  }),
  chatRoomId: z.string().min(1, 'Chat room ID is required')
});

export const helpResponseSchema = z.object({
  helpGiver: z.string().min(1, 'Help giver ID is required'),
  helpRequester: z.string().min(1, 'Help requester ID is required'),
  state: z.number().int().min(0).max(3, 'State must be between 0 and 3')
});

// Pagination validation
export const paginationSchema = z.object({
  page: z.number().int().min(1).default(1),
  limit: z.number().int().min(1).max(100).default(20)
});

// Query parameter validation
export const querySchema = z.object({
  page: z.string().transform(val => parseInt(val, 10)).pipe(z.number().int().min(1)).optional(),
  limit: z.string().transform(val => parseInt(val, 10)).pipe(z.number().int().min(1).max(100)).optional(),
  days: z.string().transform(val => parseInt(val, 10)).pipe(z.number().int().min(1).max(30)).optional()
});
