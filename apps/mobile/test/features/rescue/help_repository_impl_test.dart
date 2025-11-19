import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lumisovellus/features/rescue/data/repositories/help_repository_impl.dart';
import 'package:lumisovellus/features/rescue/data/services/help_service.dart';
import 'package:lumisovellus/features/rescue/domain/models/index.dart';

// Generate mocks for HelpService
@GenerateNiceMocks([MockSpec<HelpService>()])
import 'help_repository_impl_test.mocks.dart';

// TEST ENUM CONSTANTS
const testNeedTypeHealth = HelpNeedType.health;
const testNeedTypeEquipment = HelpNeedType.equipment;
const testNeedTypeLost = HelpNeedType.lost;
const testStatusActive = HelpEventStatus.active;
const testStatusCompleted = HelpEventStatus.completed;
const testStatusCancelled = HelpEventStatus.cancelled;

// TEST CONSTANTS
const testRequestId1 = 'test-request-id-123';
const testRequestId2 = 'test-request-id-456';
const testRequestId789 = 'test-request-id-789';
const testRequestId999 = 'test-request-id-999';
const testRequestId101 = 'test-request-id-101';
const testRequestId202 = 'test-request-id-202';
const testLatitude = 60.123456;
const testLongitude = 24.654321;
const testAccuracy = 5.0;
final testCreatedAt = DateTime(2024, 1, 15, 10, 30);
final testCreatedAt2 = DateTime(2024, 1, 15, 11, 0);
const testRescuerCount3 = 3;
const testRescuerCount2 = 2;
const testNotifiedNearbyCount1 = 1;
const testLocation = Location(
  latitude: testLatitude,
  longitude: testLongitude,
  accuracy: testAccuracy,
);
const testLocationNoAccuracy = Location(
  latitude: testLatitude,
  longitude: testLongitude,
  accuracy: 0.0,
);

void main() {
  late MockHelpService mockService;
  late HelpRepositoryImpl repository;

  setUp(() {
    mockService = MockHelpService();
    repository = HelpRepositoryImpl(mockService);
  });

  group('requestHelp', () {
    test(
      'successfully maps domain request to service request and back',
      () async {
        // Arrange
        const domainRequest = HelpRequest(
          needType: testNeedTypeHealth,
          location: Location(
            latitude: testLatitude,
            longitude: testLongitude,
            accuracy: testAccuracy,
          ),
        );

        final serviceResponse = ServiceHelpResponse(
          requestId: testRequestId1,
          createdAt: testCreatedAt,
          needType: testNeedTypeHealth,
          status: testStatusActive,
          notifiedNearbyCount: testRescuerCount3,
          latitude: testLatitude,
          longitude: testLongitude,
          accuracy: testAccuracy,
        );

        when(
          mockService.requestHelp(any),
        ).thenAnswer((_) async => serviceResponse);

        // Act
        final result = await repository.requestHelp(domainRequest);

        // Assert
        expect(result.requestId, testRequestId1);
        expect(result.needType, testNeedTypeHealth);
        expect(result.status, HelpEventStatus.active);
        expect(result.notifiedNearbyCount, testRescuerCount3);
        expect(result.location.latitude, testLatitude);
        expect(result.location.longitude, testLongitude);
        expect(result.location.accuracy, testAccuracy);

        // Verify service was called with correct service request
        verify(
          mockService.requestHelp(
            argThat(
              predicate<ServiceHelpRequest>(
                (req) =>
                    req.needType == testNeedTypeHealth &&
                    req.latitude == testLatitude &&
                    req.longitude == testLongitude &&
                    req.accuracyMeters == testAccuracy,
              ),
            ),
          ),
        ).called(1);
      },
    );

    test('maps all need types correctly', () async {
      // Test all three need types
      final needTypes = [
        testNeedTypeHealth,
        testNeedTypeEquipment,
        testNeedTypeLost,
      ];

      for (final needType in needTypes) {
        final domainRequest = HelpRequest(
          needType: needType,
          location: const Location(
            latitude: 60.0,
            longitude: 24.0,
            accuracy: 10.0,
          ),
        );

        final serviceResponse = ServiceHelpResponse(
          requestId: 'test-id-$needType',
          createdAt: DateTime(2024, 1, 15),
          needType: needType,
          status: testStatusActive,
          notifiedNearbyCount: testNotifiedNearbyCount1,
          latitude: 60.0,
          longitude: 24.0,
          accuracy: 10.0,
        );

        when(
          mockService.requestHelp(any),
        ).thenAnswer((_) async => serviceResponse);

        final result = await repository.requestHelp(domainRequest);

        expect(result.needType, needType);
        verify(mockService.requestHelp(any)).called(1);
        reset(mockService);
      }
    });

    test('maps all status types correctly', () async {
      // Test all status types
      final statuses = [
        testStatusActive,
        testStatusCompleted,
        testStatusCancelled,
      ];

      for (final status in statuses) {
        const domainRequest = HelpRequest(
          needType: testNeedTypeHealth,
          location: Location(latitude: 60.0, longitude: 24.0, accuracy: 5.0),
        );

        final serviceResponse = ServiceHelpResponse(
          requestId: 'test-id-$status',
          createdAt: DateTime(2024, 1, 15),
          needType: testNeedTypeHealth,
          status: status,
          notifiedNearbyCount: 0,
          latitude: 60.0,
          longitude: 24.0,
          accuracy: 5.0,
        );

        when(
          mockService.requestHelp(any),
        ).thenAnswer((_) async => serviceResponse);

        final result = await repository.requestHelp(domainRequest);

        expect(result.status, status);
        verify(mockService.requestHelp(any)).called(1);
        reset(mockService);
      }
    });

    group('cancelHelpEvent', () {
      test('delegates to service cancelHelp method', () async {
        // Arrange
        const requestId = testRequestId789;
        when(mockService.cancelHelp(any)).thenAnswer((_) async {});

        // Act
        await repository.cancelHelpEvent(requestId);

        // Assert
        verify(mockService.cancelHelp(requestId)).called(1);
        verifyNoMoreInteractions(mockService);
      });
    });

    group('completeHelpEvent', () {
      test('delegates to service completeHelp method', () async {
        // Arrange
        const requestId = testRequestId101;
        when(mockService.completeHelp(any)).thenAnswer((_) async {});

        // Act
        await repository.completeHelpEvent(requestId);

        // Assert
        verify(mockService.completeHelp(requestId)).called(1);
        verifyNoMoreInteractions(mockService);
      });
    });
  });
}
