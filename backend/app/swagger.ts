import swaggerAutogen from "swagger-autogen";
import config from "./config/env.js";

const doc = {
  info: {
    version: "v1.0.0",
    title: config.app.name,
    description: `${config.app.name} API Documentation`,
  },
  host: `localhost:${config.app.port}`,
  basePath: "/",
  schemes: ["http", "https"],
};

const outputFile = "app/docs/swagger-output.json";
const endpointsFiles = ["app/app.ts"];

const swaggerAutogenInstance = swaggerAutogen();
swaggerAutogenInstance(outputFile, endpointsFiles, doc);
