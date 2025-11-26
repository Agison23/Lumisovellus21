import 'zod-openapi';
import { createDocument } from 'zod-openapi';
import { openApiRoutes } from './routes';
import { errorResponseSchema, healthResponseSchema } from './schemas';

// Base OpenAPI document structure
const baseDocument = {
  openapi: '3.0.0' as const,
  info: {
    title: 'Lumisovellus API',
    version: 'v2.0.0',
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
    { name: 'Weather', description: 'Weather data endpoints' },
  ],
  components: {
    securitySchemes: {
      BearerAuth: {
        type: 'http' as const,
        scheme: 'bearer' as const,
        bearerFormat: 'JWT',
        description: 'Enter your JWT token (without the Bearer prefix)',
      },
    },
    schemas: {
      ErrorResponse: errorResponseSchema,
      HealthResponse: healthResponseSchema,
    },
  },
  paths: openApiRoutes,
};

// Create and export the OpenAPI document
export const openApiDocument = createDocument(baseDocument);

