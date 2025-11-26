import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import swaggerUi from 'swagger-ui-express';

// Import new API router
import apiRouter from './api/routes';
import { errorHandler, notFoundHandler } from './api/middleware/errorHandler';
import { WeatherScheduler } from './scheduler/weatherScheduler';
import { openApiDocument } from './api/openapi/document';

// Function to get swagger options without auth
async function getSwaggerOptions() {
  const baseOptions = {
    explorer: true,
    customCss: `
      .swagger-ui .topbar { display: none }
      .swagger-ui .auth-wrapper { margin: 20px 0; }
      .swagger-ui .authorize { 
        padding: 10px 20px; 
        background: #4CAF50; 
        color: white; 
        border: none; 
        border-radius: 4px; 
        cursor: pointer;
      }
    `,
    customSiteTitle: 'Lumisovellus API Documentation',
    swaggerOptions: {
      persistAuthorization: true,
      displayRequestDuration: true,
      filter: true,
      showExtensions: true,
      showCommonExtensions: true,
      requestInterceptor: (request: any) => {
        // Ensure Bearer prefix is added to Authorization header if not present
        if (
          request.headers &&
          request.headers.Authorization &&
          !request.headers.Authorization.startsWith('Bearer ')
        ) {
          request.headers.Authorization = `Bearer ${request.headers.Authorization}`;
        }
        return request;
      },
    },
  };

  return baseOptions;
}

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(
  cors({
    origin: '*',
    credentials: false,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);

app.use(morgan('combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '900000'), // 15 minutes
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100'),
  message: 'Too many requests from this IP, please try again later.',
});
app.use('/api', limiter);

// Setup Swagger documentation
app.use('/api-docs', swaggerUi.serve, async (req, res, next) => {
  const options = await getSwaggerOptions();
  return swaggerUi.setup(openApiDocument, options)(req, res, next);
});

// JSON endpoint for the OpenAPI spec
app.get('/api-docs.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(openApiDocument);
});

// Use new API router
app.use('/', apiRouter);

// 404 handler
app.use(notFoundHandler);

// Error handler
app.use(errorHandler);

// Initialize and start weather scheduler
const weatherScheduler = new WeatherScheduler();
weatherScheduler.start();

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down gracefully...');
  weatherScheduler.stop();
  process.exit(0);
});

process.on('SIGINT', async () => {
  console.log('SIGINT received, shutting down gracefully...');
  weatherScheduler.stop();
  process.exit(0);
});

app.listen(PORT, () => {
  console.log(`Server started successfully on port ${PORT}`);
  console.log(`Health check: http://localhost:${PORT}/health`);
  console.log(`API base: http://localhost:${PORT}/api/v1`);
  console.log(`Swagger docs: http://localhost:${PORT}/api-docs`);
});

export default app;
