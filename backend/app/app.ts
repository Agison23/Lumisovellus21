import express from "express";
import cors from "cors";
import mobile_api from "./api/mobile_endpoints/mobile_api.js";
import web_api from "./api/web_endpoints/web_api.js";
import shared_api from "./api/shared_endpoints/shared_api.js";
import auth_api from "./api/shared_endpoints/auth/auth.js";
import users_api from "./api/shared_endpoints/users/users.js";
import type { Request, Response } from "express";
import swaggerUi from "swagger-ui-express";
import { readFileSync } from "fs";
import path from "path";
import DatabaseManager from "./config/database.js";
import config from "./config/env.js";
import { databaseMiddleware } from "./middleware/database.js";

const dbManager = DatabaseManager.getInstance({
  host: config.database.host,
  port: config.database.port,
  user: config.database.user,
  password: config.database.password,
  database: config.database.database,
  connectionLimit: config.database.connectionLimit,
  queueLimit: config.database.queueLimit,
  waitForConnections: config.database.waitForConnections,
});

// Run database migrations
dbManager.runMigrations().catch((error) => {
  console.error("Database migration failed:", error);
  if (process.env.NODE_ENV !== "test") {
    process.exit(1);
  }
});

// Export MySQL pool for use in API endpoints
export const db = dbManager.getPool();

const app = express();
const router = express.Router();

app.use(
  cors({
    origin: "*", // Allow all origins
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
    allowedHeaders: [
      "Content-Type",
      "Authorization",
      "X-Requested-With",
      "Accept",
      "Origin",
    ],
    credentials: false, // Set to true if you need cookies/credentials
    optionsSuccessStatus: 200, // For legacy browser support
  }),
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve latest Swagger JSON each request via a static endpoint
const swaggerJsonAbsolutePath = path.resolve(
  process.cwd(),
  "app/docs/swagger-output.json",
);

// Expose the JSON so Swagger UI can fetch latest contents without server restart
router.get("/swagger.json", (_req: Request, res: Response) => {
  res.setHeader(
    "Cache-Control",
    "no-store, no-cache, must-revalidate, proxy-revalidate",
  );
  res.setHeader("Pragma", "no-cache");
  res.setHeader("Expires", "0");
  res.sendFile(swaggerJsonAbsolutePath);
});

router.get("/", (req: Request, res: Response) => {
  res.send("Welcome to Api Backend! ");
});

// Configure Swagger UI to fetch the JSON from the dynamic endpoint
app.use(
  "/api-docs",
  swaggerUi.serve,
  swaggerUi.setup(undefined, { swaggerUrl: "/swagger.json" }),
);

app.use(databaseMiddleware);

router.use("/mobile-api", mobile_api);
router.use("/web-api", web_api);
router.use("/shared-api", shared_api);
router.use("/api/auth", auth_api);
router.use("/api/users", users_api);
app.use(router);

export default app;
