import { defineConfig } from 'vitest/config';

export default defineConfig({
  optimizeDeps: {
    disabled: true,
  },
  test: {
    include: ['src/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
    exclude: ['node_modules', 'dist', '.idea', '.git', '.cache'],
    environment: 'node',
    globals: true,
    fileParallelism: false,
    globalSetup: ['src/test/setup.ts'],
    setupFiles: ['src/test/vitest.setup.ts'],
  },
});
