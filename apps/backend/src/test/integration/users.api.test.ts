import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import usersRoutes from '../../api/routes/users/usersRoutes';
import jwt from 'jsonwebtoken';

// Create test app
const app = express();
app.use(express.json());
app.use('/', usersRoutes);

// Mock JWT secret for testing
const JWT_SECRET = 'test_jwt_secret_key_for_testing_only';

describe('Users API Integration Tests', () => {
  let authToken: string;
  let adminToken: string;
  let userId: string;
  let adminUserId: string;

  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.userReview.deleteMany();
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

    userId = user.id;
    adminUserId = adminUser.id;

    // Generate JWT tokens
    authToken = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '1h' });
    adminToken = jwt.sign({ userId: adminUser.id }, JWT_SECRET, {
      expiresIn: '1h',
    });
  });

  describe('POST /api/v1/users/:deviceId/location', () => {
    it('should update location for existing user successfully', async () => {
      const deviceId = 'device-123';
      const locationData = {
        firstName: 'Test',
        lastName: 'User',
        phoneNumber: '+1234567890',
        gpsCoord: '65.0123,25.4567',
        timestamp: 1640995200,
      };

      const response = await request(app)
        .post(`/api/v1/users/${deviceId}/location`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(locationData)
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

      // Verify user was updated (only ipAddress and updatedAt are updated for existing users)
      const updatedUser = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(updatedUser?.firstName).toBe('Test'); // Original name, not updated
      expect(updatedUser?.lastName).toBe('User'); // Original name, not updated
      expect(updatedUser?.phoneNumber).toBe(null); // Original phone, not updated
      expect(updatedUser?.ipAddress).toBeTruthy(); // This should be updated

      // Verify location data was created
      const location = await testPrisma.locationData.findFirst({
        where: { userId: updatedUser?.id },
      });

      expect(location).toBeTruthy();
      expect(location?.gpsCoord).toBe(locationData.gpsCoord);
      expect(location?.timestamp).toBe(locationData.timestamp);
    });

    it('should create new user and location data', async () => {
      const deviceId = 'new-device-456';
      const locationData = {
        firstName: 'New',
        lastName: 'User',
        phoneNumber: '+0987654321',
        gpsCoord: '65.1111,25.2222',
        timestamp: 1640995300,
      };

      const response = await request(app)
        .post(`/api/v1/users/${deviceId}/location`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(locationData)
        .expect(200);

      expect(response.body.success).toBe(true);

      // Verify user was created
      const user = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(user).toBeTruthy();
      expect(user?.firstName).toBe(locationData.firstName);
      expect(user?.lastName).toBe(locationData.lastName);
      expect(user?.phoneNumber).toBe(locationData.phoneNumber);
      expect(user?.role).toBe('NORMAL');

      // Verify location data was created
      const location = await testPrisma.locationData.findFirst({
        where: { userId: user?.id },
      });

      expect(location).toBeTruthy();
      expect(location?.gpsCoord).toBe(locationData.gpsCoord);
    });

    it('should return 401 without authentication', async () => {
      const deviceId = 'device-123';
      const locationData = {
        firstName: 'Test',
        gpsCoord: '65.0123,25.4567',
        timestamp: 1640995200,
      };

      await request(app)
        .post(`/api/v1/users/${deviceId}/location`)
        .send(locationData)
        .expect(401);
    });

    it('should return 401 with invalid token', async () => {
      const deviceId = 'device-123';
      const locationData = {
        firstName: 'Test',
        gpsCoord: '65.0123,25.4567',
        timestamp: 1640995200,
      };

      await request(app)
        .post(`/api/v1/users/${deviceId}/location`)
        .set('Authorization', 'Bearer invalid-token')
        .send(locationData)
        .expect(401);
    });
  });

  describe('POST /api/v1/users/:deviceId/battery', () => {
    it('should update battery status to low successfully', async () => {
      const deviceId = 'device-123';
      const batteryData = { batteryStatus: 'low' };

      const response = await request(app)
        .post(`/api/v1/users/${deviceId}/battery`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(batteryData)
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

      // Verify battery status was updated
      const user = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(user?.lowBattery).toBe(1);
    });

    it('should update battery status to normal successfully', async () => {
      const deviceId = 'device-123';
      const batteryData = { batteryStatus: 'normal' };

      const response = await request(app)
        .post(`/api/v1/users/${deviceId}/battery`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(batteryData)
        .expect(200);

      expect(response.body.success).toBe(true);

      // Verify battery status was updated
      const user = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(user?.lowBattery).toBe(0);
    });

    it('should return 401 without authentication', async () => {
      const deviceId = 'device-123';
      const batteryData = { batteryStatus: 'low' };

      await request(app)
        .post(`/api/v1/users/${deviceId}/battery`)
        .send(batteryData)
        .expect(401);
    });
  });

  describe('POST /api/v1/users/:deviceId/role', () => {
    it('should update user role successfully for admin', async () => {
      const deviceId = 'device-123';
      const roleData = { role: 'ADMIN' };

      const response = await request(app)
        .post(`/api/v1/users/${deviceId}/role`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send(roleData)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          role: 'admin',
          permissions: 'read,write,admin',
        },
        meta: {
          timestamp: expect.any(String),
        },
      });

      // Verify role was updated
      const user = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(user?.role).toBe('ADMIN');
    });

    it('should update user role to rescue successfully', async () => {
      const deviceId = 'device-123';
      const roleData = { role: 'RESCUE' };

      const response = await request(app)
        .post(`/api/v1/users/${deviceId}/role`)
        .set('Authorization', `Bearer ${adminToken}`)
        .send(roleData)
        .expect(200);

      expect(response.body.success).toBe(true);
      expect(response.body.data.role).toBe('rescue');
      expect(response.body.data.permissions).toBe('read,write,rescue');
    });

    it('should return 403 for non-admin user', async () => {
      const deviceId = 'device-123';
      const roleData = { role: 'ADMIN' };

      await request(app)
        .post(`/api/v1/users/${deviceId}/role`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(roleData)
        .expect(403);
    });

    it('should return 401 without authentication', async () => {
      const deviceId = 'device-123';
      const roleData = { role: 'ADMIN' };

      await request(app)
        .post(`/api/v1/users/${deviceId}/role`)
        .send(roleData)
        .expect(401);
    });
  });

  describe('GET /api/v1/users/:deviceId/role', () => {
    it('should get user role successfully', async () => {
      const deviceId = 'device-123';

      const response = await request(app)
        .get(`/api/v1/users/${deviceId}/role`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          role: 'normal',
          permissions: 'read',
        },
        meta: {
          timestamp: expect.any(String),
        },
      });
    });

    it('should return 404 for non-existent user', async () => {
      const deviceId = 'non-existent-device';

      await request(app)
        .get(`/api/v1/users/${deviceId}/role`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(500);
    });

    it('should return 401 without authentication', async () => {
      const deviceId = 'device-123';

      await request(app).get(`/api/v1/users/${deviceId}/role`).expect(401);
    });

    it('should return 401 with invalid token', async () => {
      const deviceId = 'device-123';

      await request(app)
        .get(`/api/v1/users/${deviceId}/role`)
        .set('Authorization', 'Bearer invalid-token')
        .expect(401);
    });
  });
});
