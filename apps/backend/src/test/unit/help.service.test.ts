import { describe, it, expect, beforeEach } from 'vitest';
import { HelpService } from '../../api/services/help/HelpService';
import { testPrisma } from '../vitest.setup';

describe('HelpService Unit Tests', () => {
  let helpService: HelpService;

  beforeEach(async () => {
    // Clean up data before each test
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.user.deleteMany();

    helpService = new HelpService();
  });

  describe('createHelpRequest', () => {
    it('should create a new help request and find nearby users', async () => {
      const userId = 'test-user-123';
      
      // Create the user first
      await testPrisma.user.create({
        data: {
          id: userId,
          devId: 'device-123',
          firstName: 'Test',
          lastName: 'User',
          role: 'NORMAL',
        },
      });

      const helpData = {
        userId,
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg' as const,
        chatRoomId: 'room-123',
      };

      // Create some nearby users with recent location data
      const nearbyUser1 = await testPrisma.user.create({
        data: {
          id: 'nearby-user-1',
          devId: 'device-1',
          firstName: 'Nearby',
          lastName: 'User1',
          role: 'NORMAL',
        },
      });

      const nearbyUser2 = await testPrisma.user.create({
        data: {
          id: 'nearby-user-2',
          devId: 'device-2',
          firstName: 'Nearby',
          lastName: 'User2',
          role: 'NORMAL',
        },
      });

      // Create recent location data for nearby users
      const recentTime = Math.floor(Date.now() / 1000) - 3600; // 1 hour ago
      await testPrisma.locationData.createMany({
        data: [
          {
            id: 'loc-1',
            userId: nearbyUser1.id,
            timestamp: recentTime,
            gpsCoord: '65.0200,25.4600',
          },
          {
            id: 'loc-2',
            userId: nearbyUser2.id,
            timestamp: recentTime,
            gpsCoord: '65.0300,25.4700',
          },
        ],
      });

      const result = await helpService.createHelpRequest(helpData);

      expect(result).toEqual({ nearbyUsers: 2 });

      // Verify help request was created
      const helpRequest = await testPrisma.helpRequest.findUnique({
        where: { userId },
      });

      expect(helpRequest).toBeTruthy();
      expect(helpRequest?.timestamp).toBe(helpData.timestamp);
      expect(helpRequest?.gpsCoord).toBe(helpData.gpsCoord);
      expect(helpRequest?.helpType).toBe(helpData.helpType);
      expect(helpRequest?.roomId).toBe(helpData.chatRoomId);

      // Verify nearby users were created
      const nearbyUsers = await testPrisma.nearbyUser.findMany({
        where: { helpRequester: userId },
      });

      expect(nearbyUsers).toHaveLength(2);
      expect(nearbyUsers.every(nu => nu.state === 0)).toBe(true); // Pending state
    });

    it('should update existing help request', async () => {
      const userId = 'test-user-update';
      
      // Create the user first
      await testPrisma.user.create({
        data: {
          id: userId,
          devId: 'device-update',
          firstName: 'Update',
          lastName: 'User',
          role: 'NORMAL',
        },
      });

      const originalHelpRequest = await testPrisma.helpRequest.create({
        data: {
          id: 'help-request-1',
          userId,
          timestamp: 1640995000,
          gpsCoord: '65.0000,25.0000',
          helpType: 'minorHelp',
          roomId: 'room-original',
        },
      });

      const helpData = {
        userId,
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg' as const,
        chatRoomId: 'room-updated',
      };

      const result = await helpService.createHelpRequest(helpData);

      expect(result).toEqual({ nearbyUsers: 0 });

      // Verify help request was updated
      const updatedHelpRequest = await testPrisma.helpRequest.findUnique({
        where: { userId },
      });

      expect(updatedHelpRequest?.timestamp).toBe(helpData.timestamp);
      expect(updatedHelpRequest?.gpsCoord).toBe(helpData.gpsCoord);
      expect(updatedHelpRequest?.helpType).toBe(helpData.helpType);
      expect(updatedHelpRequest?.roomId).toBe(helpData.chatRoomId);
    });

    it('should handle different help types with appropriate distance', async () => {
      const userId = 'test-user-help-type';
      
      // Create the user first
      await testPrisma.user.create({
        data: {
          id: userId,
          devId: 'device-help-type',
          firstName: 'Help',
          lastName: 'Type',
          role: 'NORMAL',
        },
      });

      const helpData = {
        userId,
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'minorHelp' as const,
        chatRoomId: 'room-minor',
      };

      const result = await helpService.createHelpRequest(helpData);

      expect(result).toEqual({ nearbyUsers: 0 });
    });
  });

  describe('getAllHelpRequests', () => {
    it('should return all help requests with user data', async () => {
      // Create test users
      const user1 = await testPrisma.user.create({
        data: {
          id: 'user-1',
          devId: 'device-1',
          firstName: 'User',
          lastName: 'One',
          role: 'NORMAL',
        },
      });

      const user2 = await testPrisma.user.create({
        data: {
          id: 'user-2',
          devId: 'device-2',
          firstName: 'User',
          lastName: 'Two',
          role: 'NORMAL',
        },
      });

      // Create help requests
      await testPrisma.helpRequest.createMany({
        data: [
          {
            id: 'help-1',
            userId: user1.id,
            timestamp: 1640995200,
            gpsCoord: '65.0123,25.4567',
            helpType: 'seriousEmerg',
            roomId: 'room-1',
          },
          {
            id: 'help-2',
            userId: user2.id,
            timestamp: 1640995300,
            gpsCoord: '65.0200,25.4600',
            helpType: 'minorHelp',
            roomId: 'room-2',
          },
        ],
      });

      const result = await helpService.getAllHelpRequests();

      expect(result).toHaveLength(2);
      expect(result[0]).toMatchObject({
        id: user2.id, // Should be ordered by timestamp desc
        userId: user2.id,
        timestamp: 1640995300,
        gpsCoord: '65.0200,25.4600',
        helpType: 'minorHelp',
        roomId: 'room-2',
      });
      expect(result[1]).toMatchObject({
        id: user1.id,
        userId: user1.id,
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg',
        roomId: 'room-1',
      });
    });

    it('should return empty array when no help requests exist', async () => {
      const result = await helpService.getAllHelpRequests();

      expect(result).toEqual([]);
    });
  });

  describe('updateHelpResponse', () => {
    it('should update help response state', async () => {
      const helpGiver = 'helper-user';
      const helpRequester = 'requester-user';

      // Create users first
      await testPrisma.user.createMany({
        data: [
          {
            id: helpGiver,
            devId: 'device-helper',
            firstName: 'Helper',
            lastName: 'User',
            role: 'NORMAL',
          },
          {
            id: helpRequester,
            devId: 'device-requester',
            firstName: 'Requester',
            lastName: 'User',
            role: 'NORMAL',
          },
        ],
      });

      // Create help request first (required for foreign key)
      await testPrisma.helpRequest.create({
        data: {
          id: 'help-request-1',
          userId: helpRequester,
          timestamp: 1640995200,
          gpsCoord: '65.0000,25.0000',
          helpType: 'minorHelp',
          roomId: 'room-1',
        },
      });

      // Create nearby user entry
      await testPrisma.nearbyUser.create({
        data: {
          id: 'nearby-1',
          helpGiver,
          helpRequester,
          state: 0, // Pending
        },
      });

      const responseData = {
        helpGiver,
        helpRequester,
        state: 1, // Accepted
      };

      await helpService.updateHelpResponse(responseData);

      const updatedNearbyUser = await testPrisma.nearbyUser.findUnique({
        where: {
          helpGiver_helpRequester: {
            helpGiver,
            helpRequester,
          },
        },
      });

      expect(updatedNearbyUser?.state).toBe(1);
    });

    it('should handle different response states', async () => {
      const helpGiver = 'helper-user-2';
      const helpRequester = 'requester-user-2';

      // Create users first
      await testPrisma.user.createMany({
        data: [
          {
            id: helpGiver,
            devId: 'device-helper-2',
            firstName: 'Helper',
            lastName: 'User2',
            role: 'NORMAL',
          },
          {
            id: helpRequester,
            devId: 'device-requester-2',
            firstName: 'Requester',
            lastName: 'User2',
            role: 'NORMAL',
          },
        ],
      });

      // Create help request first (required for foreign key)
      await testPrisma.helpRequest.create({
        data: {
          id: 'help-request-2',
          userId: helpRequester,
          timestamp: 1640995200,
          gpsCoord: '65.0000,25.0000',
          helpType: 'minorHelp',
          roomId: 'room-2',
        },
      });

      await testPrisma.nearbyUser.create({
        data: {
          id: 'nearby-2',
          helpGiver,
          helpRequester,
          state: 0,
        },
      });

      const responseData = {
        helpGiver,
        helpRequester,
        state: 2, // Declined
      };

      await helpService.updateHelpResponse(responseData);

      const updatedNearbyUser = await testPrisma.nearbyUser.findUnique({
        where: {
          helpGiver_helpRequester: {
            helpGiver,
            helpRequester,
          },
        },
      });

      expect(updatedNearbyUser?.state).toBe(2);
    });
  });
});
