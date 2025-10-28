import swaggerAutogen from 'swagger-autogen';

const doc = {
  openapi: '3.0.0',
  info: {
    version: 'v2.0.0',
    title: 'Lumisovellus API',
    description:
      'Unified backend API for Lumisovellus - Snow condition tracking and rescue coordination system',
    contact: {
      name: 'Mindhive Oy',
      email: 'support@mindhive.fi',
    },
    license: {
      name: 'MIT',
      url: 'https://opensource.org/licenses/MIT',
    },
  },
  servers: [
    {
      url:
        process.env.NODE_ENV === 'production'
          ? 'https://api.lumisovellus.fi'
          : `http://localhost:${process.env.PORT || 3001}`,
      description: 'API Server',
    },
  ],
  tags: [
    { name: 'Health', description: 'Health check endpoints' },
    {
      name: 'Authentication',
      description: 'User authentication and account management',
    },
    { name: 'Segments', description: 'Ski segment management' },
    { name: 'Updates', description: 'Snow condition updates' },
    { name: 'Reviews', description: 'User reviews and ratings' },
    { name: 'Snow Types', description: 'Snow type classifications' },
    { name: 'Users', description: 'User management and mobile features' },
    { name: 'Help Requests', description: 'Emergency and assistance requests' },
  ],
  components: {
    securitySchemes: {
      BearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        description: 'Enter your JWT token (without the Bearer prefix)',
      },
    },
    schemas: {
      Error: {
        type: 'object',
        properties: {
          success: {
            type: 'boolean',
            example: false,
          },
          error: {
            type: 'object',
            properties: {
              code: {
                type: 'string',
                example: 'UNAUTHORIZED',
              },
              message: {
                type: 'string',
                example: 'Access token required',
              },
              details: {
                type: 'object',
                description: 'Additional error details',
              },
            },
          },
          meta: {
            type: 'object',
            properties: {
              timestamp: {
                type: 'string',
                example: '2024-01-15T10:30:00.000Z',
              },
            },
          },
        },
      },
      RegisterRequest: {
        type: 'object',
        required: ['firstName', 'email', 'password'],
        properties: {
          firstName: {
            type: 'string',
            example: 'John',
          },
          lastName: {
            type: 'string',
            example: 'Doe',
          },
          email: {
            type: 'string',
            format: 'email',
            example: 'user@example.com',
          },
          password: {
            type: 'string',
            minLength: 6,
            example: 'password123',
          },
          role: {
            type: 'string',
            enum: ['NORMAL', 'PREMIUM', 'ADMIN', 'RESCUE'],
            example: 'NORMAL',
          },
        },
      },
      LoginRequest: {
        type: 'object',
        required: ['email', 'password'],
        properties: {
          email: {
            type: 'string',
            format: 'email',
            example: 'user@example.com',
          },
          password: {
            type: 'string',
            example: 'password123',
          },
        },
      },
      AuthResponse: {
        type: 'object',
        properties: {
          success: {
            type: 'boolean',
            example: true,
          },
          data: {
            type: 'object',
            properties: {
              user: {
                type: 'object',
                properties: {
                  id: {
                    type: 'string',
                    example: '550e8400-e29b-41d4-a716-446655440001',
                  },
                  firstName: { type: 'string', example: 'John' },
                  lastName: { type: 'string', example: 'Doe' },
                  email: { type: 'string', example: 'user@example.com' },
                  role: {
                    type: 'string',
                    enum: ['NORMAL', 'PREMIUM', 'ADMIN', 'RESCUE'],
                    example: 'NORMAL',
                  },
                },
              },
              accessToken: {
                type: 'string',
                example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
              },
              refreshToken: {
                type: 'string',
                example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
              },
            },
          },
          meta: {
            type: 'object',
            properties: {
              message: { type: 'string', example: 'Login successful' },
              timestamp: {
                type: 'string',
                example: '2024-01-15T10:30:00.000Z',
              },
            },
          },
        },
      },
      RefreshTokenRequest: {
        type: 'object',
        required: ['refreshToken'],
        properties: {
          refreshToken: {
            type: 'string',
            example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
          },
        },
      },
      ChangePasswordRequest: {
        type: 'object',
        required: ['currentPassword', 'newPassword'],
        properties: {
          currentPassword: {
            type: 'string',
            example: 'oldpassword',
          },
          newPassword: {
            type: 'string',
            minLength: 6,
            example: 'newpassword123',
          },
        },
      },
      UpdateProfileRequest: {
        type: 'object',
        properties: {
          firstName: {
            type: 'string',
            example: 'John',
          },
          lastName: {
            type: 'string',
            example: 'Smith',
          },
          email: {
            type: 'string',
            format: 'email',
            example: 'johnsmith@example.com',
          },
          phoneNumber: {
            type: 'string',
            example: '+1234567890',
          },
        },
      },
      ResetPasswordRequest: {
        type: 'object',
        required: ['email'],
        properties: {
          email: {
            type: 'string',
            format: 'email',
            example: 'user@example.com',
          },
        },
      },
      Segment: {
        type: 'object',
        properties: {
          id: {
            type: 'string',
            format: 'uuid',
            example: '550e8400-e29b-41d4-a716-446655440000',
          },
          name: { type: 'string', example: 'Segment A' },
          terrain: { type: 'string', example: 'Alpine' },
          avalancheDanger: { type: 'boolean', example: false },
          isLowerSegment: { type: 'boolean', example: false },
          Points: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                lat: { type: 'number', example: 65.0121 },
                lng: { type: 'number', example: 25.4651 },
              },
            },
          },
        },
      },
      ReviewRequest: {
        type: 'object',
        required: ['segment', 'snowType', 'details', 'comment'],
        properties: {
          segment: {
            type: 'string',
            format: 'uuid',
            example: '550e8400-e29b-41d4-a716-446655440000',
          },
          snowType: {
            type: 'string',
            format: 'uuid',
            example: '550e8400-e29b-41d4-a716-446655440001',
          },
          details: { type: 'number', minimum: 1, maximum: 5, example: 4 },
          comment: {
            type: 'string',
            maxLength: 1000,
            example: 'Good snow conditions',
          },
        },
      },
      LocationUpdate: {
        type: 'object',
        required: ['timestamp', 'firstName', 'lastName', 'gpsCoord'],
        properties: {
          timestamp: { type: 'number', example: 1640995200 },
          firstName: { type: 'string', example: 'John' },
          lastName: { type: 'string', example: 'Doe' },
          gpsCoord: { type: 'string', example: '65.0121,25.4651' },
          phoneNumber: { type: 'string', example: '+358401234567' },
        },
      },
      HelpRequest: {
        type: 'object',
        required: ['timestamp', 'deviceId', 'gpsCoord', 'helpType'],
        properties: {
          timestamp: { type: 'number', example: 1640995200 },
          deviceId: { type: 'string', example: 'device123' },
          gpsCoord: { type: 'string', example: '65.0121,25.4651' },
          helpType: {
            type: 'string',
            enum: ['seriousEmerg', 'help'],
            example: 'help',
          },
          chatRoomId: { type: 'string', example: 'room123' },
        },
      },
    },
  },
};

export default doc;
