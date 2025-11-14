import 'zod-openapi';
import { z } from 'zod';

// Health validation
export const healthSchema = z.object({});

// Weather validation
const weatherDaysSchema = z
  .coerce.number()
  .int('Days must be an integer')
  .min(1, 'Days must be at least 1')
  .max(30, 'Days must be at most 30');

export const weatherItemSchema = z
  .enum(['temperature', 'windSpeed', 'windDirection', 'snowDepth'], {
    errorMap: () => ({
      message:
        'Invalid item. Allowed values: temperature, windSpeed, windDirection, snowDepth',
    }),
  })
  .meta({
    description: 'Weather item to aggregate',
    example: 'windSpeed',
  });

export const weatherAverageQuerySchema = z
  .object({
    item: z
      .enum(['windSpeed', 'windDirection'])
      .meta({ description: 'Weather item to average', example: 'windSpeed' }),
    days: weatherDaysSchema
      .default(3)
      .meta({ description: 'Number of days to include', example: 3 }),
  })
  .meta({ id: 'WeatherAverageQuery' });

export const weatherMinimumQuerySchema = z
  .object({
    item: z
      .literal('temperature')
      .meta({ description: 'Weather item to get minimum for', example: 'temperature' }),
    days: weatherDaysSchema
      .default(3)
      .meta({ description: 'Number of days to include', example: 3 }),
  })
  .meta({ id: 'WeatherMinimumQuery' });

export const weatherMaximumQuerySchema = z
  .object({
    item: z
      .enum(['temperature', 'windSpeed'])
      .meta({ description: 'Weather item to get maximum for', example: 'windSpeed' }),
    days: weatherDaysSchema
      .default(3)
      .meta({ description: 'Number of days to include', example: 3 }),
  })
  .meta({ id: 'WeatherMaximumQuery' });

export const weatherChangeQuerySchema = z
  .object({
    item: z
      .literal('snowDepth')
      .meta({ description: 'Weather item to calculate change for', example: 'snowDepth' }),
    days: weatherDaysSchema
      .default(7)
      .meta({ description: 'Number of days to look back from now', example: 7 }),
  })
  .meta({ id: 'WeatherChangeQuery' });

export const weatherFilterDaysQuerySchema = z
  .object({
    item: z
      .literal('temperature')
      .meta({ description: 'Weather item used for filtering', example: 'temperature' }),
    threshold: z.coerce
      .number()
      .meta({ description: 'Threshold to compare against', example: 0 }),
    days: weatherDaysSchema
      .default(3)
      .meta({ description: 'Number of days to include', example: 3 }),
  })
  .meta({ id: 'WeatherFilterDaysQuery' });

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

// Help event validation
export const helpNeedTypeSchema = z
  .enum(['health', 'equipment', 'lost'])
  .meta({ description: 'Type of help requested', example: 'health' });

export const helpEventLocationSchema = z
  .object({
    latitude: z.number().min(-90).max(90).meta({ description: 'Latitude', example: 65.0121 }),
    longitude: z.number().min(-180).max(180).meta({ description: 'Longitude', example: 25.4651 }),
    accuracy: z
      .number()
      .nonnegative()
      .nullable()
      .meta({ description: 'Location accuracy in meters', example: 25 })
      .optional(),
  })
  .meta({ id: 'HelpEventLocation' });

export const helpEventCreateSchema = z
  .object({
    timestamp: z
      .number()
      .int()
      .positive('Timestamp must be positive')
      .meta({ description: 'Unix timestamp', example: 1640995200 }),
    location: helpEventLocationSchema,
    needType: helpNeedTypeSchema,
    chatRoomId: z
      .string()
      .min(1, 'Chat room ID is required')
      .meta({ description: 'Chat room identifier', example: 'room123' }),
  })
  .meta({ id: 'HelpEventCreate' });

export const helpEventStatusSchema = z
  .enum(['active', 'completed', 'cancelled'])
  .meta({ description: 'Help event status', example: 'active' });

export const helpEventNearbyQuerySchema = z
  .object({
    lat: z.coerce
      .number()
      .min(-90)
      .max(90)
      .meta({ description: 'Latitude of requesting user', example: 65.0121 }),
    lng: z.coerce
      .number()
      .min(-180)
      .max(180)
      .meta({ description: 'Longitude of requesting user', example: 25.4651 }),
    accuracy: z.coerce
      .number()
      .int()
      .min(100)
      .max(20000)
      .optional()
      .meta({ description: 'Search radius in meters', example: 3000 }),
  })
  .meta({ id: 'HelpEventNearbyQuery' });

export const helpEventAcceptanceSchema = z
  .object({
    location: helpEventLocationSchema,
  })
  .meta({ id: 'HelpEventAcceptance' });

export const helpEventStatusUpdateSchema = z
  .object({
    status: helpEventStatusSchema,
  })
  .meta({ id: 'HelpEventStatusUpdate' });

