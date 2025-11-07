import 'zod-openapi';
import { z } from 'zod';

// Health validation
export const healthSchema = z.object({});

// Auth validation schemas
export const loginSchema = z
  .object({
    email: z
      .string()
      .email('Invalid email format')
      .meta({ description: 'User email address', example: 'user@example.com' }),
    password: z
      .string()
      .min(6, 'Password must be at least 6 characters')
      .meta({ description: 'User password', example: 'password123' }),
  })
  .meta({ id: 'LoginRequest' });

export const registerSchema = z
  .object({
    firstName: z
      .string()
      .min(1, 'First name is required')
      .meta({ description: 'User first name', example: 'John' }),
    lastName: z
      .string()
      .optional()
      .meta({ description: 'User last name', example: 'Doe' }),
    email: z
      .string()
      .email('Invalid email format')
      .meta({ description: 'User email address', example: 'user@example.com' }),
    password: z
      .string()
      .min(6, 'Password must be at least 6 characters')
      .meta({ description: 'User password', example: 'password123' }),
    role: z
      .enum(['NORMAL', 'ADMIN', 'RESCUE'])
      .optional()
      .meta({ description: 'User role', example: 'NORMAL' }),
  })
  .meta({ id: 'RegisterRequest' });

export const changePasswordSchema = z
  .object({
    currentPassword: z
      .string()
      .min(1, 'Current password is required')
      .meta({ description: 'Current password', example: 'oldpassword' }),
    newPassword: z
      .string()
      .min(6, 'New password must be at least 6 characters')
      .meta({ description: 'New password', example: 'newpassword123' }),
  })
  .meta({ id: 'ChangePasswordRequest' });

export const updateProfileSchema = z
  .object({
    firstName: z
      .string()
      .min(1, 'First name is required')
      .optional()
      .meta({ description: 'User first name', example: 'John' }),
    lastName: z
      .string()
      .optional()
      .meta({ description: 'User last name', example: 'Smith' }),
    email: z
      .string()
      .email('Invalid email format')
      .optional()
      .meta({ description: 'User email address', example: 'johnsmith@example.com' }),
    phoneNumber: z
      .string()
      .optional()
      .meta({ description: 'Phone number', example: '+1234567890' }),
  })
  .meta({ id: 'UpdateProfileRequest' });

