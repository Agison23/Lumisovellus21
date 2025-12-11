# Running Tests

This repository contains both unit/widget tests and integration tests for the mobile app.

## Unit & Widget Tests

```
cd apps/mobile
flutter test
```

Run a specific file:

```
flutter test test/features/map/reviews_service_test.dart
```

## Integration Tests

Integration tests are documented separately.  
For full instructions, see:

- [README.md](../../apps/mobile/test/integration/README.md)

To run them:

```
flutter test test/integration/
```

## Coverage

Generate coverage:

```
flutter test --coverage
```

This creates:
```
coverage/lcov.info
```

Convert to HTML (requires `lcov` installed):

```
genhtml coverage/lcov.info -o coverage/html
```

Open:
```
coverage/html/index.html
```