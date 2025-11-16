import 'zod-openapi';
import { z } from 'zod';
import {
  loginSchema,
  registerSchema,
  changePasswordSchema,
  updateProfileSchema,
  refreshTokenSchema,
  resetPasswordSchema,
  segmentIdSchema,
  segmentQuerySchema,
  reviewSchema,
  deviceIdSchema,
  locationUpdateSchema,
  batteryUpdateSchema,
  roleUpdateSchema,
  helpEventCreateSchema,
  helpEventNearbyQuerySchema,
  helpEventAcceptanceSchema,
  helpEventStatusUpdateSchema,
  helpEventRescueeViewSchema,
  helpEventRescuerViewSchema,
  helpEventSummarySchema,
  querySchema,
  createSnowTypeSchema,
  snowTypeIdSchema,
  addSecondarySnowTypesSchema,
  guideUpdateSchema,
  observationSchema,
  reviewsQuerySchema,
  segmentObservationQuerySchema,
  weatherAverageQuerySchema,
  weatherMinimumQuerySchema,
  weatherMaximumQuerySchema,
  weatherChangeQuerySchema,
  weatherFilterDaysQuerySchema,
  segmentSchema,
  snowTypesSchema,
  snowTypeSchema,
  primarySnowTypeWithSecondariesSchema,
} from '../middleware/validation';
import { successResponseSchema, errorResponseSchema, healthResponseSchema } from './schemas';

// Helper to create success response
const createSuccessResponse = (dataSchema: z.ZodTypeAny, description: string) => ({
  description,
  content: {
    'application/json': {
      schema: successResponseSchema(dataSchema),
    },
  },
});

// Helper to create error responses
const createErrorResponses = () => ({
  '400': {
    description: 'Validation error',
    content: {
      'application/json': {
        schema: errorResponseSchema,
      },
    },
  },
  '401': {
    description: 'Unauthorized',
    content: {
      'application/json': {
        schema: errorResponseSchema,
      },
    },
  },
  '403': {
    description: 'Forbidden',
    content: {
      'application/json': {
        schema: errorResponseSchema,
      },
    },
  },
  '404': {
    description: 'Not found',
    content: {
      'application/json': {
        schema: errorResponseSchema,
      },
    },
  },
  '409': {
    description: 'Conflict',
    content: {
      'application/json': {
        schema: errorResponseSchema,
      },
    },
  },
  '500': {
    description: 'Internal server error',
    content: {
      'application/json': {
        schema: errorResponseSchema,
      },
    },
  },
});

// Auth response schema
const authResponseSchema = z
  .object({
    user: z
      .object({
        id: z.string().uuid(),
        firstName: z.string(),
        lastName: z.string().nullable(),
        email: z.string().nullable(),
        role: z.string(),
      })
      .meta({ description: 'User information' }),
    accessToken: z.string().meta({ description: 'JWT access token' }),
    refreshToken: z.string().meta({ description: 'JWT refresh token' }),
  })
  .meta({ id: 'AuthResponse' });

// User schema
const userSchema = z
  .object({
    id: z.string().uuid(),
    firstName: z.string(),
    lastName: z.string().nullable(),
    email: z.string().nullable(),
    role: z.string(),
    phoneNumber: z.string().nullable(),
    lowBattery: z.number(),
    createdAt: z.string().datetime(),
    updatedAt: z.string().datetime(),
  })
  .meta({ id: 'User' });

const helpEventIdParams = z
  .object({
    eventId: z
      .string()
      .meta({ description: 'Help event identifier', example: 'event_123' }),
  })
  .meta({ id: 'HelpEventIdParams' });

const weatherLocationSchema = z
  .object({
    name: z.string().meta({ description: 'Location name', example: 'Pallastunturi' }),
    latitude: z.number().meta({ description: 'Latitude in decimal degrees', example: 68.066 }),
    longitude: z.number().meta({ description: 'Longitude in decimal degrees', example: 24.133 }),
  })
  .meta({ id: 'WeatherLocation' });

const weatherPeriodSchema = z
  .object({
    start: z.string().datetime().meta({ description: 'Start of the look-back window' }),
    end: z.string().datetime().meta({ description: 'End of the look-back window (now)' }),
  })
  .meta({ id: 'WeatherPeriod' });

const weatherMetricSchema = z
  .object({
    type: z.enum(['average', 'minimum', 'maximum', 'change']).meta({ description: 'Metric type' }),
    item: z.string().meta({ description: 'Weather item', example: 'windSpeed' }),
    value: z.number().meta({ description: 'Calculated value for the metric' }),
    unit: z.string().meta({ description: 'Unit of measurement', example: 'metersPerSecond' }),
    days: z.number().int().meta({ description: 'Number of days included in the window' }),
    period: weatherPeriodSchema,
    location: weatherLocationSchema,
  })
  .meta({ id: 'WeatherMetric' });

