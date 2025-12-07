import js from '@eslint/js';
import ts from 'typescript-eslint';
import importPlugin from 'eslint-plugin-import';
import unused from 'eslint-plugin-unused-imports';

export default [
  {
    ignores: [
      '**/node_modules/**',
      '**/dist/**',
      '**/.next/**',
      '**/coverage/**',
    ],
  },
  js.configs.recommended,
  ...ts.configs.recommended,
  {
    files: ['**/*.{ts,tsx,js,jsx}'],
    plugins: { import: importPlugin, 'unused-imports': unused },
    rules: {
      'no-console': 'warn',
      'unused-imports/no-unused-imports': 'error',
      'import/order': [
        'error',
        { alphabetize: { order: 'asc', caseInsensitive: true } },
      ],
    },
  },
];
