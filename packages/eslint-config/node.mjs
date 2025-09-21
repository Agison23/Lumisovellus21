import base from "./base.mjs";

export default [
  ...base,
  {
    languageOptions: {
      globals: { module: "readonly", require: "readonly", __dirname: "readonly", process: "readonly" }
    }
  }
];
