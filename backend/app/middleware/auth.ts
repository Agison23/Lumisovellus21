import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import config from "../config/env.js";

export interface AuthenticatedRequest extends Request {
  user?: { id: number; email: string };
}

export function requireAuth(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith("Bearer ")) {
    return res.sendStatus(401);
  }
  const token = header.slice(7);
  try {
    const decoded = jwt.verify(token, config.security.jwtSecret) as Partial<{
      id: number;
      email: string;
    }>;
    if (
      !decoded ||
      typeof decoded.id !== "number" ||
      typeof decoded.email !== "string"
    ) {
      return res.sendStatus(401);
    }
    (req as AuthenticatedRequest).user = {
      id: decoded.id,
      email: decoded.email,
    } as { id: number; email: string };
    next();
  } catch {
    return res.sendStatus(401);
  }
}
