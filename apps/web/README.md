This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## ENV
Make a copy of the `.env.example` file and rename it to `.env.local`. Then, fill in the required environment variables.

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.

## Running tests

The web abblication has both unit tests and end-to-end (e2e) tests. You can run them using the following commands:

- To run all tests (both unit and e2e):

  ```bash
  npm run test
  ```

- To run only unit tests:

  ```bash
  npm run test:unit
  ```

- To run only e2e tests:

  ```bash
  npm run test:e2e
  ```

Running tests from the monorepo root:

- Using Turbo:

  ```bash
  turbo run test --filter web
  ```

- Using npm:

  ```bash
  npm run test -w web
  ```

Tests can be found in the `__tests__` directory. End-to-end tests can be found in the `__tests__/e2e/` directory. End-to-end tests use [Playwright](https://playwright.dev/) and require a running backend and web application. Otherwise [Vitest](https://vitest.dev/) is used for the unit tests. End-to-end tests have a file structure of `{test-name}.e2e.ts`.