export const refreshTokenSchema = z
  .object({
    refreshToken: z
      .string()
      .min(1, 'Refresh token is required')
      .meta({ description: 'Refresh token', example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' }),
  })
  .meta({ id: 'RefreshTokenRequest' });

export const resetPasswordSchema = z
  .object({
    email: z
      .string()
      .email('Invalid email format')
      .meta({ description: 'User email address', example: 'user@example.com' }),
  })
  .meta({ id: 'ResetPasswordRequest' });

// Segment validation
export const segmentIdSchema = z
  .object({
    id: z
      .string()
      .uuid('Invalid segment ID format')
      .meta({ description: 'Segment ID (UUID)', example: '550e8400-e29b-41d4-a716-446655440000' }),
  })
  .meta({ id: 'SegmentIdParams' });

// Review validation
const hazardSchema = z
  .enum(['stones', 'branches'], {
    errorMap: () => ({
      message: 'Invalid hazard type. Must be one of: stones, branches',
    }),
  })
  .meta({ description: 'Hazard type found on the trail', example: 'stones' });

export const reviewSchema = z
  .object({
    segment: z
      .string()
      .uuid('Invalid segment ID format')
      .meta({ description: 'Segment ID (UUID)', example: '550e8400-e29b-41d4-a716-446655440000' }),
    snowType: z
      .string()
      .uuid('Invalid snow type ID format')
      .meta({ description: 'Snow type ID (UUID)', example: '550e8400-e29b-41d4-a716-446655440001' }),
    hazards: z
      .array(hazardSchema)
      .default([])
      .meta({ description: 'Array of hazards found on the trail (e.g., ["stones", "branches"])', example: ['stones'] }),
    comment: z
      .string()
      .max(1000, 'Comment must be less than 1000 characters')
      .optional()
      .nullable()
      .meta({ description: 'Optional review comment', example: 'Good snow conditions' }),
  })
  .meta({ id: 'ReviewRequest' });

// User validation
export const deviceIdSchema = z
  .object({
    deviceId: z
      .string()
      .min(1, 'Device ID is required')
      .meta({ description: 'Device identifier', example: 'device123' }),
  })
  .meta({ id: 'DeviceIdParams' });

export const locationUpdateSchema = z
  .object({
    timestamp: z
      .number()
      .int()
      .positive('Timestamp must be positive')
      .meta({ description: 'Unix timestamp', example: 1640995200 }),
    firstName: z
      .string()
      .min(1, 'First name is required')
      .max(255)
      .meta({ description: 'User first name', example: 'John' }),
    lastName: z
      .string()
      .max(255)
      .optional()
      .meta({ description: 'User last name', example: 'Doe' }),
    gpsCoord: z
      .string()
      .min(1, 'GPS coordinates are required')
      .meta({ description: 'GPS coordinates (format: "lat,lng")', example: '65.0121,25.4651' }),
    phoneNumber: z
      .string()
      .max(20)
      .optional()
      .meta({ description: 'Phone number', example: '+358401234567' }),
  })
  .meta({ id: 'LocationUpdate' });

export const batteryUpdateSchema = z
  .object({
    batteryStatus: z
      .enum(['low', 'normal'], {
        errorMap: () => ({
          message: 'Battery status must be either "low" or "normal"',
        }),
      })
      .meta({ description: 'Battery status', example: 'normal' }),
  })
  .meta({ id: 'BatteryUpdate' });

export const roleUpdateSchema = z
  .object({
    role: z
      .string()
      .min(1, 'Role is required')
      .meta({ description: 'User role', example: 'NORMAL' }),
  })
  .meta({ id: 'RoleUpdate' });

// Help request validation
export const helpRequestSchema = z
  .object({
    timestamp: z
      .number()
      .int()
      .positive('Timestamp must be positive')
      .meta({ description: 'Unix timestamp', example: 1640995200 }),
    deviceId: z
      .string()
      .min(1, 'Device ID is required')
      .meta({ description: 'Device identifier', example: 'device123' }),
    gpsCoord: z
      .string()
      .min(1, 'GPS coordinates are required')
      .meta({ description: 'GPS coordinates (format: "lat,lng")', example: '65.0121,25.4651' }),
    helpType: z
      .enum(['seriousEmerg', 'help'], {
        errorMap: () => ({
          message: 'Help type must be either "seriousEmerg" or "help"',
        }),
      })
      .meta({ description: 'Type of help request', example: 'help' }),
    chatRoomId: z
      .string()
      .min(1, 'Chat room ID is required')
      .meta({ description: 'Chat room identifier', example: 'room123' }),
  })
  .meta({ id: 'HelpRequest' });

export const helpResponseSchema = z
  .object({
    helpGiver: z
      .string()
      .min(1, 'Help giver ID is required')
      .meta({ description: 'User ID of the person providing help', example: '550e8400-e29b-41d4-a716-446655440001' }),
    helpRequester: z
      .string()
      .min(1, 'Help requester ID is required')
      .meta({ description: 'User ID of the person requesting help', example: '550e8400-e29b-41d4-a716-446655440002' }),
    state: z
      .number()
      .int()
      .min(0)
      .max(3, 'State must be between 0 and 3')
      .meta({ description: 'Response state (0: Pending, 1: Accepted, 2: Declined, 3: Completed)', example: 0 }),
  })
  .meta({ id: 'HelpResponse' });

// Pagination validation
export const paginationSchema = z
  .object({
    page: z
      .number()
      .int()
      .min(1)
      .default(1)
      .meta({ description: 'Page number', example: 1 }),
    limit: z
      .number()
      .int()
      .min(1)
      .max(100)
      .default(20)
      .meta({ description: 'Items per page', example: 20 }),
  })
  .meta({ id: 'Pagination' });

// Query parameter validation
export const querySchema = z
  .object({
    page: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1))
      .optional()
      .meta({ description: 'Page number', example: '1' }),
    limit: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(100))
      .optional()
      .meta({ description: 'Items per page', example: '20' }),
    days: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(30))
      .optional()
      .meta({ description: 'Number of days to look back', example: '3' }),
  })
  .meta({ id: 'QueryParams' });

// Segment query parameters
export const segmentQuerySchema = z
  .object({
    bbox: z
      .string()
      .optional()
      .meta({ description: 'Bounding box to filter segments (format: "minLat,minLng,maxLat,maxLng")', example: '64.0,25.0,66.0,30.0' }),
    search: z
      .string()
      .optional()
      .meta({ description: 'Search term to filter segments by name', example: 'tunturi' }),
    updatedSince: z
      .string()
      .datetime()
      .optional()
      .meta({ description: 'Return only segments updated since this date (ISO 8601 format)', example: '2024-01-01T00:00:00Z' }),
  })
  .meta({ id: 'SegmentQueryParams' });

// Updates query parameters
export const segmentUpdatesQuerySchema = z
  .object({
    limit: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1))
      .optional()
      .meta({ description: 'Maximum number of updates to return', example: '3' }),
    days: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1))
      .optional()
      .meta({ description: 'Number of days to look back', example: '3' }),
  })
  .meta({ id: 'SegmentUpdatesQueryParams' });

