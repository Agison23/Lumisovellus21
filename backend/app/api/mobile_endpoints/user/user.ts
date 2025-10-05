import express from "express";
import type { Request, Response } from "express";
import type { DatabaseRequest } from "../../../middleware/database";

const router = express.Router();

router.get("/", (req: Request, res: Response) => {
  res.send("Hello from User API!");
});

//test db connection
router.get("/check-db-user", (req: Request, res: Response) => {
  const db_req = req as DatabaseRequest;
  db_req.db.all("SELECT * FROM users", (err, rows) => {
    if (err) {
      res.status(500).send(err);
    }
    res.send(rows);
  });
});


export default router;
