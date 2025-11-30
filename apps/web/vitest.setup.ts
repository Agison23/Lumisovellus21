import "@testing-library/jest-dom/vitest";
import { cleanup } from "@testing-library/react";
import { config } from "dotenv";
import { afterEach } from "vitest";

// Load environment variables from .env file
config();

afterEach(() => {
  cleanup();
});
