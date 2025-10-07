import mysql from "mysql2/promise";

export interface DatabaseConfig {
  host: string;
  port: number;
  user: string;
  password: string;
  database: string;
  connectionLimit?: number;
  queueLimit?: number;
  waitForConnections?: boolean;
}

class DatabaseManager {
  private static instance: DatabaseManager;
  private pool: mysql.Pool | null = null;
  private config: DatabaseConfig;

  private constructor(config: DatabaseConfig) {
    this.config = config;
    this.initializePool();
  }

  public static getInstance(config?: DatabaseConfig): DatabaseManager {
    if (!DatabaseManager.instance) {
      if (!config) {
        throw new Error(
          "Database configuration required for first initialization",
        );
      }
      DatabaseManager.instance = new DatabaseManager(config);
    }
    return DatabaseManager.instance;
  }

  private initializePool(): void {
    try {
      this.pool = mysql.createPool({
        host: this.config.host,
        port: this.config.port,
        user: this.config.user,
        password: this.config.password,
        database: this.config.database,
        connectionLimit: this.config.connectionLimit ?? 10,
        queueLimit: this.config.queueLimit ?? 0,
        waitForConnections: this.config.waitForConnections ?? true,
        namedPlaceholders: true,
        dateStrings: true,
      });
    } catch (error) {
      console.error("MySQL pool initialization failed:", error);
      throw error;
    }
  }

  public getPool(): mysql.Pool {
    if (!this.pool) {
      throw new Error("Database pool not initialized");
    }
    return this.pool;
  }

  public async close(): Promise<void> {
    if (this.pool) {
      await this.pool.end();
      this.pool = null;
    }
  }

  public async runMigrations(): Promise<void> {
    const pool = this.getPool();
    // Minimal schema with timestamps
    await pool.query(`CREATE TABLE IF NOT EXISTS users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(255) NOT NULL,
      email VARCHAR(255) NOT NULL UNIQUE,
      password VARCHAR(255) NOT NULL,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
      updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;`);
    // Backfill columns on older installations: split into two ALTERs (MySQL lacks IF NOT EXISTS for ADD COLUMN)
    try {
      await pool.query(
        `ALTER TABLE users ADD COLUMN createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP`,
      );
    } catch (e) {
      // ignore duplicate column error
      console.error("Duplicate column error:", e);
    }
    try {
      await pool.query(
        `ALTER TABLE users ADD COLUMN updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`,
      );
    } catch (e) {
      // ignore duplicate column error
      console.error("Duplicate column error:", e);
    }
  }
}

export default DatabaseManager;