export const userStatusSchema = z
  .object({
    location: helpEventLocationSchema,
    batteryLevel: z
      .number()
      .int()
      .min(0)
      .max(100)
      .nullable()
      .meta({ description: 'Battery level percentage', example: 85 }),
  })
  .meta({ id: 'HelpEventUserStatus' });

export const rescueeSchema = z
  .object({
    userId: z.string().meta({ description: 'Rescuee user ID' }),
    needType: helpNeedTypeSchema,
    userStatus: userStatusSchema,
  })
  .meta({ id: 'HelpEventRescuee' });

export const helpEventParticipationSchema = z
  .object({
    acceptanceId: z.string().meta({ description: 'Participation entry ID' }),
    eventId: z.string().meta({ description: 'Help event ID' }),
    responderId: z.string().meta({ description: 'Rescuer user ID' }),
    location: helpEventLocationSchema.nullable(),
    acceptedAt: z.string().datetime().meta({ description: 'Acceptance timestamp' }),
  })
  .meta({ id: 'HelpEventParticipation' });

export const helpEventSummarySchema = z
  .object({
    eventId: z.string(),
    status: helpEventStatusSchema,
    rescuee: rescueeSchema,
    location: helpEventLocationSchema,
    rescuerCount: z.number().int(),
    createdAt: z.string().datetime(),
  })
  .meta({ id: 'HelpEventSummary' });

export const helpEventRescueeViewSchema = helpEventSummarySchema
  .extend({
    acceptedRescuers: z.array(helpEventParticipationSchema),
    updatedAt: z.string().datetime().nullable(),
  })
  .meta({ id: 'HelpEventRescueeView' });

export const helpEventRescuerViewSchema = helpEventSummarySchema.meta({
  id: 'HelpEventRescuerView',
});

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
    minLat: z
      .string()
      .transform((val) => parseFloat(val))
      .pipe(z.number())
      .optional()
      .meta({ description: 'Minimum latitude of bounding box', example: '64.0' }),
    minLng: z
      .string()
      .transform((val) => parseFloat(val))
      .pipe(z.number())
      .optional()
      .meta({ description: 'Minimum longitude of bounding box', example: '25.0' }),
    maxLat: z
      .string()
      .transform((val) => parseFloat(val))
      .pipe(z.number())
      .optional()
      .meta({ description: 'Maximum latitude of bounding box', example: '66.0' }),
    maxLng: z
      .string()
      .transform((val) => parseFloat(val))
      .pipe(z.number())
      .optional()
      .meta({ description: 'Maximum longitude of bounding box', example: '30.0' }),
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

// Reviews query parameters
export const reviewsQuerySchema = z
  .object({
    days: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(30))
      .optional()
      .meta({ description: 'Number of days to look back for reviews and guide updates', example: '3' }),
    limit: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(10))
      .optional()
      .meta({ description: 'Maximum number of user reviews to return per segment', example: '3' }),
    page: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1))
      .optional()
      .meta({ description: 'Page number for paginated results (segments)', example: '1' }),
    pageSize: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(100))
      .optional()
      .meta({ description: 'Number of segments per page', example: '20' }),
  })
  .meta({ id: 'ReviewsQueryParams' });

export const segmentObservationQuerySchema = z
  .object({
    days: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(30))
      .optional()
      .meta({ description: 'Number of days to look back for this segment', example: '3' }),
    limit: z
      .string()
      .transform((val) => parseInt(val, 10))
      .pipe(z.number().int().min(1).max(10))
      .optional()
      .meta({ description: 'Maximum number of user reviews to include', example: '3' }),
  })
  .meta({ id: 'SegmentObservationQueryParams' });

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

// Segment Update Response schemas
const creatorSchema = z
  .object({
    firstName: z.string().nullable().meta({ description: 'Creator first name', example: 'John' }),
    lastName: z.string().nullable().meta({ description: 'Creator last name', example: 'Doe' }),
  })
  .nullable()
  .meta({ id: 'Creator' });

const snowConditionSchema = z
  .object({
    id: z.string().uuid().meta({ description: 'Snow condition ID', example: '550e8400-e29b-41d4-a716-446655440001' }),
    snowType: z.string().nullable().meta({ description: 'Primary snow type name', example: 'Powder' }),
    secondarySnowType: z.string().nullable().meta({ description: 'Secondary snow type name', example: 'Wet Snow' }),
    layer: z.enum(['SURFACE', 'MIDDLE', 'BASE']).meta({ description: 'Snow layer', example: 'SURFACE' }),
    depth: z.number().nullable().meta({ description: 'Snow depth in cm', example: 20.0 }),
    coverage: z.number().nullable().meta({ description: 'Snow coverage percentage', example: 80 }),
    quality: z.number().nullable().meta({ description: 'Snow quality rating', example: 4 }),
    hardness: z.number().nullable().meta({ description: 'Snow hardness rating', example: 2 }),
    moisture: z.number().nullable().meta({ description: 'Snow moisture rating', example: 1 }),
    notes: z.string().nullable().meta({ description: 'Additional notes', example: 'Excellent powder conditions' }),
    createdAt: z.string().datetime().meta({ description: 'Creation timestamp', example: '2024-01-15T10:30:00.000Z' }),
  })
  .meta({ id: 'SnowCondition' });

