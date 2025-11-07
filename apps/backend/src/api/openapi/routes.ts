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
  segmentUpdatesQuerySchema,
  updatesQuerySchema,
  reviewSchema,
  deviceIdSchema,
  locationUpdateSchema,
  batteryUpdateSchema,
  roleUpdateSchema,
  helpRequestSchema,
  helpResponseSchema,
  querySchema,
  createSnowTypeSchema,
  snowTypeIdSchema,
  addSecondarySnowTypesSchema,
  guideUpdateSchema,
  observationSchema,
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
          z.array(z.any()),
          'Segments retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/segments/{id}/updates': {
    get: {
      summary: 'Get latest updates for a segment',
      description: 'Retrieve the most recent updates for a specific segment',
      tags: ['Segments'],
      requestParams: {
        path: segmentIdSchema,
        query: segmentUpdatesQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(z.array(z.any()), 'Updates retrieved successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/segments/{id}/guideUpdate': {
    post: {
      summary: 'Create or update a guide update for a segment (Admin only)',
      description:
        'Creates a new guide update or updates the existing one for a segment. Only admins can create guide updates.',
      tags: ['Segments'],
      security: [{ bearerAuth: [] }],
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
          }),
          'Guide update created/updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/updates': {
    get: {
      summary: 'Get updates for segments',
      description: 'Get updates filtered by updatedSince or time range; include review details.',
      tags: ['Updates'],
      requestParams: {
        query: updatesQuerySchema,
      },
      responses: {
        '200': createSuccessResponse(
          z.array(z.any()),
          'Updates retrieved successfully, with review details included'
        ),
        ...createErrorResponses(),
      },
    },
  },

  // Review routes
  '/api/v1/snow-types': {
    get: {
      summary: 'Get all snow types',
      description: 'Retrieve all available snow types for reviews',
      tags: ['Snow Types'],
      responses: {
        '200': createSuccessResponse(z.array(z.any()), 'Snow types retrieved successfully'),
        ...createErrorResponses(),
      },
    },
    post: {
      summary: 'Create a new snow type',
      description: 'Create a new snow type with the provided information. Requires authentication and admin role.',
      tags: ['Snow Types'],
      security: [{ bearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: createSnowTypeSchema,
            example: {
              name: 'Powder',
              colour: '#FFFFFF',
              skiability: 5,
              categoryId: 1,
              explanation: 'Fresh powder snow',
            },
          },
        },
      },
      responses: {
        '201': createSuccessResponse(z.any(), 'Snow type created successfully'),
        '400': createErrorResponses()['400'],
        '401': createErrorResponses()['401'],
        '403': createErrorResponses()['403'],
        '409': createErrorResponses()['409'],
        '500': createErrorResponses()['500'],
      },
    },
  },

  '/api/v1/snow-types/{id}/secondary': {
    post: {
      summary: 'Add secondary snow types to a snow type',
      description: 'Associate one or more existing snow types as secondary types for the specified snow type. All entities are SnowTypes - "secondary" refers only to the relationship. Requires authentication and admin role.',
      tags: ['Snow Types'],
      security: [{ bearerAuth: [] }],
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

  '/api/v1/reviews': {
    get: {
      summary: 'Get observations for all segments',
      description: 'Retrieve observations (reviews and guide updates) for all segments from the last N days, grouped by segment',
      tags: ['Reviews'],
      requestParams: {
        query: querySchema,
      },
      responses: {
        '200': createSuccessResponse(z.array(observationSchema), 'Observations retrieved successfully'),
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
  '/api/v1/help-requests': {
    post: {
      summary: 'Create help request',
      description: 'Create a help request for emergency or assistance',
      tags: ['Help Requests'],
      security: [{ BearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: helpRequestSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({
            status: z.string(),
            nearbyUsers: z.number(),
          }),
          'Help request created successfully'
        ),
        ...createErrorResponses(),
      },
    },
    get: {
      summary: 'Get help requests',
      description: 'Retrieve all help requests for rescue interface',
      tags: ['Help Requests'],
      security: [{ BearerAuth: [] }],
      responses: {
        '200': createSuccessResponse(z.array(z.any()), 'Help requests retrieved successfully'),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/help-responses': {
    post: {
      summary: 'Update help response',
      description: 'Update the response status for a help request',
      tags: ['Help Requests'],
      security: [{ BearerAuth: [] }],
      requestBody: {
        required: true,
        content: {
          'application/json': {
            schema: helpResponseSchema,
          },
        },
      },
      responses: {
        '200': createSuccessResponse(
          z.object({ status: z.string() }),
          'Help response updated successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  '/api/v1/help-requests/{id}/helpers': {
    get: {
      summary: 'Get users who can help with a specific help request',
      description:
        'Retrieve all users who have been notified about a help request with their status and distance',
      tags: ['Help Requests'],
      security: [{ BearerAuth: [] }],
      requestParams: {
        path: z.object({
          id: z.string().meta({ description: 'Help request ID', example: '550e8400-e29b-41d4-a716-446655440000' }),
        }),
      },
      responses: {
        '200': createSuccessResponse(
          z.array(
            z.object({
              userId: z.string(),
              firstName: z.string(),
              lastName: z.string().nullable(),
              phoneNumber: z.string().nullable(),
              distance: z.number(),
              state: z.number(),
              lowBattery: z.number(),
              lastSeen: z.string().datetime(),
            })
          ),
          'Help request helpers retrieved successfully'
        ),
        ...createErrorResponses(),
      },
    },
  },

  // Weather routes
  '/weather': {
    get: {
      summary: 'Get latest weather data',
      description: 'Returns the most recent weather data from the FMI API',
      tags: ['Weather'],
      responses: {
        '200': createSuccessResponse(z.any(), 'Latest weather data'),
        ...createErrorResponses(),
      },
    },
  },

  '/weather/history': {
    get: {
      summary: 'Get weather history',
      description: 'Returns historical weather data',
      tags: ['Weather'],
      requestParams: {
        query: z.object({
          limit: z
            .string()
            .transform((val) => parseInt(val, 10))
            .pipe(z.number().int().min(1).max(100))
            .optional()
            .meta({ description: 'Maximum number of records to return', example: '100' }),
        }),
      },
      responses: {
        '200': createSuccessResponse(z.array(z.any()), 'Weather history'),
        ...createErrorResponses(),
      },
    },
  },

  '/weather/update': {
    post: {
      summary: 'Manually trigger weather update',
      description: 'Fetches new weather data from FMI API and saves it to database',
      tags: ['Weather'],
      responses: {
        '200': createSuccessResponse(z.any(), 'Weather data updated successfully'),
        ...createErrorResponses(),
      },
    },
  },
};

