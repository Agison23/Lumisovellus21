import DatabaseManager from '../app/config/database.js';
import config from '../app/config/env.js';
import type { Pool } from 'mysql2/promise';

let dbManager: ReturnType<typeof DatabaseManager.getInstance>;
export let db: Pool;

beforeAll(async () => {
  // Ensure tests point to local Docker MySQL
  process.env.DB_HOST = process.env.DB_HOST || '127.0.0.1';
  process.env.DB_PORT = process.env.DB_PORT || '3306';
  process.env.DB_USER = process.env.DB_USER || 'app';
  process.env.DB_PASSWORD = process.env.DB_PASSWORD || 'app_password';
  // Use dedicated test database; do NOT override DB_NAME here
  process.env.TEST_DB_NAME = process.env.TEST_DB_NAME || 'northstar_test';

  console.log('Test DB Config:', {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    database: process.env.TEST_DB_NAME,
  });

  dbManager = DatabaseManager.getInstance({
    host: process.env.DB_HOST!,
    port: parseInt(process.env.DB_PORT!, 10),
    user: process.env.DB_USER!,
    password: process.env.DB_PASSWORD!,
    database: process.env.TEST_DB_NAME!,
    connectionLimit: config.database.connectionLimit,
    queueLimit: config.database.queueLimit,
    waitForConnections: config.database.waitForConnections,
  });
  db = dbManager.getPool();
  await dbManager.runMigrations();
  
  // Expose test database connection globally for middleware
  (globalThis as any).__testDb = db;
}, 30000);

beforeEach(async () => {
  await db.query('START TRANSACTION');
});

afterEach(async () => {
  await db.query('ROLLBACK');
});

afterAll(async () => {
  await dbManager.close();
}, 30000);
