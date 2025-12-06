# Drift-based caching

This document explains the mobile app’s **Drift-based caching architecture** and how it can be extended to support new offline features (segments, snow types, weather, reviews, etc.). The current implementation is minimal and only used by the old tile cache system, but it serves as a practical example for expanding the approach.

---

## Why this exists

The app is meant to Drift for local persistence. The long-term plan is to support an **offline-first** experience:

- browse segments offline  
- submit reviews when the network is unavailable  
- cache snow types, definitions etc

The existing tile cache is the only implemented example today, but the underlying architecture is intentionally general and reusable.

---

## Architecture

The caching system has three layers:


- Repository Layer ← Read/write files or JSON; enqueue jobs
- Drift DB ← Stores metadata, structured tables
- Jobs + Runner ← Background writes, retries, deduping


The **TileCacheRepository → Jobs → JobRunner → Drift** flow can be copied for any new cached domain.

---

## Core Concepts

### 1. Drift Tables (Metadata layer)

The existing example table:

```
class Tiles extends Table {
  TextColumn get source => text()();
  IntColumn get z => integer()();
  IntColumn get x => integer()();
  IntColumn get y => integer()();
  TextColumn get path => text()();
  IntColumn get size => integer()();
  TextColumn get etag => text().nullable()();
  DateTimeColumn get lastModified => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  Set<Column> get primaryKey => {source, z, x, y};
}
```

A new feature would define its own Drift table, for example:

- `segments`
- `segment_snow_types`
- `reviews_queue`

Each table stores **metadata**, not necessarily entire payloads.

---

### 2. Repository layer

Repositories are responsible for:

- reading cached data
- writing cached data
- queuing writes using JobsDao

Example from `TileCacheRepository`:

```
await jobs.enqueue(
  kind: 'tile.meta',
  dedupeKey: '$s/$z/$x/$y',
  payload: { 'source': s, 'z': z, 'x': x, 'y': y, 'path': f.path },
);
```

For new caches, the repository should:

- save any binary or JSON payloads to disk  
- enqueue a metadata write job  
- read cached content when offline  

This pattern keeps the UI fast.

---

### 3. Jobs & JobRunner (background work)

Jobs are stored in the Drift `jobs` table.  
The `JobRunner`:

- picks due jobs
- handles retries with exponential backoff
- calls a registered handler

Registration example:

```
final r = JobRunner(db, dao);
r.register('tile.meta', (job) => handleTileMeta(job, db));
```

Each new cache type should add a `"kind"` and a handler.

Example future kinds:

- `segments.cache`
- `reviews.queue`
- `snowtypes.cache`

---

## TileProxyServer (example only)

Historically, a small local proxy was used to fetch, cache, and serve raster/DEM tiles:

```
class TileProxyServer {
  Future<Response> _route(Request req) async { ... }
}
```

While no longer used by the app, it demonstrates how caching integrates:

- tries reading from `TileCacheRepository.get()`
- if missing, fetches upstream
- stores the file
- enqueues a metadata write
- client receives bytes regardless of offline/online state

This pattern is reusable: fetch → persist → enqueue metadata → return.

---

## How to extend caching to new features

Below is the minimal checklist to add Drift caching to a new part of the app:

### **1. Create a Drift table**

Example for segments:

```
class Segments extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();       // stored payload
  DateTimeColumn get updatedAt => dateTime()();
  Set<Column> get primaryKey => {id};
}
```

### **2. Add load/store logic in `AppDb`**

- SELECT by ID  
- upsert metadata  
- delete expired rows  

### **3. Create a repository**

- read from Drift  
- store payload to disk (if needed)  
- enqueue a write job  

### **4. Register a job handler**

```
r.register('segments.cache', (job) => handleSegmentsCache(job, db));
```

### **5. Decide when to fetch**

Typical triggers:

- app start
- user opens a segment
- network becomes available

### **6. Serve cached data offline**

Repositories should always:

1. try local cache   
2. if stale or missing, fetch remote  
3. write updates asynchronously

---

## Summary

Although only the legacy tile cache currently uses this infrastructure, the system is designed to be **generic**, **async**, **fault-tolerant**, and **offline-capable**. It can support caching for:

- segments  
- snow definitions  
- review submission queue  
- anything else that benefits from offline access

By following the existing pattern - **Repository → Drift → Jobs → JobRunner** - new offline features can be added without changing the overall architecture.
