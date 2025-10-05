import sqlite3 from 'sqlite3';
import { mkdirSync, existsSync } from 'fs';
import path from 'path';

export interface DatabaseConfig {
  path: string;
  timeout: number;
  verbose?: boolean;
}

class DatabaseManager {
  private static instance: DatabaseManager;
  private db: sqlite3.Database | null = null;
  private config: DatabaseConfig;

  private constructor(config: DatabaseConfig) {
    this.config = config;
    this.initializeDatabase();
  }

  public static getInstance(config?: DatabaseConfig): DatabaseManager {
    if (!DatabaseManager.instance) {
      if (!config) {
        throw new Error('Database configuration required for first initialization');
      }
      DatabaseManager.instance = new DatabaseManager(config);
    }
    return DatabaseManager.instance;
  }

  private initializeDatabase(): void {
    try {
      // Ensure directory exists
      const dbDir = path.dirname(this.config.path);
      if (!existsSync(dbDir)) {
        mkdirSync(dbDir, { recursive: true });
      }

      // Create database connection with proper configuration
      this.db = new sqlite3.Database(this.config.path, (err) => {
        if (err) {
          console.error('Failed to connect to database:', err.message);
          throw err;
        }
        console.log('Connected to SQLite database');
      });

      // Enable foreign keys and other SQLite settings
      this.db.serialize(() => {
        this.db!.run('PRAGMA foreign_keys = ON');
        this.db!.run('PRAGMA journal_mode = WAL');
        this.db!.run('PRAGMA synchronous = NORMAL');
      });

    } catch (error) {
      console.error('Database initialization failed:', error);
      throw error;
    }
  }

  public getDatabase(): sqlite3.Database {
    if (!this.db) {
      throw new Error('Database not initialized');
    }
    return this.db;
  }

  public async close(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.db) {
        this.db.close((err) => {
          if (err) {
            console.error('Error closing database:', err);
            reject(err);
          } else {
            console.log('Database connection closed');
            this.db = null;
            resolve();
          }
        });
      } else {
        resolve();
      }
    });
  }

  public async runMigrations(): Promise<void> {
    const db = this.getDatabase();
    
    return new Promise((resolve, reject) => {
      db.serialize(() => {
        // Database is ready - no specific tables needed at this moment
        console.log('Database connection established and ready for use');
        resolve();
      });
    });
  }
}

export default DatabaseManager;
