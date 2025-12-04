## Configuration Centralization & Firebase Remote Config Plan

### 1. Current State (High-Level)

- **Mobile app – dotenv-based runtime config**
  - `flutter_dotenv` is used in `main.dart` and `core/network/providers.dart` to read `.env` values such as `BACKEND_URL`, `ACCESS_TOKEN`, etc.
  - Example: `BACKEND_URL` is read from dotenv in `core/network/providers.dart` and passed down to API-related services.
- **Mobile app – build-time config**
  - `AppConfig` in `core/config/app_config.dart` provides `useRealBackend` and `apiBaseUrl` using Dart `fromEnvironment` flags at build time.
  - The rescue feature consumes `appConfigProvider`, while other features (e.g. map) still rely on dotenv-based providers.
- **Web & backend**
  - Web app and backend services use Node `dotenv` and environment variables for `BACKEND_URL` and other config.
  - These are mostly server/build-time concerns and can stay as-is; centralization work in this phase is focused on the mobile app.

**Impact:** Configuration logic is fragmented (dotenv vs `AppConfig` vs hard-coded defaults), making it harder to:
- Change environments (dev/stage/prod) consistently.
- Introduce dynamic, remotely configurable values (feature flags, tuning values, rollout switches).
- Reason about a single source of truth for backend URLs and behavior toggles.

---

### 2. Target State & Principles

- **Single configuration abstraction for the mobile app**
  - Introduce a dedicated `AppConfiguration` interface + provider used by all features (map, rescue, etc.).
  - This abstraction is the only way features access config (e.g. `backendBaseUrl`, feature flags, thresholds).
- **Layered configuration sources**
  - **Compile-time / build-time defaults** (Dart `fromEnvironment` / flavor-based values).
  - **Local runtime overrides** from `.env` (for local dev only, optional).
  - **Remote overrides via Firebase Remote Config** (for dynamic control in real deployments).
  - Clear precedence: `RemoteConfig > .env (dev-only) > build-time defaults`.
- **Environment-awareness**
  - Define explicit environments: `dev`, `staging`, `prod` (and possibly `demo`).
  - Use a consistent convention (e.g. build flavor + Firebase project + Remote Config templates per environment).
- **Safe, observable configuration loading**
  - Initialization flow that:
    - Loads base config synchronously (build-time defaults).
    - Asynchronously fetches remote config.
    - Exposes config state (`loading`, `loaded`, `error`) via Riverpod so UI can respond gracefully.

---

### 3. Proposed Architecture (Mobile App)

- **3.1. Core configuration model**
  - Define a Dart model, e.g. `AppConfiguration` (or expand `AppConfig`) with fields such as:
    - `backendBaseUrl`
    - `useRealBackend`
    - `mapTileProxyUrl`
    - `featureFlags` (e.g. `enableRescue`, `enableChat`, `enableNewMapStyle`)
    - Tunables (e.g. timeouts, retry counts, UI thresholds).
  - Provide constructors / helpers:
    - `AppConfiguration.fromDefaults()` – uses `const` defaults & `fromEnvironment`.
    - `AppConfiguration.applyEnvOverrides(dotenv)` – applies `.env` overrides (for dev).
    - `AppConfiguration.applyRemote(RemoteConfigValues)` – applies Firebase overrides.

- **3.2. Centralized provider**
  - Create a `Provider<AsyncValue<AppConfiguration>>` (e.g. `appConfigurationProvider`) in `core/config/`.
  - Initialization sequence:
    1. Start with `AppConfiguration.fromDefaults()` (sync).
    2. If running in dev or if dotenv is present, apply `.env` overrides.
    3. Initialize Firebase (if not already) and fetch Remote Config.
    4. Apply Remote Config overrides and expose the final configuration.
  - Consumers (map, rescue, networking) depend only on this provider, not directly on dotenv or `fromEnvironment`.

- **3.3. Firebase Remote Config integration**
  - Add Firebase (if not already) and configure:
    - Firebase project(s) per environment.
    - Remote Config parameters:
      - `backend_base_url`
      - `use_real_backend`
      - `map_tile_proxy_url`
      - Feature flags, e.g. `feature_rescue_enabled`, `feature_chat_enabled`.
  - Implement a `RemoteConfigService` that:
    - Fetches & activates values with sensible defaults and timeouts.
    - Handles cache durations (e.g. fetch at app start + manual refresh triggers).
    - Maps Remote Config keys to strongly typed fields used by `AppConfiguration`.

- **3.4. Bridging existing usages**
  - **Networking (`core/network/api_client.dart`, `core/network/providers.dart`):**
    - Replace direct `dotenv.env['BACKEND_URL']` with `appConfigurationProvider.backendBaseUrl`.
  - **Rescue feature (`features/rescue/...`):**
    - Ensure `BackendHelpService` and related services take `backendBaseUrl` (or an API client already configured via central config).
    - Replace use of `AppConfig` with the new `AppConfiguration` provider (or extend `AppConfig` to be fully central and remove dotenv usage).
  - **Map feature (`features/map/...`):**
    - Replace any direct dotenv accesses with configuration from `AppConfiguration` (e.g. tile proxy URL, backend endpoints).
  - **Other features:**
    - Audit for any ad-hoc env / config reads and migrate them behind the central configuration provider.

