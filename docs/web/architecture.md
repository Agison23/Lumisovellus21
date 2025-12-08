# Web architecture

This document contains an overview of the architecture of the Lumisovellus web application.

## Best practices

Before we start, here are some best practices to follow when working on the web application.

1. We use [TypeScript](https://www.typescriptlang.org/) for type safety. Always prefer typing your variables, function parameters, and return types. Current linting rules punish for using `any` type for a reason, do not try to bypass it.
2. We have a lucky chance of using a modern framework (Next.js 15) and React 19. These include:

   - Everything defaults to server components. This keeps bundles small and pages fast. Only add `"use client"` when you need:

     - Event handlers (`onClick`, `onChange` etc.)
     - Browser APIs (e.g. `localStorage`, `navigator` etc.)
     - State (`useState`, `useReducer` etc.)
     - Effects (`useEffect`, `useLayoutEffect` etc.)

   - Modern React features like `use`, `<Suspense>`, `useActionState` etc.

3. `useEffect` is a great footgun. You should avoid it unless absolutely necessary. Prefer async server components and fetching data with `fetch` or using React Query. There are most likely better ways to do what you want without `useEffect`.
4. Ensure all interactions are responsive. i.e. use spinners, loading states, and optimistic updates where necessary.

For a great introduction to React, see the [React tutorial](https://react.dev/learn).

## Overview

Lumisovellus uses [Next.js](https://nextjs.org/docs) as the web framework, which is built on top of React.

Project structure:

```txt
Lumisovellus/
├── apps/
├── ├── backend/
├── ├── mobile/
├── └── web/ <-- This is the main web application
├── docs/
├── infra/
├── legacy/
└── packages/
```

Structure of the `web` app:

```txt
web/
├── __tests__               <-- Test files
│   ├── e2e/                <-- End-to-end tests
│   └── page.test.tsx       <-- Example test file.
├── app                     <-- Main application code
│   ├── selitteet/          <-- Next.js uses file-system based routing
│   │   └── page.tsx        <-- Each folder represents a route (here:
/about)
│   ├── weather/
│   │   └── page.tsx        <-- Route: /weather
│   ├── favicon.ico
│   ├── globals.css         <-- Global styles
│   ├── layout.tsx          <-- Root layout component, layouts can be nested
│   └── page.tsx            <-- The main (index) page (here: /)
├── components/             <-- Reusable UI components
│   ├── ui/                 <-- shadcn/ui components automatically generated here
│   └── button.tsx          <-- Example component
├── eslint.config.mjs       <-- ESLint configuration
├── i18n/                    <-- Localization files
├── lib/                    <-- Library code (e.g. API clients, utilities)
│   ├── example.ts
├── messages/                <-- Localization files
│   ├── en.json
│   └── fi.json
├── next-env.d.ts           <-- Next.js types
├── next.config.ts          <-- Next.js configuration
├── package.json            <-- Project metadata and dependencies
├── playwright-report       <-- Playwright test reports
│   └── index.html
├── playwright.config.ts    <-- Playwright configuration
├── public                  <-- Static assets (served from the root path)
│   ├── file.svg
│   ├── globe.svg
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
├── README.md
├── test-results/            <-- Test results
├── tsconfig.json           <-- TypeScript configuration
└── vitest.config.mts       <-- Vitest configuration
```

## Routing and Layouts

Let's take the following example structure:

```txt
app/
├── layout.tsx               <-- Root layout, shared by all routes
├── page.tsx                 <-- Index ("/"), uses root layout
├── about/                   <-- /about
│   ├── layout.tsx           <-- Layout for "about" and its sub-routes
│   └── page.tsx             <-- page, uses "about" layout and root layout
└── dashboard/               <-- /dashboard"
    ├── layout.tsx           <-- Layout for "dashboard" and its sub-routes
    ├── page.tsx             <-- page, uses "dashboard" layout and root layout
    └── settings/            <-- /dashboard/settings
        └── page.tsx         <-- page, uses "dashboard" layout and root layout
```

More about structure can be found at [Project structure and organization](https://nextjs.org/docs/app/getting-started/project-structure). More documentation about routing and layouts can be found at [Layouts and Pages](https://nextjs.org/docs/app/getting-started/layouts-and-pages).

## Technologies

### Testing

- [Vitest](https://vitest.dev/) is used for unit and integration tests.
- [Playwright](https://playwright.dev/) is used for end-to-end tests.

### Running tests

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

### Map

- We utilize [react-map-gl](https://visgl.github.io/react-map-gl/) for rendering maps using Mapbox.

## Localization

We use [next-intl](https://next-intl.dev/) for localization.

Files for configuring and initializing localization can be found in the `i18n/` folder. The context for localization is provided in the root layout (`app/layout.tsx`).

Locale files are stored in the `messages/` folder as JSON files:

```json
// messages/en.json
{
  "title": "Welcome",
  "greeting": "Hello, {name}!"
}
```

Using localized strings in page components:

```tsx
import { useTranslations } from 'next-intl';

export default function HomePage() {
  const t = useTranslations('HomePage');
  return <h1>{t('title')}</h1>;
}
```

or in async components with `getTranslations`:

```tsx
import { getTranslations } from 'next-intl/server';

export default async function HomePage() {
  const t = await getTranslations('HomePage');
  return <h1>{t('title')}</h1>;
}
```

## Styling

- Global styles are defined in `app/globals.css`.
- We use Tailwind CSS for styling. See [Tailwind documentation](https://tailwindcss.com/docs) for more information.

## Components

- We use [shadcn/ui](https://ui.shadcn.com/docs) as our component library.

## Data fetching

- Use async Server Components for data fetching where possible (fetch, database calls).
- Use fetch with Next.js caching options when needed: `fetch(url, { next: { revalidate: 60 } })`.
- For client interactivity or real-time features, fetch inside Client Components using [React Query](https://tanstack.com/query/v5/docs/framework/react/overview) always! Avoid fetching using `useEffect` or similar hooks unless absolutely necessary.

## Environment variables

See .env.example for the list of environment variables used in the web application.

## Generating the API client

In the project root, run:

```bash
npm run openapi:client:web
```
