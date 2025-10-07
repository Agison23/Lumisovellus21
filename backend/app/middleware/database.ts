import type { NextFunction, Request, Response } from 'express';
import { db } from '../app.js';

export interface DatabaseRequest extends Request {
  db: typeof db;
}

export const databaseMiddleware = (req: Request, res: Response, next: NextFunction) => {
  if (db === null) {
    return res.status(500).json({ error: 'Database not initialized' });
  }
  (req as DatabaseRequest).db = db;
  next();
};
