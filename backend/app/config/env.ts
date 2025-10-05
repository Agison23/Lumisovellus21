import dotenv from 'dotenv';

dotenv.config();

export const config = {
  database: {
    path: process.env.DB_PATH || './app/db/database.sqlite',
    timeout: parseInt(process.env.DB_TIMEOUT || '5000'),
  },
  app: {
    name: process.env.APP_NAME || 'NorthStar',
    port: parseInt(process.env.PORT || '8000'),
    nodeEnv: process.env.NODE_ENV || 'dev',
  },
  security: {
    jwtSecret: process.env.JWT_SECRET || 'default-secret-change-in-production',
    bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS || '12'),
  },
  logging: {
    level: process.env.LOG_LEVEL || 'info',
  },
};

export default config;