const reviewReferenceSchema = z
  .object({
    id: z.string().uuid().meta({ description: 'Review reference ID', example: '550e8400-e29b-41d4-a716-446655440001' }),
    updateId: z.string().uuid().meta({ description: 'Snow update ID', example: '550e8400-e29b-41d4-a716-446655440000' }),
    reviewId: z.string().meta({ description: 'User review ID', example: 'review-123' }),
    relevance: z.number().int().meta({ description: 'Relevance score', example: 1 }),
    notes: z.string().nullable().meta({ description: 'Reference notes' }),
    createdAt: z.string().datetime().meta({ description: 'Creation timestamp', example: '2024-01-15T10:30:00.000Z' }),
    reviewRel: z
      .object({
        id: z.string().meta({ description: 'Review ID' }),
        time: z.string().datetime().meta({ description: 'Review time' }),
        segment: z.string().uuid().meta({ description: 'Segment ID' }),
        snowType: z.string().uuid().nullable().meta({ description: 'Snow type ID' }),
        secondarySnowType: z.string().uuid().nullable().meta({ description: 'Secondary snow type ID' }),
        hazards: z.any().nullable().meta({ description: 'Hazards (JSON)' }),
        comment: z.string().nullable().meta({ description: 'Review comment' }),
        userId: z.string().nullable().meta({ description: 'User ID' }),
        createdAt: z.string().datetime().meta({ description: 'Creation timestamp' }),
        updatedAt: z.string().datetime().meta({ description: 'Update timestamp' }),
      })
      .meta({ description: 'Associated user review' }),
  })
  .meta({ id: 'ReviewReference' });

export const segmentUpdateSchema = z
  .object({
    id: z.string().uuid().meta({ description: 'Update ID', example: '550e8400-e29b-41d4-a716-446655440000' }),
    segment: z.string().uuid().meta({ description: 'Segment ID', example: '550e8400-e29b-41d4-a716-446655440000' }),
    time: z.string().datetime().meta({ description: 'Update timestamp', example: '2024-01-15T10:30:00.000Z' }),
    description: z.string().nullable().meta({ description: 'Update description', example: 'Great conditions today' }),
    weather: z.string().nullable().meta({ description: 'Weather conditions', example: 'Sunny' }),
    temperature: z.number().nullable().meta({ description: 'Temperature in Celsius', example: -5.0 }),
    windSpeed: z.number().nullable().meta({ description: 'Wind speed', example: 10.0 }),
    visibility: z.number().nullable().meta({ description: 'Visibility rating', example: 5 }),
    status: z.enum(['DRAFT', 'ACTIVE', 'ARCHIVED', 'DELETED']).meta({ description: 'Update status', example: 'ACTIVE' }),
    priority: z.number().int().meta({ description: 'Update priority', example: 1 }),
    creator: creatorSchema.meta({ description: 'Update creator information' }),
    segmentName: z.string().meta({ description: 'Segment name', example: 'Test Segment' }),
    snowConditions: z.array(snowConditionSchema).meta({ description: 'Snow conditions for this update' }),
    reviewReferences: z.array(reviewReferenceSchema).meta({ description: 'Review references associated with this update' }),
  })
  .meta({ id: 'SegmentUpdate' });

const pointSchema = z.object({
  lat: z.number().meta({ description: 'Latitude', example: 68.0309 }),
  lng: z.number().meta({ description: 'Longitude', example: 24.1142 }),
}).meta({ id: 'SegmentPoint' })

export const segmentSchema = z.object({
  id: z.string().uuid().meta({ description: 'Segment ID' }),
  name: z.string().meta({ description: 'Segment name' }),
  terrain: z.string().meta({ description: 'Terrain description' }),
  avalancheDanger: z.boolean(),
  isLowerSegment: z.string().nullable(),
  points: z.array(pointSchema).min(1).meta({ description: 'Polygon or polyline of the segment' }),
  guideUpdate: guideUpdateSchema.nullable(),
  userReviews: z.array(
    z.object({
      submittedAt: z.string().datetime(),
      snowTypeId: z.string().uuid(),
      secondarySnowTypeId: z.string().uuid().nullable(),
      hazards: z.array(z.string()),
    }).meta({ id: 'SegmentUserReview' })
  ),
}).meta({ id: 'Segment' })

export const segmentsSchema = z.array(segmentSchema)