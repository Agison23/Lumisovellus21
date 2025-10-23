import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    include: ["src/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}"],
    exclude: ["node_modules", "dist", ".idea", ".git", ".cache"],
    environment: "node",
    globals: true,
    fileParallelism: false, // Run tests sequentially to avoid DB conflicts
    globalSetup: ["src/test/setup.ts"],
    setupFiles: ["src/test/vitest.setup.ts"],
  },
});
