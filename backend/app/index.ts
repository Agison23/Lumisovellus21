import app from "./app.js";
import config from "./config/env.js";

const port = config.app.port;
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
