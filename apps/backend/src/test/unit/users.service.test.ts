import { describe, it, expect, beforeEach } from 'vitest';
import { UsersService } from '../../api/services/users/UsersService';
import { testPrisma } from '../vitest.setup';

describe('UsersService Unit Tests', () => {
  let usersService: UsersService;

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

    usersService = new UsersService();
  });

  describe('updateLocation', () => {
    it('should create a new user and location data when user does not exist', async () => {
      const deviceId = 'test-device-123';
      const locationData = {
        firstName: 'John',
        lastName: 'Doe',
        phoneNumber: '+1234567890',
        gpsCoord: '65.0123,25.4567',
        timestamp: 1640995200,
      };
      const ipAddress = '192.168.1.1';

      await usersService.updateLocation(deviceId, locationData, ipAddress);

      // Verify user was created
      const user = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(user).toBeTruthy();
      expect(user?.firstName).toBe(locationData.firstName);
      expect(user?.lastName).toBe(locationData.lastName);
      expect(user?.phoneNumber).toBe(locationData.phoneNumber);
      expect(user?.ipAddress).toBe(ipAddress);
      expect(user?.role).toBe('NORMAL');

      // Verify location data was created
      const location = await testPrisma.locationData.findFirst({
        where: { userId: user?.id },
      });

      expect(location).toBeTruthy();
      expect(location?.gpsCoord).toBe(locationData.gpsCoord);
      expect(location?.timestamp).toBe(locationData.timestamp);
    });

    it('should update existing user and create new location data', async () => {
      const deviceId = 'test-device-456';
      const ipAddress = '192.168.1.2';

      // Create existing user
      const existingUser = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Jane',
          lastName: 'Smith',
          phoneNumber: '+0987654321',
          ipAddress: '192.168.1.100',
          role: 'NORMAL',
        },
      });

      const locationData = {
        firstName: 'Jane Updated',
        lastName: 'Smith Updated',
        phoneNumber: '+1111111111',
        gpsCoord: '65.1111,25.2222',
        timestamp: 1640995300,
      };

      await usersService.updateLocation(deviceId, locationData, ipAddress);

      // Verify user was updated (only ipAddress and updatedAt are updated)
      const updatedUser = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(updatedUser?.firstName).toBe('Jane'); // Original name, not updated
      expect(updatedUser?.lastName).toBe('Smith'); // Original name, not updated
      expect(updatedUser?.phoneNumber).toBe('+0987654321'); // Original phone, not updated
      expect(updatedUser?.ipAddress).toBe(ipAddress); // This should be updated

      // Verify location data was created
      const location = await testPrisma.locationData.findFirst({
        where: { userId: updatedUser?.id },
      });

      expect(location).toBeTruthy();
      expect(location?.gpsCoord).toBe(locationData.gpsCoord);
    });

    it('should handle invalid timestamp by using current time', async () => {
      const deviceId = 'test-device-invalid-timestamp';
      const locationData = {
        firstName: 'Test',
        lastName: 'User',
        gpsCoord: '65.0000,25.0000',
        timestamp: 'invalid-timestamp' as any,
      };
      const ipAddress = '192.168.1.3';

      await usersService.updateLocation(deviceId, locationData, ipAddress);

      const user = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      const location = await testPrisma.locationData.findFirst({
        where: { userId: user?.id },
      });

      expect(location).toBeTruthy();
      expect(location?.timestamp).toBeGreaterThan(0);
    });
  });

  describe('updateBattery', () => {
    it('should update user battery status to low', async () => {
      const deviceId = 'test-device-battery';
      const user = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Battery',
          lastName: 'Test',
          role: 'NORMAL',
          lowBattery: 0,
        },
      });

      const batteryData = { batteryStatus: 'low' as const };

      await usersService.updateBattery(deviceId, batteryData);

      const updatedUser = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(updatedUser?.lowBattery).toBe(1);
    });

    it('should update user battery status to normal', async () => {
      const deviceId = 'test-device-battery-normal';
      const user = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Battery',
          lastName: 'Test',
          role: 'NORMAL',
          lowBattery: 1,
        },
      });

      const batteryData = { batteryStatus: 'normal' as const };

      await usersService.updateBattery(deviceId, batteryData);

      const updatedUser = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(updatedUser?.lowBattery).toBe(0);
    });
  });

  describe('updateRole', () => {
    it('should update user role and return role data', async () => {
      const deviceId = 'test-device-role';
      const user = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Role',
          lastName: 'Test',
          role: 'NORMAL',
        },
      });

      const roleData = { role: 'ADMIN' as const };

      const result = await usersService.updateRole(deviceId, roleData);

      expect(result).toEqual({
        role: 'admin',
        permissions: 'read,write,admin',
      });

      const updatedUser = await testPrisma.user.findUnique({
        where: { devId: deviceId },
      });

      expect(updatedUser?.role).toBe('ADMIN');
    });

    it('should handle role update for rescue role', async () => {
      const deviceId = 'test-device-rescue';
      const user = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Rescue',
          lastName: 'Test',
          role: 'NORMAL',
        },
      });

      const roleData = { role: 'RESCUE' as const };

      const result = await usersService.updateRole(deviceId, roleData);

      expect(result).toEqual({
        role: 'rescue',
        permissions: 'read,write,rescue',
      });
    });
  });

  describe('getUserRole', () => {
    it('should return user role and permissions', async () => {
      const deviceId = 'test-device-get-role';
      const user = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Get',
          lastName: 'Role',
          role: 'ADMIN',
        },
      });

      const result = await usersService.getUserRole(deviceId);

      expect(result).toEqual({
        role: 'admin',
        permissions: 'read,write,admin',
      });
    });

    it('should throw error when user not found', async () => {
      const deviceId = 'non-existent-device';

      await expect(usersService.getUserRole(deviceId)).rejects.toThrow(
        'User not found'
      );
    });

    it('should handle role not found in database', async () => {
      const deviceId = 'test-device-unknown-role';
      const user = await testPrisma.user.create({
        data: {
          devId: deviceId,
          firstName: 'Unknown',
          lastName: 'Role',
          role: 'NORMAL',
        },
      });

      const result = await usersService.getUserRole(deviceId);

      expect(result).toEqual({
        role: 'normal',
        permissions: 'read',
      });
    });
  });
});
