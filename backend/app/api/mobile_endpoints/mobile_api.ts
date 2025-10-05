import express from "express";
import userRouter from "./user/user.js";

const router = express.Router();

router.use("/user", userRouter);

router.get("/", (req: any, res: any) => {
  res.send("Mobile API is running!");
});

export default router;
