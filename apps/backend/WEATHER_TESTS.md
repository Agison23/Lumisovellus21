# Weather Service Tests

This document describes the test suite for the weather service implementation.

## Test Files

### Unit Tests

- **Location**: `src/test/unit/weather.service.test.ts`
- **Coverage**: WeatherService class methods

### Integration Tests

- **Location**: `src/test/integration/weather.api.test.ts`
- **Coverage**: Weather API endpoints

## Running the Tests

### Run all tests

```bash
cd apps/backend
npm test
```

### Run only weather tests

```bash
npm test weather
```

### Run unit tests only

```bash
npm run test:unit
```

### Run integration tests only

```bash
npm run test:integration
```

### Run tests in watch mode

```bash
npm run test:watch
```

## Test Coverage

### Unit Tests (WeatherService)

#### `saveWeatherData`

- ✅ Saves weather data successfully with all fields
- ✅ Handles null values correctly
- ✅ Preserves data integrity

#### `getLatestWeather`

- ✅ Returns the most recent weather data
- ✅ Returns null when no data exists
- ✅ Properly orders by timestamp

#### `getWeatherHistory`

- ✅ Returns history with default limit (100)
- ✅ Returns history with custom limit
- ✅ Returns empty array when no data
- ✅ Returns results sorted by timestamp descending

#### `fetchFmiWeatherData`

- ✅ Handles API errors gracefully
- ✅ Returns null when API returns non-ok status
- ✅ Parses XML response correctly

#### `updateWeatherData`

- ✅ Returns null when fetch fails
- ✅ Successfully updates weather data

### Integration Tests (Weather API)

#### `GET /weather`

- ✅ Returns latest weather data
- ✅ Returns null when no weather data exists
- ✅ Returns most recent data when multiple records exist
- ✅ Returns correct response structure
- ✅ Includes meta information

#### `GET /weather/history`

- ✅ Returns weather history with default limit
- ✅ Returns weather history with custom limit
- ✅ Returns empty array when no data
- ✅ Handles invalid limit parameter
- ✅ Returns results sorted by timestamp descending

#### `POST /weather/update`

- ✅ Updates weather data successfully
- ✅ Handles API errors gracefully
- ✅ Handles non-ok API responses

#### API Response Format

- ✅ Returns correct response structure for successful requests
- ✅ Includes meta information
- ✅ Preserves all weather data fields

## Setup Requirements

### Database Setup

1. Apply the migration:

   ```bash
   cd apps/backend
   npm run db:migrate
   ```

2. For test environment:
   ```bash
   npm run test:db:setup
   ```

### Dependencies

Required packages (already installed):

- `vitest` - Testing framework
- `supertest` - HTTP assertions
- `fast-xml-parser` - XML parsing for API
- `@types/node-cron` - Type definitions

## Test Data

The tests create weather records with the following structure:

```typescript
{
  temperature: number | null;
  windSpeed: number | null;
  windDirection: number | null;
  airPressure: number | null;
  snowDepth: number | null;
  relativeHumidity: number | null;
  dewPoint: number | null;
  precipitation: number | null;
  visibility: number | null;
  cloudCover: number | null;
  stationId: string;
  stationName: string;
}
```

## Mocking

The tests use Vitest's mocking capabilities to:

- Mock `fetch` API calls
- Simulate network errors
- Test error handling paths
- Prevent actual API calls during testing

## Test Isolation

Each test is isolated:

- Database is cleaned before each test
- Fresh service instances are created
- No test depends on another

## Expected Test Results

When running the weather tests, you should see:

- All unit tests passing
- All integration tests passing
- No database connection errors
- Proper cleanup after tests

## Troubleshooting

### Issue: Weather model not found

**Solution**: Run Prisma generate

```bash
npm run db:generate
```

### Issue: Migration errors

**Solution**: Reset the database and apply migrations

```bash
npm run db:reset
npm run db:migrate
```

### Issue: TypeScript errors in tests

**Solution**: The Prisma client needs to be regenerated

```bash
npm run db:generate
npm run typecheck
```

## CI/CD Integration

The tests are configured to run in CI/CD pipelines:

- Docker compose for test database
- Automated test setup and teardown
- Coverage reporting available
