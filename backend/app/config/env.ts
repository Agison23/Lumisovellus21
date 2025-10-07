import dotenv from "dotenv";
dotenv.config();

export const config = {
  database: {
    // MySQL connection configuration
    host: process.env.DB_HOST || "mysql",
    port: parseInt(process.env.DB_PORT || "3306"),
    user: process.env.DB_USER || "app",
    password: process.env.DB_PASSWORD || "app_password",
    database:
      process.env.NODE_ENV === "test"
        ? process.env.TEST_DB_NAME || "northstar_test"
        : process.env.DB_NAME || "northstar",
    // Pool options
    connectionLimit: parseInt(process.env.DB_POOL_SIZE || "10"),
    queueLimit: parseInt(process.env.DB_POOL_QUEUE_LIMIT || "0"),
    waitForConnections: (process.env.DB_POOL_WAIT || "true") === "true",
  },
  app: {
    name: process.env.APP_NAME || "NorthStar",
    port: parseInt(process.env.PORT || "8000"),
    nodeEnv: process.env.NODE_ENV,
  },
  security: {
    jwtSecret: process.env.JWT_SECRET || "default-secret-change-in-production",
    bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS || "12"),
  },
  logging: {
    level: process.env.LOG_LEVEL || "info",
  },
};

export default config;
