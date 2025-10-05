import express from "express";
import cors from "cors";
import mobile_api from "./api/mobile_endpoints/mobile_api.js";
import web_api from "./api/web_endpoints/web_api.js";
import shared_api from "./api/shared_endpoints/shared_api.js";
import type { Request, Response } from "express";
import swaggerUi from "swagger-ui-express";
import { readFileSync } from "fs";
import DatabaseManager from "./config/database.js";
import config from "./config/env.js";
import { databaseMiddleware } from "./middleware/database.js";

const dbManager = DatabaseManager.getInstance({
  path: config.database.path,
  timeout: config.database.timeout,
  verbose: config.app.nodeEnv === 'development'
});

// Run database migrations
dbManager.runMigrations().catch((error) => {
  console.error('Database migration failed:', error);
  process.exit(1);
});

// Export database instance for use in API endpoints
export const db = dbManager.getDatabase();

const app = express();
const router = express.Router();

app.use(cors({
  origin: '*', // Allow all origins
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With', 'Accept', 'Origin'],
  credentials: false, // Set to true if you need cookies/credentials
  optionsSuccessStatus: 200 // For legacy browser support
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const swaggerDocument = JSON.parse(
  readFileSync("./app/docs/swagger-output.json", "utf8"),
);

router.get("/", (req: Request, res: Response) => {
  res.send("Welcome to Api Backend! ");
});

app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerDocument));

app.use(databaseMiddleware);

router.use("/mobile-api", mobile_api);
router.use("/web-api", web_api);
router.use("/shared-api", shared_api);
app.use(router);

export default app;
