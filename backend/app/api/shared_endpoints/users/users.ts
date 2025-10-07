import express from 'express';
import type { Request, Response } from 'express';

import bcrypt from 'bcryptjs';
import type { DatabaseRequest } from '../../../middleware/database.js';
import { requireAuth } from '../../../middleware/auth.js';
import config from '../../../config/env.js';

const router = express.Router();

// GET /api/users
router.get('/', requireAuth, async (req: Request, res: Response) => {
  return res.json([]);
});

// GET /api/users/:id
router.get('/:id', requireAuth, async (req: Request, res: Response) => {
  return res.json([]);
});

// POST /api/users
router.post('/', requireAuth, async (req: Request, res: Response) => {
  return res.status(201).json({ message: 'Created' });
});

// PUT /api/users/:id
router.put('/:id', requireAuth, async (req: Request, res: Response) => {
  return res.json([]);
});

// DELETE /api/users/:id

router.delete('/:id', requireAuth, async (req: Request, res: Response) => {
  return res.json([]);
});

export default router;
