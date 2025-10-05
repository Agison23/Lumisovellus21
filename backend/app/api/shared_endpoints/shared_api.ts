import express from "express";

const router = express.Router();

router.get("/", (req: any, res: any) => {
  res.send("Shared API is running!");
});

export default router;