export const updatesQuerySchema = z
  .object({
    days: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(30))
      .optional()
      .meta({ description: 'Number of days to look back (ignored if updatedSince/from/to provided)', example: '3' }),
    segmentId: z
      .string()
      .uuid()
      .optional()
      .meta({ description: 'Filter updates by a specific segment ID', example: '550e8400-e29b-41d4-a716-446655440000' }),
    updatedSince: z
      .string()
      .datetime()
      .optional()
      .meta({ description: 'Return updates since this timestamp (ISO 8601)', example: '2024-01-01T00:00:00Z' }),
    from: z
      .string()
      .datetime()
      .optional()
      .meta({ description: 'Start of time range (ISO 8601). If provided, overrides days/updatedSince.', example: '2024-01-01T00:00:00Z' }),
    to: z
      .string()
      .datetime()
      .optional()
      .meta({ description: 'End of time range (ISO 8601). If provided, overrides days/updatedSince.', example: '2024-01-31T23:59:59Z' }),
  })
  .meta({ id: 'UpdatesQueryParams' });

// Snow Type validation
export const createSnowTypeSchema = z
  .object({
    name: z
      .string()
      .min(1, 'Name is required')
      .max(50, 'Name must be less than 50 characters')
      .meta({ description: 'Snow type name', example: 'Powder' }),
    colour: z
      .string()
      .min(1, 'Colour is required')
      .max(15, 'Colour must be less than 15 characters')
      .regex(/^#?[0-9A-Fa-f]{6}$/, 'Colour must be a valid hex color (e.g., #FFFFFF or FFFFFF)')
      .meta({ description: 'Snow type colour in hex format', example: '#FFFFFF' }),
    skiability: z
      .number()
      .int()
      .min(1)
      .max(5)
      .optional()
      .nullable()
      .meta({ description: 'Skiability rating (1-5)' }),
    categoryId: z
      .number()
      .int()
      .optional()
      .nullable()
      .meta({ description: 'Category ID' }),
    explanation: z
      .string()
      .max(5000)
      .optional()
      .nullable()
      .meta({ description: 'Explanation of the snow type', example: 'Fresh powder snow' }),
  })
  .meta({ id: 'CreateSnowTypeRequest' });

export const snowTypeIdSchema = z
  .object({
    id: z
      .string()
      .uuid('Invalid snow type ID format')
      .meta({ description: 'Snow type ID (UUID)', example: '550e8400-e29b-41d4-a716-446655440000' }),
  })
  .meta({ id: 'SnowTypeIdParams' });

export const addSecondarySnowTypesSchema = z
  .object({
    secondarySnowTypeIds: z
      .array(z.string().uuid('Invalid snow type ID format'))
      .min(1, 'At least one secondary snow type ID is required')
      .meta({ description: 'Array of secondary snow type IDs', example: ['550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002'] }),
  })
  .meta({ id: 'AddSecondarySnowTypesRequest' });

// Guide Update validation
export const guideUpdateSchema = z
  .object({
    description: z
      .string()
      .nullable()
      .optional()
      .meta({ description: 'Description of the guide update', example: 'Excellent powder conditions' }),
    primarySnowTypeIds: z
      .array(z.string().uuid('Invalid snow type ID format'))
      .max(2, 'Maximum 2 primary snow types allowed')
      .default([])
      .meta({ description: 'Array of primary snow type IDs (max 2)', example: ['550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002'] }),
    secondarySnowTypeIds: z
      .array(z.string().uuid('Invalid snow type ID format'))
      .max(2, 'Maximum 2 secondary snow types allowed')
      .default([])
      .meta({ description: 'Array of secondary snow type IDs (max 2)', example: ['550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002'] }),
  })
  .meta({ id: 'GuideUpdateRequest' });

// Observation schemas
export const observationSchema = z
  .object({
    segmentId: z.string().uuid().meta({ description: 'Segment ID', example: '550e8400-e29b-41d4-a716-446655440000' }),
    guideUpdate: guideUpdateSchema.nullable().meta({ description: 'Guide update for the segment, if available' }),
    userReviews: z
      .array(
        z
          .object({
            submittedAt: z.string().datetime().meta({ description: 'When the review was submitted' }),
            snowTypeId: z.string().uuid().meta({ description: 'Snow type ID', example: '550e8400-e29b-41d4-a716-446655440001' }),
            hazards: z.array(z.string()).meta({ description: 'Array of hazards', example: ['stones', 'branches'] }),
          })
          .meta({ id: 'UserReviewObservation' })
      )
      .meta({ description: 'User reviews for the segment' }),
  })
  .meta({ id: 'Observation' });
