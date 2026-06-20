<p align="center">
  <picture>
    <source srcset="apps/mobile/assets/images/pallaksen_pollot_logo_white.png" media="(prefers-color-scheme: dark)">
    <source srcset="apps/mobile/assets/images/pallaksen_pollot_logo.png" media="(prefers-color-scheme: light)">
    <img alt="Pallaksen Pöllöt logo" src="apps/mobile/assets/images/pallaksen_pollot_logo.png" width="240">
  </picture>
</p>

# Lumisovellus / Snowledge

Monorepo for the Lumisovellus project: backend API, web dashboard and Flutter mobile app.

## Overview

- **Backend**: Node.js + Express + Prisma API, MySQL  
- **Web**: Next.js 15 + React 19, TypeScript, shadcn/ui, Maplibre  
- **Mobile**: Flutter + Riverpod, MVVM, offline-friendly architecture with Drift 

Monorepo tooling:

- **Package manager**: npm workspaces  
- **Task runner**: Turborepo  
- **OpenAPI**: Backend emits `openapi.json`, used to generate web & mobile clients  

## Repository structure

```text
apps/
  backend/   # API, DB, OpenAPI spec
  mobile/    # Flutter app
  web/       # Next.js web client
docs/
  mobile/    # Mobile architecture, caching, env/dev container
  web/       # Web architecture & conventions
infra/
  docker/    # Docker & DB infra
legacy/      # Old implementation, kept for reference
packages/
  api-client-web/  # TS client from OpenAPI
  eslint-config/
  shared/
  templates/
  tsconfig/
```

## Getting started (monorepo)

From repo root:

```bash
npm install
cd infra/docker && docker compose up mysql -d && cd ../..
npm run dev
```

This will:

- start the backend (with DB from Docker)  
- start the web app  
- start the mobile tooling; for full mobile hot reload, see below  

Useful root scripts:

```bash
npm run dev              # start all dev targets via turbo
npm test                 # run tests (web + backend, mobile excluded)
npm run lint             # lint (web + backend)
npm run build            # build (web + backend)
npm run verify           # openapi:check + lint + typecheck + test + build
```

### Environment

Backend:

- Copy `apps/backend/.env.example` → `apps/backend/.env`  
- Set `DATABASE_URL`, for Docker dev typically:

  ```text
  mysql://lumisovellus:password@mysql:3306/lumisovellus
  ```

Mobile:

- Copy `apps/mobile/.env.example` → `apps/mobile/.env`  
- Set `MAPBOX_ACCESS_TOKEN` to your public Mapbox token  

More detailed Dev Container + Android emulator instructions: see `docs/mobile/`.

## Backend (apps/backend)

Tech: Node.js, Express, Prisma, MySQL, Vitest.

### Run backend only

```bash
cd apps/backend
npm install
cp .env.example .env
npm run db:generate
npm run db:migrate
npm run db:seed
npm run dev
```

Server runs at:

- API: `http://localhost:3001`

### API docs

Swagger / OpenAPI UI:

- `http://localhost:3001/api-docs`

The seed script creates test users (admin/user/rescue) for quick authentication; see the backend docs for exact credentials.

More backend details (auth, testing, etc.):  
`apps/backend/AUTHENTICATION.md`, `apps/backend/TESTING.md`.

## Web (apps/web)

Tech: Next.js 15, React 19, TypeScript, Tailwind, shadcn/ui, next-intl, react-map-gl / Maplibre.

High-level:

- `app/` – Next.js app router, layouts and routes  
- `components/` – shared UI + shadcn components  
- `lib/` – utilities, Map, API helpers  
- `messages/` + `i18n/` – localization  
- `__tests__/` – unit, integration & e2e tests (Vitest + Playwright)  

To run web in isolation:

```bash
cd apps/web
npm install
npm run dev
```

Architecture, routing, testing and best practices are documented in:

- `docs/web/`

## Mobile (apps/mobile)

Tech: Flutter, Riverpod, feature-first MVVM, Drift for offline caching, Firebase.

### Architecture

- Feature-first MVVM with Riverpod  
- Layers: View → ViewModel (Notifier) → Repository → Service  
- `core/` for shared widgets/utilities  
- Drift backing offline cache (unused legacy tiles today, extendable to segments/reviews/etc.)  

Detailed architecture and Drift-based caching docs:

- `docs/mobile/`

### Running mobile in dev

Inside the dev container (or local environment with Flutter tooling):

```bash
cd apps/mobile
npm run dev
```

The mobile dev script will:

- connect ADB to the host emulator (`adb connect host.docker.internal:5555`)  
- set up port forwarding to backend (`adb reverse tcp:3001 tcp:3001`)  
- start `flutter run` with hot reload (press `r` in the terminal)  

### Backend integration (mobile)

Currently wired:

- **Auth**: `POST /auth/register`, `POST /auth/login`, `GET /api/v1/users/me`  
- **Map & Reviews**:
  - `GET /api/v1/segments`
  - `GET /api/v1/snow-types`
  - `POST /api/v1/segments/{id}/reviews`

Other views (guide updates, rescue, some weather) are in various mock/partial states and not fully integrated yet.

### Firebase & APK builds

For full steps, see `docs/mobile/` and `apps/mobile/README.md`. Rough outline:

```bash
cd apps/mobile
# Firebase CLI
curl -sL https://firebase.tools | bash
firebase login

# FlutterFire CLI
dart pub global activate flutterfire_cli
flutterfire configure --project=snowledge-36e50

# Build debug APK
flutter build apk --debug
```

APK output is under:

```text
apps/mobile/build/app/outputs/flutter-apk/
```

## Testing

### Monorepo (web + backend)

From repo root:

```bash
npm test         # turbo run test --filter=!mobile
npm run test:unit
npm run test:integration
npm run lint
npm run typecheck
npm run build
npm run verify   # full check before PR
```

### Mobile tests

```bash
cd apps/mobile

# Unit & widget tests
flutter test

# Integration tests
flutter test test/integration/

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

Integration test details live in:

- `apps/mobile/test/integration/README.md`

---

For deeper details about a specific app, check:

- `docs/web/` for web architecture  
- `docs/mobile/` for mobile architecture, caching and Dev Container setup  
- `apps/backend/` docs for backend-specific auth, DB and testing information  
