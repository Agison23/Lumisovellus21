import swaggerAutogen from 'swagger-autogen';

const doc = {
  info: {
    version: 'v2.0.0',
    title: 'Lumisovellus API',
    description: 'Unified backend API for Lumisovellus - Snow condition tracking and rescue coordination system',
    contact: {
      name: 'Mindhive Oy',
      email: 'support@mindhive.fi',
    },
    license: {
      name: 'MIT',
      url: 'https://opensource.org/licenses/MIT',
    },
  },
  host: process.env.NODE_ENV === 'production'
    ? 'api.lumisovellus.fi'
    : `localhost:${process.env.PORT || 3001}`,
  basePath: '/',
  schemes: ['http', 'https'],
  consumes: ['application/json'],
  produces: ['application/json'],
  tags: [
    { name: 'Auth', description: 'Authentication related endpoints' },
    { name: 'User', description: 'User management endpoints' },
    { name: 'Segments', description: 'Segment and condition data' },
  ],
  securityDefinitions: {
    bearerAuth: {
      type: 'apiKey',
      in: 'header',
      name: 'Authorization',
      description: 'Use format: Bearer <JWT>. Obtain token from /api/v1/auth/login'
    }
  },
  security: [{ bearerAuth: [] }],
  definitions: {
    Error: {
      type: 'object',
      properties: {
        error: {
          type: 'object',
          properties: {
            code: {
              type: 'string',
              example: 'UNAUTHORIZED'
            },
            message: {
              type: 'string',
              example: 'Access token required'
            }
          }
        }
      }
    },
    LoginRequest: {
      type: 'object',
      required: ['email', 'password'],
      properties: {
        email: {
          type: 'string',
          format: 'email',
          example: 'user@example.com'
        },
        password: {
          type: 'string',
          example: 'password123'
        }
      }
    },
    LoginResponse: {
      type: 'object',
      properties: {
        data: {
          type: 'object',
          properties: {
            token: {
              type: 'string',
              example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
            },
            user: {
              type: 'object',
              properties: {
                id: { type: 'string', example: '550e8400-e29b-41d4-a716-446655440001' },
                firstName: { type: 'string', example: 'John' },
                lastName: { type: 'string', example: 'Doe' },
                email: { type: 'string', example: 'user@example.com' },
                role: { type: 'string', example: 'user' }
              }
            }
          }
        }
      }
    },
    Segment: {
      type: 'object',
      properties: {
        id: { type: 'number', example: 1 },
        name: { type: 'string', example: 'Segment A' },
        terrain: { type: 'string', example: 'Alpine' },
        avalancheDanger: { type: 'string', example: 'Moderate' },
        isLowerSegment: { type: 'boolean', example: false },
        Points: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              lat: { type: 'number', example: 65.0121 },
              lng: { type: 'number', example: 25.4651 }
            }
          }
        }
      }
    },
    ReviewRequest: {
      type: 'object',
      required: ['segment', 'snowType', 'details', 'comment'],
      properties: {
        segment: { type: 'number', example: 1 },
        snowType: { type: 'number', example: 2 },
        details: { type: 'number', minimum: 1, maximum: 5, example: 4 },
        comment: { type: 'string', maxLength: 1000, example: 'Good snow conditions' }
      }
    },
    LocationUpdate: {
      type: 'object',
      required: ['timestamp', 'devId', 'firstName', 'lastName', 'gpsCoord'],
      properties: {
        timestamp: { type: 'number', example: 1640995200 },
        devId: { type: 'string', example: 'device123' },
        firstName: { type: 'string', example: 'John' },
        lastName: { type: 'string', example: 'Doe' },
        gpsCoord: { type: 'string', example: '65.0121,25.4651' },
        phoneNumber: { type: 'string', example: '+358401234567' }
      }
    },
    HelpRequest: {
      type: 'object',
      required: ['timestamp', 'devId', 'gpsCoord', 'helpType'],
      properties: {
        timestamp: { type: 'number', example: 1640995200 },
        devId: { type: 'string', example: 'device123' },
        gpsCoord: { type: 'string', example: '65.0121,25.4651' },
        helpType: { type: 'string', enum: ['seriousEmerg', 'help'], example: 'help' },
        chatRoomId: { type: 'string', example: 'room123' }
      }
    }
  },
};

const outputFile = './swagger-output.json';
const endpointsFiles = [
  './server.ts',
  './api/shared_api/index.ts',
  './api/web_api/index.ts',
  './api/mobile_api/index.ts',
];

const swaggerAutogenInstance = swaggerAutogen();
swaggerAutogenInstance(outputFile, endpointsFiles, doc);

export default doc;
