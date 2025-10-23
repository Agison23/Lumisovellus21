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
        id: user2.id, // Should be ordered by timestamp desc
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

    it('should return 403 for normal user', async () => {
      await request(app)
        .get('/api/v1/help-requests')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(403);
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
});
