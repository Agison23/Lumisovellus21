import config from "@repo/eslint-config/web";

export default [
  ...config,

  {
    files: [
      "**/__tests__/**/*.{ts,tsx}",
      "**/*.test.{ts,tsx}",
      "**/*.spec.{ts,tsx}",
      "**/*.e2e.{ts,tsx}"
    ],
    rules: {
      "import/order": "off",
      "no-console": "off"
    }
  }
];
