import "@testing-library/jest-dom/vitest";
import { cleanup } from "@testing-library/react";
import { afterEach } from "vitest";
import { config } from "dotenv";

// Load environment variables from .env file
config();

afterEach(() => {
  cleanup();
});
