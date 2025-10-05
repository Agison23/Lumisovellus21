import express from "express";

const app = express();

app.get("/health", (req, res) => {
  res.status(200).send("ok");
});

const port = process.env.PORT || 3001;
app.listen(port, () => {});