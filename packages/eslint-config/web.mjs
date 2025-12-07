import js from "@eslint/js";
import ts from "typescript-eslint";
import importPlugin from "eslint-plugin-import";
import unused from "eslint-plugin-unused-imports";
import react from "eslint-plugin-react";
import reactHooks from "eslint-plugin-react-hooks";
import nextPlugin from "@next/eslint-plugin-next";

export default [
  { ignores: ["**/node_modules/**","**/dist/**","**/.next/**","**/coverage/**", "**/vitest-results/**"] },
  js.configs.recommended,
  ...ts.configs.recommended,
  react.configs.flat.recommended,
  {
    files: ["**/*.{ts,tsx,js,jsx}"],
    plugins: {
      import: importPlugin,
      "unused-imports": unused,
      react,
      "react-hooks": reactHooks,
      next: nextPlugin
    },
    rules: {
      "no-console": "warn",
      "@typescript-eslint/no-unused-vars": "off",
      "unused-imports/no-unused-imports": "error",
      "import/order": ["error", { "alphabetize": { "order": "asc", "caseInsensitive": true } }],
      "react/react-in-jsx-scope": "off",
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn"
    },
    settings: {
      react: { version: "19" }
    }
  },
  {
    files: ["**/*.d.ts"],
    rules: {
      "@typescript-eslint/triple-slash-reference": "off"
    }
  }
];
