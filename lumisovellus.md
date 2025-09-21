# Lumisovellus System Overview (Current State)

Scope: This document describes the repository and runtime as they exist today. For the target architecture, branching model, quality gates, and all new development, see new-structure.md.

## Repository Layout (As-Is)

```
lumisovellus/
├── src/                        # Web application (React + Node.js)
│   ├── map-app/                # React frontend
│   ├── routers/                # Node.js API routes
│   └── sql/                    # MySQL/MariaDB setup
├── Mobile snowledge/           # Mobile application (hybrid)
│   ├── mobile_app/             # Flutter app (uses WebView + native)
│   └── Server/
│       ├── back_end/           # Python Flask backend (native features)
│       └── front_end/
│           └── Snowledge/      # Flutter Web rescue dashboard
├── documentation/              # Older year-group docs/code (archive)
├── docker-compose.yml          # Container orchestration
├── README.md                   # Additional legacy notes
├── requirements.txt            # Python deps for mobile backend
├── snowledge_env/              # Legacy env/deployment assets
├── vagrant/                    # Legacy VM setup
└── logs/                       # Runtime logs (legacy)
```

Notes:

- Some directories contain spaces (e.g., “Mobile snowledge”). Paths must be quoted in shells and scripts.
- Multiple historical implementations exist under `documentation/` from different student groups.

## Actual Architecture (Today)

There are three separate frontends, two backends, and two non-synchronized databases.

```mermaid
graph TB
  subgraph Clients
    WebBrowser[Web Browser]
    MobileDevice[Flutter Mobile App]
    AdminBrowser[Rescue Admin]
  end

  subgraph Frontends
    ReactWeb[React Web App\nsrc/map-app]
    FlutterMobile[Flutter Mobile\nWebView + Native]
    FlutterAdmin[Flutter Web Admin\nServer/front_end/Snowledge]
  end

  subgraph Backends
    NodeJS[Node.js Backend\nserves React + routes]
    Python[Python Flask\nmobile native features]
  end

  subgraph Databases
    MySQL[(MySQL / MariaDB)]
    SQLite[(SQLite)]
  end

  WebBrowser --> ReactWeb
  AdminBrowser --> FlutterAdmin
  MobileDevice --> FlutterMobile

  ReactWeb --> NodeJS
  FlutterAdmin --> Python
  FlutterMobile -->|WebView loads React pages| NodeJS
  FlutterMobile -->|Native features| Python

  NodeJS --> MySQL
  Python --> SQLite

  classDef warn fill:#ffdddd,stroke:#333,color:#333;
  SQLite:::warn
```

Key facts:

- Mobile app is hybrid: a WebView loads React pages from Node.js; native Flutter features call a separate Python backend.
- Two databases exist: MySQL for web content; SQLite for mobile/rescue features. They do not sync.
- This split causes duplicated functionality and inconsistency risks.

## Frontends (Current)

- React Web (src/map-app): main website pages, also used inside the mobile app’s WebView (e.g., /, /mobiili, /saa, /selitteet).
- Flutter Mobile (Mobile snowledge/mobile_app): hybrid; WebView for map/weather content, native for GPS, help requests, and rescue features.
- Flutter Web Admin (Mobile snowledge/Server/front_end/Snowledge): rescue/admin dashboard at /rescue.

## Backends (Current)

- Node.js: serves React content and provides API endpoints consumed by the React app; connects to MySQL.
- Python Flask: provides endpoints for native mobile/rescue features (GPS, help requests, chat); stores data in SQLite.

Common local ports (legacy):

- Node.js: 3000 (HTTP) / 8443 (HTTPS) depending on setup.
- Flask: 50943 for mobile/rescue APIs.
- MySQL/MariaDB: 3306.

## Data Stores (Current)

- MySQL/MariaDB (Web): segments, snow types, user reviews, updates, etc. SQL resources under `src/sql/`.
- SQLite (Mobile/Rescue): users, roles, location_data, help_requests, nearby_users, etc. Created/managed by the Python backend.

Important: There is no synchronization between these databases in the current system.

## External Services (Integrated Today)

- Firebase (mobile): push notifications/analytics (if configured).
- Google Maps API (web) and/or MapLibre GL.
- Weather API (provider not consistently documented; see `src/map-app/src/weather/`).
- 112 Suomi App integration from the Flutter mobile client.

## Environment Variables (Legacy)

```
# Web / Node.js
APP_ENVIRONMENT=development|production
DATABASE_URL=mysql://user:pass@host:port/db
GOOGLE_MAPS_API_KEY=...
WEATHER_API_KEY=...

# Mobile Backend (Python)
APP_ENVIRONMENT=development|production
SERVER_PORT=50943
DATABASE_PATH=./db/database

# Mobile App (Flutter)
APP_ENVIRONMENT=development|production
SERVER_URL=http://localhost:50943
FIREBASE_CONFIG=path/to/firebase.json
```

Secrets are not stored in the repo; configure them via environment or your platform’s secret store.

## Known Issues and Risks (Current)

- Hybrid mobile approach (WebView + native) creates UX and performance constraints.
- Two backends and two databases increase operational complexity and data inconsistency risk.
- Multiple historical code paths and duplicated functionality.
- Outdated dependencies may exist across projects.
- Limited and uneven automated test coverage.

## What This Doc Is Not

- This document does not prescribe how to fix or modernize the system.
- For the new, unified architecture (single backend, single MySQL, Flutter native, Next.js web, Turbo monorepo, CI quality gates), see new-structure.md.
