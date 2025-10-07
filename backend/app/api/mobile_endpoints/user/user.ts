import express from "express";
import type { Request, Response } from "express";
import type { DatabaseRequest } from "../../../middleware/database";

const router = express.Router();

router.get("/", (req: Request, res: Response) => {
  res.send("Hello from mobile Api User API!");
});

//test db connection
router.get("/check-db-user", async (req: Request, res: Response) => {
  const db_req = req as DatabaseRequest;
  try {
    const [rows] = await db_req.db.query("SELECT * FROM users");
    res.send(rows as unknown as object);
  } catch (err) {
    res.status(500).send(err);
  }
});

export default router;
