import { defineConfig } from "vitest/config";
import react from "@vitejs/plugin-react";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [tsconfigPaths(), react()],
  test: {
    globals: true,
    environment: "jsdom",

    setupFiles: "./vitest.setup.ts",

    reporters: ["default", "html"],
    outputFile: "vitest-results/index.html",
    deps: {
      optimizer: {
        web: {
          enabled: false,
        },
      },
    },
  },
});
