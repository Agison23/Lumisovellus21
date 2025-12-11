# Integration Tests

This directory contains integration tests that test the mobile app against a real backend service.

## Prerequisites

1. **Backend server must be running** - The integration tests require a running backend API server
2. **Authentication** - The tests automatically handle authentication by registering/logging in a test user

## Running Integration Tests

### Basic Usage

```bash
# Run all integration tests
flutter test test/integration/

# Run specific integration test file
flutter test test/integration/features/rescue/help_events_integration_test.dart
```

### With Custom Configuration

Use `--dart-define` flags to configure the API base URL, authentication token, and test user credentials:

```bash
flutter test test/integration/features/rescue/help_events_integration_test.dart \
  --dart-define=API_BASE_URL=http://localhost:3001 \
  --dart-define=API_TOKEN=your_jwt_token_here \
  --dart-define=TEST_USER_EMAIL=test@example.com \
  --dart-define=TEST_USER_PASSWORD=testpassword123
```

### Default Configuration

- **API Base URL**: `http://localhost:3001` (default)
- **API Token**: If not provided, tests will automatically register/login a test user
- **Test User Email**: `integration-test@example.com` (default)
- **Test User Password**: `testpassword123` (default)

### Authentication

The integration tests automatically handle authentication:

1. **If `API_TOKEN` is provided**: Uses the provided token directly
2. **If `API_TOKEN` is not provided**: 
   - Attempts to login with the test user credentials
   - If login fails (user doesn't exist), automatically registers a new user
   - Uses the access token from login/register for all API calls

## Help Events Integration Tests

Tests for the help events API endpoints:
- `POST /help/events` - Create a new help event
- `PATCH /help/events/{eventId}` - Update help event status (cancel/complete)

### Test Coverage

The integration tests cover:
1. ✅ Creating help events with different need types (health, equipment, lost)
2. ✅ Canceling help events
3. ✅ Completing help events
4. ✅ Full lifecycle scenarios (create → cancel, create → complete)
5. ✅ Creating events with and without location accuracy

### Example Test Run

```bash
# With automatic authentication (recommended)
flutter test test/integration/features/rescue/help_events_integration_test.dart \
  --dart-define=API_BASE_URL=http://localhost:3001

# With custom test user credentials
flutter test test/integration/features/rescue/help_events_integration_test.dart \
  --dart-define=API_BASE_URL=http://localhost:3001 \
  --dart-define=TEST_USER_EMAIL=my-test@example.com \
  --dart-define=TEST_USER_PASSWORD=mypassword123

# With pre-existing token (skips auto-authentication)
flutter test test/integration/features/rescue/help_events_integration_test.dart \
  --dart-define=API_BASE_URL=http://localhost:3001 \
  --dart-define=API_TOKEN={{an_api_token}}
```

## Notes

- These tests make real API calls to the backend server
- Ensure the backend is running and accessible before running tests
- Tests may create actual data in the backend database
- Consider using a test database or cleaning up test data after tests

