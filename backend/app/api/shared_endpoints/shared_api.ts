import express from "express";
import type { Request, Response } from 'express';
import authRouter from "./auth/auth.js";
import usersRouter from "./users/users.js";

const router = express.Router();

router.get("/", (req: Request, res: Response) => {
  res.send("Shared API is running!");
});

router.use("/auth", authRouter);
router.use("/users", usersRouter);    

export default router;
