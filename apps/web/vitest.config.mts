import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [tsconfigPaths(), react()],
  test: {
    reporters: ["default", "html"],
    outputFile: "vitest-results/index.html",
    environment: "jsdom",
    setupFiles: ["./vitest.setup.ts"],
  },
});