---

### 4. Migration Strategy & Steps

#### 4.1. Design & scaffolding

1. **Design `AppConfiguration` model**
   - Identify which fields are needed now:
     - `backendBaseUrl` (single source for backend URL).
     - `useRealBackend`.
     - Any known map/rescue-specific URLs (e.g. tile proxy base URL).
   - Document naming conventions between Remote Config keys and Dart fields.
2. **Create configuration provider layer**
   - Implement `appConfigurationProvider` in `core/config/`.
   - Provide helper classes/services for reading dotenv and Remote Config.
3. **Integrate Firebase Remote Config**
   - Add Firebase config for mobile (GoogleServices files, etc.).
   - Install and configure `firebase_core` and `firebase_remote_config` packages.
   - Implement a small `RemoteConfigService` wrapper.

#### 4.2. Incremental code migration

4. **Wire networking to central config**
   - Update `core/network/api_client.dart` and `core/network/providers.dart` to take configuration from `appConfigurationProvider` only.
   - Remove direct references to `dotenv.env['BACKEND_URL']` and other env accessors from networking.
5. **Migrate rescue feature**
   - Replace `appConfigProvider` usage with the new `appConfigurationProvider` (or refactor `AppConfig` to be a thin wrapper over `AppConfiguration`).
   - Ensure `BackendHelpService` relies solely on the configured `ApiClient` (which is already tied to centralized config).
6. **Migrate map feature**
   - Find all uses of dotenv or hard-coded URLs in `features/map/**` (e.g. `tile_proxy_server.dart`, `map_style_repository.dart`).
   - Replace them with properties from `AppConfiguration` (e.g. `mapTileProxyUrl`, `backendBaseUrl`).

#### 4.3. Cleanup & hardening

7. **Remove direct dotenv usage from feature code**
   - Limit dotenv usage to:
     - Early bootstrap (if needed, for dev).
     - Configuration layer only.
   - Ensure features never read env variables directly.
8. **Environment-specific behavior**
   - Define a small helper or enum `AppEnvironment { dev, staging, prod }` resolved from build flags.
   - Use it to:
     - Select correct Firebase project.
     - Optionally set different defaults and Remote Config templates.
9. **Add tests & diagnostics**
   - Unit tests for `AppConfiguration` merging logic:
     - Defaults.
     - Dotenv overrides.
     - Remote Config overrides.
   - Simple smoke test or debug screen that shows current configuration values (for QA).

---

### 5. Work Estimate (Rough)

Assumes one experienced Flutter engineer, existing Firebase project, and typical CI/CD setup. Ranges are approximate.

- **5.1. Design & core config scaffolding: _0.5–1 day_**
  - Design `AppConfiguration` model and provider: **0.25–0.5 day**.
  - Implement dotenv- and build-flag-based defaults & merging: **0.25 day**.
  - Basic documentation of config keys & precedence: **0.25 day**.

- **5.2. Firebase Remote Config integration: _1–1.5 days_**
  - Add Firebase to the mobile app (if not yet): **0.5 day** (Android + iOS configs, basic testing).
  - Integrate `firebase_remote_config` and implement `RemoteConfigService`: **0.5 day**.
  - Create initial Remote Config parameters and templates for 1–2 environments: **0.25–0.5 day**.

- **5.3. Wiring networking to centralized config: _0.5–1 day_**
  - Refactor `core/network/api_client.dart` and `providers.dart` to use `AppConfiguration`: **0.5 day**.
  - Manual testing (switching env/base URLs via Remote Config & build flags): **0.25–0.5 day**.

- **5.4. Feature migrations (rescue, map, others): _1–2 days_**
  - Rescue feature migration from `AppConfig` + dotenv to central provider: **0.5 day**.
  - Map feature migration (tile proxy, backend URLs, any other config): **0.5–1 day**.
  - Quick scan of other features for direct env/config usage and refactor: **0.25–0.5 day**.

- **5.5. Cleanup, tests, and documentation: _0.5–1 day_**
  - Unit tests for configuration merging logic: **0.25–0.5 day**.
  - Add a small debug screen / logging for current config: **0.25 day**.
  - Update developer docs / README for configuration workflow: **0.25 day**.

**Total rough estimate:** **3.5–6.5 engineering days** for a first solid iteration.

---

### 6. Risks, Decisions & Open Questions

- **Firebase project & environment alignment**
  - Need confirmation on: one Firebase project with multiple environments vs one project per environment.
  - Decide how CI/CD picks the correct `google-services` files and Remote Config template.
- **Criticality of `backendBaseUrl` in Remote Config**
  - Changing backend URL at runtime can be powerful but risky (e.g. cross-environment traffic, data consistency).
  - Proposal: Use Remote Config for toggling between a small set of known backend URLs, not arbitrary strings; or keep base URL as build-time with only feature flags in Remote Config.