const weatherFilterDaysResponseSchema = z
  .object({
    item: z.literal('temperature').meta({ description: 'Weather item used for filtering' }),
    threshold: z.number().meta({ description: 'Threshold for the average temperature' }),
    days: z.number().int().meta({ description: 'Number of days inspected' }),
    period: weatherPeriodSchema,
    location: weatherLocationSchema,
    matches: z
      .array(
        z.object({
          date: z.string().datetime().meta({ description: 'Date in ISO format' }),
          averageTemperature: z.number().meta({ description: 'Daily average temperature in Celsius' }),
        })
      )
      .meta({ description: 'Dates matching the filter' }),
  })
  .meta({ id: 'WeatherFilterDaysResponse' });

// OpenAPI routes definition
export const openApiRoutes = {
  // Health routes
  '/health': {
    get: {
      summary: 'Health check endpoint',
      description: 'Returns the current status of the API server',
      tags: ['Health'],
      responses: {
        '200': {
          description: 'Server is healthy',
          content: {
            'application/json': {
              schema: successResponseSchema(healthResponseSchema),
            },
          },
        },
      },
    },
  },

  // Auth routes
  '/auth/register': {
    post: {
      summary: 'Register a new user',
      description: 'Create a new user account with email and password',
      tags: ['Authentication'],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: registerSchema,
          },
        },
      },
      responses: {
        '201': createSuccessResponse(authResponseSchema, 'User registered successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/login': {
    post: {
      summary: 'Login user',
      description: 'Authenticate user with email and password',
      tags: ['Authentication'],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: loginSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(authResponseSchema, 'Login successful'),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/refresh-token': {
    post: {
      summary: 'Refresh access token',
      description: 'Get new access token using refresh token',
      tags: ['Authentication'],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: refreshTokenSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(authResponseSchema, 'Token refreshed successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/reset-password': {
    post: {
      summary: 'Request password reset',
      description: 'Send password reset email to user',
      tags: ['Authentication'],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: resetPasswordSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({ message: z.string() }),
          'Password reset email sent (if email exists)'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/logout': {
    post: {
      summary: 'Logout user',
      description: 'Logout the authenticated user',
      tags: ['Authentication'],
      security: [{ BearerAuth: [] }],
      responses: {
        '200': createSuccessResponse(
          z.object({ message: z.string() }),
          'Logged out successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/profile': {
    get: {
      summary: 'Get user profile',
      description: 'Retrieve the authenticated user\'s profile information',
      tags: ['Authentication'],
      security: [{ BearerAuth: [] }],
      responses: {
        '200': createSuccessResponse(userSchema, 'Profile retrieved successfully'),
        ...createErrorResponses(),
      },
    },
    put: {
      summary: 'Update user profile',
      description: 'Update the authenticated user\'s profile information',
      tags: ['Authentication'],
      security: [{ BearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: updateProfileSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(userSchema, 'Profile updated successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/change-password': {
    put: {
      summary: 'Change user password',
      description: 'Change the authenticated user\'s password',
      tags: ['Authentication'],
      security: [{ BearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: changePasswordSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({ message: z.string() }),
          'Password changed successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/auth/verify-token': {
    get: {
      summary: 'Verify token validity',
      description: 'Verify if the provided token is valid and return user information',
      tags: ['Authentication'],
      security: [{ BearerAuth: [] }],
      responses: {
        '200': createSuccessResponse(
          z.object({
            valid: z.boolean(),
            user: z.object({
              id: z.string().uuid(),
              firstName: z.string(),
              lastName: z.string().nullable(),
              email: z.string().nullable(),
              role: z.string(),
            }),
          }),
          'Token is valid'
        ),
        ...createErrorResponses(),
      },
    },
  },

  // Segment routes
  '/api/v1/segments': {
    get: {
      summary: 'Get all segments',
      description:
        'Retrieve all ski segments with their coordinates and terrain information. Supports filtering by bounding box, search, and updatedSince.',
      tags: ['Segments'],
      requestParams: {
        query: segmentQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(
          z.array(segmentSchema),               // ← inline array of Segment
          'Segments retrieved successfully'
        ),
        ...createErrorResponses(),
      }
    },
  },

  '/api/v1/segments/{id}/guideUpdate': {
    post: {
      summary: 'Create or update a guide update for a segment (Admin only)',
      description:
        'Creates a new guide update or updates the existing one for a segment. Only admins can create guide updates.',
      tags: ['Segments'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: segmentIdSchema,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: guideUpdateSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({
            description: z.string().nullable(),
            primarySnowTypeIds: z.array(z.string().uuid()),
            secondarySnowTypeIds: z.array(z.string().uuid()),
            hazards: z.array(z.string()),
          }),
          'Guide update created/updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  // Review routes
  '/api/v1/snow-types': {
    get: {
      summary: 'Get all snow types (primary and secondary)',
      description:
        'Retrieve all snow types including both primary and secondary snow types in a flat list.',
      tags: ['Snow Types'],
      responses: {
        '200': createSuccessResponse(
          snowTypesSchema,
          'Snow types retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
    post: {
      summary: 'Create a new snow type',
      description: 'Create a new snow type with the provided information. Requires authentication and admin role.',
      tags: ['Snow Types'],
      security: [{ BearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: createSnowTypeSchema,
            example: {
              name: 'Powder',
              colour: '#FFFFFF',
              skiability: 5,
              primarySnowTypeId: null,
              explanation: 'Fresh powder snow',
            },
          },
        },
      },
      responses: {
        '201': createSuccessResponse(
          snowTypeSchema,
          'Snow type created successfully'
        ),
        '400': createErrorResponses()['400'],
        '401': createErrorResponses()['401'],
        '403': createErrorResponses()['403'],
        '409': createErrorResponses()['409'],
        '500': createErrorResponses()['500'],
      },
    },
  },

  '/api/v1/snow-types/primary': {
    get: {
      summary: 'Get all primary snow types',
      description:
        'Retrieve all primary snow types (primarySnowTypeId: null) for reviews. Each primary snow type includes an array of its secondary snow types.',
      tags: ['Snow Types'],
      responses: {
        '200': createSuccessResponse(
          z.array(primarySnowTypeWithSecondariesSchema),
          'Snow types retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/snow-types/{id}/secondary': {
    post: {
      summary: 'Add secondary snow types to a snow type',
      description: 'Associate one or more existing snow types as secondary types for the specified snow type. All entities are SnowTypes - "secondary" refers only to the relationship. Requires authentication and admin role.',
      tags: ['Snow Types'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: snowTypeIdSchema,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: addSecondarySnowTypesSchema,
            example: {
              secondarySnowTypeIds: ['550e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002'],
            },
          },
        },
      },
      responses: {
        '200': createSuccessResponse(z.any(), 'Secondary snow types added successfully'),
        '400': createErrorResponses()['400'],
        '401': createErrorResponses()['401'],
        '403': createErrorResponses()['403'],
        '404': createErrorResponses()['404'],
        '500': createErrorResponses()['500'],
      },
    },
  },

  '/api/v1/observations': {
    get: {
      summary: 'Get observations for all segments',
      description: 'Retrieve observations (reviews and guide updates) for all segments from the last N days, grouped by segment. Supports pagination of segments.',
      tags: ['Reviews'],
      requestParams: {
        query: reviewsQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(z.array(observationSchema), 'Observations retrieved successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/segments/{id}/observations': {
    get: {
      summary: 'Get observations for a specific segment',
      description: 'Retrieve guide updates and user reviews for a specific segment within the requested time window.',
      tags: ['Reviews'],
      requestParams: {
        path: segmentIdSchema,
        query: segmentObservationQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(observationSchema, 'Segment observations retrieved successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/segments/{id}/reviews': {
    post: {
      summary: 'Create a review for a segment',
      description: 'Submit a snow condition review for a specific segment',
      tags: ['Reviews'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: segmentIdSchema,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: reviewSchema.omit({ segment: true }),
          },
        },
      },
      responses: {
        '201': createSuccessResponse(z.any(), 'Review created successfully'),
        ...createErrorResponses(),
      },
    },
  },

  // User routes
  '/api/v1/users/{deviceId}/location': {
    post: {
      summary: 'Update mobile user location',
      description: 'Update or create mobile user location data for tracking and rescue purposes',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: deviceIdSchema,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: locationUpdateSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({ status: z.string() }),
          'Location updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/users/{deviceId}/battery': {
    post: {
      summary: 'Update battery status',
      description: 'Update the battery status for a mobile user',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: deviceIdSchema,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: batteryUpdateSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({ status: z.string() }),
          'Battery status updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/users/{deviceId}/role': {
    get: {
      summary: 'Get user role',
      description: 'Retrieve the role and permissions for a mobile user',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: deviceIdSchema,
      },
      responses: {
        '200': createSuccessResponse(
          z.object({
            role: z.string(),
            permissions: z.string(),
          }),
          'User role retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
    post: {
      summary: 'Update user role',
      description: 'Update the role for a mobile user',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: deviceIdSchema,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: roleUpdateSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({
            role: z.string(),
            permissions: z.string(),
          }),
          'User role updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/users': {
    get: {
      summary: 'List all users',
      description: 'Get a list of all users (admin only)',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      responses: {
        '200': createSuccessResponse(z.array(userSchema), 'Users retrieved successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/users/me': {
    get: {
      summary: 'Get current user details',
      description: 'Get details of the currently authenticated user',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      responses: {
        '200': createSuccessResponse(userSchema, 'User details retrieved successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/users/{id}': {
    put: {
      summary: 'Update a user',
      description: 'Update user information (admin only)',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: z.object({
          id: z.string().uuid().meta({ description: 'User ID', example: '550e8400-e29b-41d4-a716-446655440001' }),
        }),
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: updateProfileSchema.extend({
              role: z.string().optional(),
            }),
          },
        },
      },
      responses: {
        '200': createSuccessResponse(userSchema, 'User updated successfully'),
        ...createErrorResponses(),
      },
    },
    delete: {
      summary: 'Delete a user',
      description: 'Delete a user and all related data (admin only)',
      tags: ['Users'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: z.object({
          id: z.string().uuid().meta({ description: 'User ID', example: '550e8400-e29b-41d4-a716-446655440001' }),
        }),
      },
      responses: {
        '200': createSuccessResponse(
          z.object({ message: z.string() }),
          'User deleted successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  // Help request routes
  // Help events
  '/help/events': {
    post: {
      summary: 'Create a new help event',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: helpEventCreateSchema,
          },
        },
      },
      responses: {
        '201': createSuccessResponse(
          helpEventRescueeViewSchema,
          'Help event created successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/help/events/nearby': {
    get: {
      summary: 'List nearby help events',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        query: helpEventNearbyQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(
          z.array(helpEventSummarySchema),
          'Nearby help events retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/help/events/{eventId}/view': {
    get: {
      summary: 'Get help event view',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: helpEventIdParams,
      },
      responses: {
        '200': createSuccessResponse(
          z.union([helpEventRescueeViewSchema, helpEventRescuerViewSchema]),
          'Help event view retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/help/events/{eventId}/acceptance': {
    post: {
      summary: 'Accept help event',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: helpEventIdParams,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: helpEventAcceptanceSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          helpEventRescuerViewSchema,
          'Rescuer joined the help event'
        ),
        ...createErrorResponses(),
      },
    },
    delete: {
      summary: 'Withdraw from help event',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: helpEventIdParams,
      },
      responses: {
        '200': createSuccessResponse(
          helpEventRescuerViewSchema,
          'Rescuer withdrew from the help event'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/help/events/{eventId}': {
    patch: {
      summary: 'Update help event status',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: helpEventIdParams,
      },
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: helpEventStatusUpdateSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          helpEventRescueeViewSchema,
          'Help event status updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/help/events/{eventId}/stream': {
    get: {
      summary: 'Stream help event updates',
      tags: ['Help Events'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: helpEventIdParams,
      },
      responses: {
        '501': {
          description: 'Streaming not yet implemented',
        },
        ...createErrorResponses(),
      },
    },
  },

  // Weather routes
  '/weather/average': {
    get: {
      summary: 'Average weather metric',
      description: 'Returns the average for supported weather items within the requested period.',
      tags: ['Weather'],
      requestParams: {
        query: weatherAverageQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(weatherMetricSchema, 'Average weather metric'),
        ...createErrorResponses(),
      },
    },
  },

  '/weather/minimum': {
    get: {
      summary: 'Minimum temperature',
      description: 'Returns the minimum temperature within the requested period.',
      tags: ['Weather'],
      requestParams: {
        query: weatherMinimumQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(weatherMetricSchema, 'Minimum temperature'),
        ...createErrorResponses(),
      },
    },
  },

  '/weather/maximum': {
    get: {
      summary: 'Maximum weather metric',
      description: 'Returns the maximum temperature or wind speed within the requested period.',
      tags: ['Weather'],
      requestParams: {
        query: weatherMaximumQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(weatherMetricSchema, 'Maximum weather metric'),
        ...createErrorResponses(),
      },
    },
  },

  '/weather/change': {
    get: {
      summary: 'Snow depth change',
      description: 'Returns the change in snow depth between the start and end of the requested period.',
      tags: ['Weather'],
      requestParams: {
        query: weatherChangeQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(weatherMetricSchema, 'Snow depth change'),
        ...createErrorResponses(),
      },
    },
  },

  '/weather/filterDays': {
    get: {
      summary: 'Filter days with average temperature above threshold',
      description: 'Returns the dates within the requested period where the daily average temperature exceeded the threshold.',
      tags: ['Weather'],
      requestParams: {
        query: weatherFilterDaysQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(weatherFilterDaysResponseSchema, 'Filtered days'),
        ...createErrorResponses(),
      },
    },
  },
};

