import express from 'express';
import type { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import config from '../../../config/env.js';
import type { DatabaseRequest } from '../../../middleware/database.js';

const router = express.Router();

// POST /api/auth/login
router.post('/login', async (req: Request, res: Response) => {
  return res.status(500).json({ message: 'Login failed' });
  
});

export default router;
