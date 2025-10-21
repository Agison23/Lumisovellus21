import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import swaggerUi from 'swagger-ui-express';
import fs from 'fs';
import path from 'path';

// Import new API router
import apiRouter from './api/routes';
import { errorHandler, notFoundHandler } from './api/middleware/errorHandler';

// Load swagger file
let swaggerFile;
try {
  const swaggerPath = path.join(process.cwd(), 'src', 'swagger-output.json');
  swaggerFile = JSON.parse(fs.readFileSync(swaggerPath, 'utf8'));
} catch {
  // Swagger file not found, running without documentation
  swaggerFile = {
    info: { title: 'API Documentation', version: '1.0.0' },
    paths: {},
  };
}

// Function to get swagger options without auth
async function getSwaggerOptions() {
  const baseOptions = {
    explorer: true,
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'Lumisovellus API Documentation',
    swaggerOptions: {
      persistAuthorization: false,
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
    origin: [
      'http://localhost:3000',
      'http://localhost:5173',
      'http://localhost:5174',
    ],
    credentials: true,
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
  return swaggerUi.setup(swaggerFile, options)(req, res, next);
});

// JSON endpoint for the OpenAPI spec
app.get('/api-docs.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(swaggerFile);
});

// Use new API router
app.use('/', apiRouter);

// 404 handler
app.use(notFoundHandler);

// Error handler
app.use(errorHandler);

// Graceful shutdown
process.on('SIGTERM', async () => {
  // SIGTERM received, shutting down gracefully
  process.exit(0);
});

process.on('SIGINT', async () => {
  // SIGINT received, shutting down gracefully
  process.exit(0);
});

app.listen(PORT, () => {
  // Server started successfully
  // Health check: http://localhost:${PORT}/health
  // API base: http://localhost:${PORT}/api/v1
  // Swagger docs: http://localhost:${PORT}/api-docs
});

export default app;
