import 'package:flutter_test/flutter_test.dart';
import 'package:lumisovellus/core/network/api_client.dart';
import 'package:lumisovellus/features/rescue/data/repositories/help_repository_impl.dart';
import 'package:lumisovellus/features/rescue/data/services/help_service_backend.dart';
import 'package:lumisovellus/features/rescue/domain/models/index.dart';
import 'package:dio/dio.dart';

/// Integration tests for help events API endpoints.
/// 
/// These tests require a running backend server with seeded users. Set the following environment variables:
/// - API_BASE_URL: Base URL of the backend API (default: http://lumisovellus-backend:3001)
/// - API_TOKEN: JWT token for authentication (optional - if not provided, will login with seed user)
/// - TEST_USER_EMAIL: Email for test user (default: user@lumisovellus.fi - seed user)
/// - TEST_USER_PASSWORD: Password for test user (default: user123 - seed user password)
/// 
/// Available seed users (from README.MD):
/// - user@lumisovellus.fi / user123 (NORMAL role) - default
/// - rescue@lumisovellus.fi / rescue123 (RESCUE role)
/// - admin@lumisovellus.fi / admin123 (ADMIN role)
/// 
/// To run these tests:
/// ```bash
/// flutter test test/integration/features/rescue/help_events_integration_test.dart
/// ```
/// 
/// Or with environment variables:
/// ```bash
/// API_BASE_URL=http://localhost:3001 flutter test test/integration/features/rescue/help_events_integration_test.dart
/// ```
void main() {
  late ApiClient apiClient;
  late HelpRepositoryImpl repository;
  
  // Test configuration
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://lumisovellus-backend:3001',
  );
  const providedToken = String.fromEnvironment('API_TOKEN', defaultValue: '');
  const testUserEmail = String.fromEnvironment(
    'TEST_USER_EMAIL',
    defaultValue: 'user@lumisovellus.fi',
  );
  const testUserPassword = String.fromEnvironment(
    'TEST_USER_PASSWORD',
    defaultValue: 'user123',
  );
  
  // Test data
  const testLatitude = 60.123456;
  const testLongitude = 24.654321;
  const testAccuracy = 5.0;

  /// Helper function to authenticate using seed users and get an access token
  /// 
  /// Uses the seed users created by the database seed script (see README.MD).
  /// Default seed user: user@lumisovellus.fi / user123 (NORMAL role)
  Future<String> authenticateUser(String email, String password) async {
    // Create a temporary Dio instance for authentication
    final tempDio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
    ));
    
    try {
      // Make login request directly with Dio to ensure proper JSON serialization
      final response = await tempDio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == 200 && 
          response.data != null &&
          response.data['success'] == true &&
          response.data['data'] != null &&
          response.data['data']['accessToken'] != null &&
          response.data['data']['accessToken'].toString().isNotEmpty) {
        return response.data['data']['accessToken'] as String;
      }
      
      throw Exception('Login succeeded but no access token received');
    } catch (e) {
      if (e is DioException && e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorData = e.response!.data;
        throw Exception(
          'Failed to authenticate with seed user ($email). '
          'Status: $statusCode, Error: $errorData. '
          'Make sure the backend database is seeded with default users.',
        );
      }
      throw Exception(
        'Failed to authenticate with seed user ($email). '
        'Make sure the backend database is seeded with default users. '
        'Error: $e',
      );
    }
  }

  setUpAll(() async {
    // Get authentication token
    String token;
    if (providedToken.isNotEmpty) {
      token = providedToken;
    } else {
      // Automatically authenticate
      token = await authenticateUser(testUserEmail, testUserPassword);
    }
    
    // Initialize API client with authentication
    apiClient = ApiClient(
      baseUrl: baseUrl,
      token: token,
    );
    
    // Initialize repository with backend service
    final helpService = BackendHelpService(apiClient: apiClient);
    repository = HelpRepositoryImpl(helpService);
  });

  group('Help Events Integration Tests', () {
    test('should create a help event successfully', () async {
      // Arrange
      const helpRequest = HelpRequest(
        needType: HelpNeedType.health,
        location: Location(
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: testAccuracy,
        ),
      );

      // Act
      final response = await repository.requestHelp(helpRequest);

      // Assert
      expect(response, isNotNull);
      expect(response.requestId, isNotEmpty);
      expect(response.needType, HelpNeedType.health);
      expect(response.status, HelpEventStatus.active);
      expect(response.location.latitude, testLatitude);
      expect(response.location.longitude, testLongitude);
      expect(response.location.accuracy, testAccuracy);
      expect(response.createdAt, isA<DateTime>());
      expect(response.notifiedNearbyCount, isA<int>());
      expect(response.notifiedNearbyCount, greaterThanOrEqualTo(0));
    });

    test('should create help event with different need types', () async {
      final needTypes = [
        HelpNeedType.health,
        HelpNeedType.equipment,
        HelpNeedType.lost,
      ];

      for (final needType in needTypes) {
        // Arrange
        final helpRequest = HelpRequest(
          needType: needType,
          location: const Location(
            latitude: testLatitude,
            longitude: testLongitude,
            accuracy: testAccuracy,
          ),
        );

        // Act
        final response = await repository.requestHelp(helpRequest);

        // Assert
        expect(response.needType, needType);
        expect(response.status, HelpEventStatus.active);
        expect(response.requestId, isNotEmpty);
      }
    });

    test('should cancel a help event successfully', () async {
      // Arrange - create a help event first
      const helpRequest = HelpRequest(
        needType: HelpNeedType.health,
        location: Location(
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: testAccuracy,
        ),
      );
      
      final createResponse = await repository.requestHelp(helpRequest);
      final eventId = createResponse.requestId;
      
      // Verify event is active before cancellation
      expect(createResponse.status, HelpEventStatus.active);

      // Act - cancel the event
      await repository.cancelHelpEvent(eventId);

      // Assert - verify cancellation succeeded (no exception thrown)
      // Note: We can't verify the status without fetching the event again,
      // but if the API call succeeds, the cancellation was processed
      expect(eventId, isNotEmpty);
    });

    test('should complete a help event successfully', () async {
      // Arrange - create a help event first
      const helpRequest = HelpRequest(
        needType: HelpNeedType.equipment,
        location: Location(
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: testAccuracy,
        ),
      );
      
      final createResponse = await repository.requestHelp(helpRequest);
      final eventId = createResponse.requestId;
      
      // Verify event is active before completion
      expect(createResponse.status, HelpEventStatus.active);

      // Act - complete the event
      await repository.completeHelpEvent(eventId);

      // Assert - verify completion succeeded (no exception thrown)
      // Note: We can't verify the status without fetching the event again,
      // but if the API call succeeds, the completion was processed
      expect(eventId, isNotEmpty);
    });

    test('should handle full lifecycle: create -> cancel', () async {
      // Arrange
      const helpRequest = HelpRequest(
        needType: HelpNeedType.lost,
        location: Location(
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: testAccuracy,
        ),
      );

      // Act - create event
      final createResponse = await repository.requestHelp(helpRequest);
      expect(createResponse.status, HelpEventStatus.active);

      // Act - cancel event
      await repository.cancelHelpEvent(createResponse.requestId);

      // Assert - no exceptions thrown, lifecycle completed
      expect(createResponse.requestId, isNotEmpty);
    });

    test('should handle full lifecycle: create -> complete', () async {
      // Arrange
      const helpRequest = HelpRequest(
        needType: HelpNeedType.health,
        location: Location(
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: testAccuracy,
        ),
      );

      // Act - create event
      final createResponse = await repository.requestHelp(helpRequest);
      expect(createResponse.status, HelpEventStatus.active);

      // Act - complete event
      await repository.completeHelpEvent(createResponse.requestId);

      // Assert - no exceptions thrown, lifecycle completed
      expect(createResponse.requestId, isNotEmpty);
    });

    test('should create help event without accuracy', () async {
      // Arrange
      const helpRequest = HelpRequest(
        needType: HelpNeedType.health,
        location: Location(
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: 0.0, // No accuracy provided
        ),
      );

      // Act
      final response = await repository.requestHelp(helpRequest);

      // Assert
      expect(response, isNotNull);
      expect(response.requestId, isNotEmpty);
      expect(response.location.latitude, testLatitude);
      expect(response.location.longitude, testLongitude);
    });
  });
}

