import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import helpRoutes from '../../api/routes/help/helpRoutes';
import jwt from 'jsonwebtoken';

// Create test app
const app = express();
app.use(express.json());
app.use('/', helpRoutes);

// Mock JWT secret for testing
const JWT_SECRET = 'test_jwt_secret_key_for_testing_only';

describe('Help API Integration Tests', () => {
  let authToken: string;
  let adminToken: string;
  let rescueToken: string;
  let userId: string;

  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.user.deleteMany();
    await testPrisma.role.deleteMany();

    // Create test roles
    await testPrisma.role.createMany({
      skipDuplicates: true,
      data: [
        { id: 'role-normal', name: 'normal', permissions: 'read' },
        { id: 'role-admin', name: 'admin', permissions: 'read,write,admin' },
        { id: 'role-rescue', name: 'rescue', permissions: 'read,write,rescue' },
      ],
    });

    // Create test user
    const user = await testPrisma.user.create({
      data: {
        id: 'test-user-123',
        devId: 'device-123',
        firstName: 'Test',
        lastName: 'User',
        email: 'test@example.com',
        role: 'NORMAL',
      },
    });

    userId = user.id;

    // Create admin user
    const adminUser = await testPrisma.user.create({
      data: {
        id: 'admin-user-123',
        devId: 'device-admin',
        firstName: 'Admin',
        lastName: 'User',
        email: 'admin@example.com',
        role: 'ADMIN',
      },
    });

    // Create rescue user
    const rescueUser = await testPrisma.user.create({
      data: {
        id: 'rescue-user-123',
        devId: 'device-rescue',
        firstName: 'Rescue',
        lastName: 'User',
        email: 'rescue@example.com',
        role: 'RESCUE',
      },
    });

    // Generate JWT tokens
    authToken = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '1h' });
    adminToken = jwt.sign({ userId: adminUser.id }, JWT_SECRET, {
      expiresIn: '1h',
    });
    rescueToken = jwt.sign({ userId: rescueUser.id }, JWT_SECRET, {
      expiresIn: '1h',
    });
  });

  describe('POST /api/v1/help-requests', () => {
    it('should find nearby users within 30km', async () => {
      // Create helper users at different distances
      // Approximate: 1 degree latitude ≈ 111 km
      // At latitude 65°, 1 degree longitude ≈ 48 km

      const centralLat = 65.0;
      const centralLon = 25.0;

      // Create nearby users (within 30km)
      const nearbyUser1 = await testPrisma.user.create({
        data: {
          id: 'nearby-user-1',
          devId: 'device-nearby-1',
          firstName: 'Nearby',
          lastName: 'User1',
          email: 'nearby1@example.com',
          role: 'NORMAL',
        },
      });

      const nearbyUser2 = await testPrisma.user.create({
        data: {
          id: 'nearby-user-2',
          devId: 'device-nearby-2',
          firstName: 'Nearby',
          lastName: 'User2',
          email: 'nearby2@example.com',
          role: 'NORMAL',
        },
      });

      // Create far users (beyond 30km)
      const farUser1 = await testPrisma.user.create({
        data: {
          id: 'far-user-1',
          devId: 'device-far-1',
          firstName: 'Far',
          lastName: 'User1',
          email: 'far1@example.com',
          role: 'NORMAL',
        },
      });

      // Create location data for nearby users (within 30km)
      // ~10km away (≈0.09 degrees latitude)
      await testPrisma.locationData.create({
        data: {
          id: 'location-nearby-1',
          userId: nearbyUser1.id,
          timestamp: Math.floor(Date.now() / 1000), // Current time
          gpsCoord: `${centralLat + 0.09},${centralLon}`, // ~10km north
        },
      });

      // ~20km away (≈0.18 degrees latitude)
      await testPrisma.locationData.create({
        data: {
          id: 'location-nearby-2',
          userId: nearbyUser2.id,
          timestamp: Math.floor(Date.now() / 1000),
          gpsCoord: `${centralLat - 0.18},${centralLon}`, // ~20km south
        },
      });

      // Create location data for far users (beyond 30km)
      // ~50km away (≈0.45 degrees latitude)
      await testPrisma.locationData.create({
        data: {
          id: 'location-far-1',
          userId: farUser1.id,
          timestamp: Math.floor(Date.now() / 1000),
          gpsCoord: `${centralLat + 0.45},${centralLon}`, // ~50km north
        },
      });

      // Create help request at central location
      const helpData = {
        timestamp: Math.floor(Date.now() / 1000),
        gpsCoord: `${centralLat},${centralLon}`,
        helpType: 'help',
        chatRoomId: 'room-test',
      };

      const response = await request(app)
        .post('/api/v1/help-requests')
        .set('Authorization', `Bearer ${authToken}`)
        .send(helpData)
        .expect(200);

      // Verify response
      expect(response.body.success).toBe(true);
      expect(response.body.data.nearbyUsers).toBe(2); // Should find 2 nearby users

      // Verify that nearby user entries were created
      const nearbyUsersInDb = await testPrisma.nearbyUser.findMany({
        where: { helpRequester: userId },
      });

      expect(nearbyUsersInDb).toHaveLength(2);

      // Verify that far users are not included
      const farUsersInDb = nearbyUsersInDb.filter(
        (nu) => nu.helpGiver === farUser1.id
      );
      expect(farUsersInDb).toHaveLength(0);

      // Verify the help request was created
      const helpRequest = await testPrisma.helpRequest.findUnique({
        where: { userId: userId },
      });
      expect(helpRequest).toBeTruthy();
      expect(helpRequest?.gpsCoord).toBe(`${centralLat},${centralLon}`);
    });

    it('should create a help request successfully', async () => {
      const helpData = {
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg',
        chatRoomId: 'room-123',
      };

      const response = await request(app)
        .post('/api/v1/help-requests')
        .set('Authorization', `Bearer ${authToken}`)
        .send(helpData)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          status: 'ok',
          nearbyUsers: expect.any(Number),
        },
        meta: {
          timestamp: expect.any(String),
        },
      });

      // Verify help request was created in database
      const helpRequest = await testPrisma.helpRequest.findUnique({
        where: { userId },
      });

      expect(helpRequest).toBeTruthy();
      expect(helpRequest?.timestamp).toBe(helpData.timestamp);
      expect(helpRequest?.gpsCoord).toBe(helpData.gpsCoord);
      expect(helpRequest?.helpType).toBe(helpData.helpType);
      expect(helpRequest?.roomId).toBe(helpData.chatRoomId);
    });

    it('should update existing help request', async () => {
      // Create initial help request
      await testPrisma.helpRequest.create({
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
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg',
        chatRoomId: 'room-updated',
      };

      const response = await request(app)
        .post('/api/v1/help-requests')
        .set('Authorization', `Bearer ${authToken}`)
        .send(helpData)
        .expect(200);

      expect(response.body.success).toBe(true);

      // Verify help request was updated
      const updatedHelpRequest = await testPrisma.helpRequest.findUnique({
        where: { userId },
      });

      expect(updatedHelpRequest?.timestamp).toBe(helpData.timestamp);
      expect(updatedHelpRequest?.gpsCoord).toBe(helpData.gpsCoord);
      expect(updatedHelpRequest?.helpType).toBe(helpData.helpType);
      expect(updatedHelpRequest?.roomId).toBe(helpData.chatRoomId);
    });

    it('should return 401 without authentication', async () => {
      const helpData = {
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg',
        chatRoomId: 'room-123',
      };

      await request(app)
        .post('/api/v1/help-requests')
        .send(helpData)
        .expect(401);
    });

    it('should return 401 with invalid token', async () => {
      const helpData = {
        timestamp: 1640995200,
        gpsCoord: '65.0123,25.4567',
        helpType: 'seriousEmerg',
        chatRoomId: 'room-123',
      };

      await request(app)
        .post('/api/v1/help-requests')
        .set('Authorization', 'Bearer invalid-token')
        .send(helpData)
        .expect(401);
    });
  });

  describe('GET /api/v1/help-requests', () => {
    it('should get all help requests for admin user', async () => {
      // Create test help requests
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

      await testPrisma.helpRequest.createMany({
        skipDuplicates: true,
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

      const response = await request(app)
        .get('/api/v1/help-requests')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: expect.any(Array),
        meta: {
          timestamp: expect.any(String),
        },
      });

      expect(response.body.data).toHaveLength(2);
      expect(response.body.data[0]).toMatchObject({
        id: 'help-2', // Should be ordered by timestamp desc
        userId: user2.id,
        timestamp: 1640995300,
        gpsCoord: '65.0200,25.4600',
        helpType: 'minorHelp',
        roomId: 'room-2',
      });
    });

    it('should get all help requests for rescue user', async () => {
      const response = await request(app)
        .get('/api/v1/help-requests')
        .set('Authorization', `Bearer ${rescueToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });

    it('should return 401 without authentication', async () => {
      await request(app).get('/api/v1/help-requests').expect(401);
    });
  });

  describe('POST /api/v1/help-responses', () => {
    it('should update help response successfully', async () => {
      const helpGiver = 'helper-user';
      const helpRequester = userId;

      // Create users
      await testPrisma.user.create({
        data: {
          id: helpGiver,
          devId: 'device-helper',
          firstName: 'Helper',
          lastName: 'User',
          role: 'NORMAL',
        },
      });

      // Create help request
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

      const response = await request(app)
        .post('/api/v1/help-responses')
        .set('Authorization', `Bearer ${authToken}`)
        .send(responseData)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          status: 'ok',
        },
        meta: {
          timestamp: expect.any(String),
        },
      });

      // Verify nearby user was updated
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

    it('should return 401 without authentication', async () => {
      const responseData = {
        helpGiver: 'helper',
        helpRequester: 'requester',
        state: 1,
      };

      await request(app)
        .post('/api/v1/help-responses')
        .send(responseData)
        .expect(401);
    });
  });

  describe('GET /api/v1/help-requests/:id/helpers', () => {
    it('should get helpers for a help request successfully', async () => {
      const helpRequestId = 'help-request-helpers';
      const requesterId = 'requester-helpers';

      // Create help requester
      await testPrisma.user.create({
        data: {
          id: requesterId,
          devId: 'device-requester-helpers',
          firstName: 'Help',
          lastName: 'Requester',
          role: 'NORMAL',
        },
      });

      // Create help request
      await testPrisma.helpRequest.create({
        data: {
          id: helpRequestId,
          userId: requesterId,
          timestamp: 1640995200,
          gpsCoord: '65.0123,25.4567',
          helpType: 'seriousEmerg',
          roomId: 'room-helpers',
        },
      });

      // Create helper users
      const helper1 = await testPrisma.user.create({
        data: {
          id: 'helper-api-1',
          devId: 'device-helper-api-1',
          firstName: 'Helper',
          lastName: 'One',
          phoneNumber: '+358401234567',
          role: 'NORMAL',
        },
      });

      const helper2 = await testPrisma.user.create({
        data: {
          id: 'helper-api-2',
          devId: 'device-helper-api-2',
          firstName: 'Helper',
          lastName: 'Two',
          phoneNumber: '+358401234568',
          lowBattery: 1,
          role: 'NORMAL',
        },
      });

      // Create nearby user entries
      await testPrisma.nearbyUser.createMany({
        skipDuplicates: true,
        data: [
          {
            id: 'nearby-api-1',
            helpGiver: helper1.id,
            helpRequester: requesterId,
            state: 0, // Pending
          },
          {
            id: 'nearby-api-2',
            helpGiver: helper2.id,
            helpRequester: requesterId,
            state: 1, // Accepted
          },
        ],
      });

      // Create recent location data for helpers
      const recentTime = Math.floor(Date.now() / 1000) - 3600; // 1 hour ago
      await testPrisma.locationData.createMany({
        skipDuplicates: true,
        data: [
          {
            id: 'loc-api-helper-1',
            userId: helper1.id,
            timestamp: recentTime,
            gpsCoord: '65.0125,25.4570', // Within 30km of help request
          },
          {
            id: 'loc-api-helper-2',
            userId: helper2.id,
            timestamp: recentTime,
            gpsCoord: '65.0128,25.4575', // Within 30km of help request
          },
        ],
      });

      const response = await request(app)
        .get(`/api/v1/help-requests/${helpRequestId}/helpers`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: expect.any(Array),
        meta: {
          timestamp: expect.any(String),
        },
      });

      expect(response.body.data).toHaveLength(2);

      // Should be sorted by state (pending first), then by distance
      expect(response.body.data[0]).toMatchObject({
        userId: helper1.id,
        firstName: 'Helper',
        lastName: 'One',
        phoneNumber: '+358401234567',
        distance: expect.any(Number),
        state: 0, // Pending
        lowBattery: 0,
        lastSeen: expect.any(String),
      });

      expect(response.body.data[1]).toMatchObject({
        userId: helper2.id,
        firstName: 'Helper',
        lastName: 'Two',
        phoneNumber: '+358401234568',
        distance: expect.any(Number),
        state: 1, // Accepted
        lowBattery: 1,
        lastSeen: expect.any(String),
      });
    });

    it('should return empty array for non-existent help request', async () => {
      const response = await request(app)
        .get('/api/v1/help-requests/non-existent-id/helpers')
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });

    it('should allow normal user to access helpers endpoint', async () => {
      const response = await request(app)
        .get('/api/v1/help-requests/some-id/helpers')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data).toEqual([]);
    });

    it('should return 401 without authentication', async () => {
      await request(app)
        .get('/api/v1/help-requests/some-id/helpers')
        .expect(401);
    });
  });
});
