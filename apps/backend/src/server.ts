import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import rateLimit from 'express-rate-limit';
import swaggerUi from 'swagger-ui-express';
import fs from 'fs';
import path from 'path';

// Import API routers
import mobileApiRouter from './api/mobile_api';
import webApiRouter from './api/web_api';
import sharedApiRouter from './api/shared_api';

// Load swagger file
let swaggerFile;
try {
  const swaggerPath = path.join(process.cwd(), 'src', 'swagger-output.json');
  swaggerFile = JSON.parse(fs.readFileSync(swaggerPath, 'utf8'));
} catch (error) {
  console.warn('Swagger file not found, running without documentation');
  swaggerFile = {
    info: { title: 'API Documentation', version: '1.0.0' },
    paths: {}
  };
}

// Function to get swagger options with auto-login
async function getSwaggerOptions() {
  const baseOptions = {
    explorer: true,
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'Lumisovellus API Documentation',
    swaggerOptions: {
      persistAuthorization: true,
      authAction: {} as any
    }
  };

  // Auto-login for development
  if (process.env.NODE_ENV === 'development') {
    try {
      const devEmail = process.env.DEV_LOGIN_EMAIL || 'user@example.com';
      const devPassword = process.env.DEV_LOGIN_PASSWORD || 'password123';
      const port = process.env.PORT || 3001;
      
      // Perform auto-login
      const loginResponse = await fetch(`http://localhost:${port}/api/v1/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email: devEmail, password: devPassword })
      });
      
      if (loginResponse.ok) {
        const loginData = await loginResponse.json();
        if (loginData.data && loginData.data.token) {
          baseOptions.swaggerOptions.authAction = {
            'bearerAuth': {
              name: 'bearerAuth',
              schema: {
                type: 'apiKey',
                in: 'header',
                name: 'Authorization'
              },
              value: `Bearer ${loginData.data.token}`
            }
          };
          console.log(`✅ Swagger auto-login successful for ${devEmail}`);
        }
      }
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Unknown error';
      console.log('❌ Swagger auto-login failed:', errorMessage);
    }
  }

  return baseOptions;
}

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(cors({
  origin: ['http://localhost:3000', 'http://localhost:5173', 'http://localhost:5174'],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

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

// Use API routers
app.use('/', sharedApiRouter); // Health check and auth
app.use('/', webApiRouter);    // Web API endpoints
app.use('/', mobileApiRouter); // Mobile API endpoints with mobile-api prefix


// 404 handler
app.use((req, res) => {
  res.status(404).json({ 
    error: { 
      code: 'NOT_FOUND', 
      message: 'Endpoint not found' 
    } 
  });
});

// Error handler
app.use((error: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Unhandled error:', error);
  res.status(500).json({ 
    error: { 
      code: 'INTERNAL_SERVER_ERROR', 
      message: 'An unexpected error occurred' 
    } 
  });
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', async () => {
  console.log('SIGINT received, shutting down gracefully');
  process.exit(0);
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔗 API base: http://localhost:${PORT}/api/v1`);
  console.log(`📚 Swagger docs: http://localhost:${PORT}/api-docs`);
});

export default app;
