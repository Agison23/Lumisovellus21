import base from "./base.mjs";
import { FlatCompat } from "@eslint/eslintrc";

const compat = new FlatCompat({ baseDirectory: import.meta.dirname });

export default [
  ...base,
  ...compat.config({
    extends: ["next/core-web-vitals"],
    settings: {
      next: { rootDir: ["apps/web/"] }
    }
  }),
  {
    files: ["apps/web/**/*.{ts,tsx,js,jsx}"],
    rules: {
      "unused-imports/no-unused-imports": ["error", { "ignoreTypeImports": true }]
    }
  },
  {
    files: ["**/*.d.ts"],
    rules: { "@typescript-eslint/triple-slash-reference": "off" }
  }
];