- **Legacy & web/backend alignment**
  - Web and backend will continue to use environment variables; centralization will be primarily at the mobile layer.
  - Longer-term question: Do we want a shared config spec (e.g. JSON schema) that all clients + backend adhere to?

---

### 7. Suggested Next Steps

1. **Confirm scope of Remote Config usage**
   - Decide whether Remote Config will manage only feature flags & non-critical tunables, or also primary URLs like `backendBaseUrl`.
2. **Agree on the `AppConfiguration` surface**
   - Finalize which fields are in v1 (backend URL, tile proxy URL, key feature flags).
3. **Implement the central provider + Remote Config integration**
   - Build the core infra without migrating all features yet.
4. **Incrementally migrate map and rescue features**
   - Start with networking, then map & rescue.
   - Remove direct dotenv usage from feature modules as they are migrated.
5. **Document the new config workflow**
   - Add a short guide for developers explaining:
     - How to add a new config key.
     - How to wire it to Remote Config.
     - How to test different environments locally.

---

### 8. Firebase Remote Config – Console Setup Instructions

These steps assume you already have a Firebase project and basic Firebase setup in the mobile app (Google Services files, `firebase_core` integration). If not, do that first.

#### 8.1. Create or verify Firebase projects per environment

1. **Open Firebase console**
   - Go to `https://console.firebase.google.com` and sign in.
2. **Decide environment strategy**
   - **Option A (recommended)**: One Firebase project per environment, e.g.:
     - `yourapp-dev`
     - `yourapp-staging`
     - `yourapp-prod`
   - **Option B**: Single project with Remote Config conditions for `dev`/`staging`/`prod` (less isolation, more risk).
3. **Create projects if needed**
   - For each environment, click **Add project** and follow the wizard.

#### 8.2. Register the mobile apps in Firebase

1. For each Firebase project (env), open **Project settings → General**.
2. Under **Your apps**, click **Add app** and register:
   - **Android app**: provide package name and (optionally) SHA-1.
   - **iOS app**: provide bundle ID.
3. Download and integrate the config files into your Flutter app:
   - `google-services.json` for Android.
   - `GoogleService-Info.plist` for iOS.
4. Configure your build setup so that the correct Firebase config file is used for each environment (e.g. using flavors or separate build configurations).

#### 8.3. Enable Remote Config and define parameters

1. In the Firebase console, select the desired project (e.g. `yourapp-dev`).
2. In the left navigation, go to **Build → Remote Config**.
3. If prompted, click **Get started** to enable Remote Config.
4. Click **Add parameter** and define the keys you need. Suggested initial set:
   - **`backend_base_url`**
     - Default value: your dev backend URL (e.g. `http://localhost:3001` or a dev server).
   - **`use_real_backend`**
     - Default value: `false` in dev, `true` in staging/prod.
   - **`map_tile_proxy_url`**
     - Default value: your dev tile proxy base URL.
   - **Feature flags** (boolean/string), for example:
     - `feature_rescue_enabled`
     - `feature_chat_enabled`
     - `feature_new_map_style_enabled`
5. For boolean-like values, store them as:
   - `"true"` / `"false"` strings (then parse in the app), or
   - Use Remote Config’s Boolean type if available in your console version.
6. Click **Publish changes** to make the parameters active.

#### 8.4. Configure per-environment values & conditions

1. Repeat the parameter setup for each environment project (dev/staging/prod), or:
   - Use the same parameter keys but change default values to match each environment:
     - `backend_base_url` → dev API vs staging/prod API.
     - Feature flags that are only enabled in some environments.
2. If you use **one Firebase project for all environments**:
   - Use **Conditions** in Remote Config to target different builds or user segments:
     - Example: A condition based on app version or custom user property like `env == "staging"`.
   - Assign different parameter values per condition (e.g. staging base URL for staging builds).

#### 8.5. Testing and iteration

1. **Local dev sanity check**
   - Run the app with Firebase initialized and Remote Config fetching on startup.
   - Temporarily set a trivial parameter (e.g. `welcome_message`) and verify the app reads it correctly.
2. **Verify precedence rules**
   - Confirm that:
     - Build-time defaults work when Remote Config is unreachable.
     - `.env` overrides apply in dev builds as expected.
     - Remote Config values override both when successfully fetched.
3. **Rollback strategy**
   - For risky parameters (e.g. URLs), keep “safe” values published and adjust them gradually.
   - Use feature flags to gate new functionality instead of swapping critical infrastructure values on the fly.

#### 8.6. Operational best practices

1. **Change management**
   - Treat Remote Config changes similarly to code changes:
     - Use descriptions and comments in the console when publishing.
     - For major changes, coordinate with release notes / deployment plans.
2. **Templates / export**
   - Use Remote Config **templates** (export/import JSON) to:
     - Version control critical parameters.
     - Keep dev/staging/prod in sync with small, controlled differences.
3. **Access control**
   - Use Firebase IAM roles so that only specific team members can change Remote Config in production.
4. **Monitoring**
   - For important flags (e.g. `feature_rescue_enabled`), add basic logging/analytics in the app when they change or are evaluated, to aid debugging.

