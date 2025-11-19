import { describe, it, expect, beforeEach, vi } from 'vitest';
import { AuthService } from '../../api/services/auth/AuthService';
import { testPrisma } from '../vitest.setup';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

// Mock environment variables
vi.mock('process', () => ({
  env: {
    JWT_SECRET: 'test_jwt_secret_key_for_testing_only',
    BCRYPT_ROUNDS: '12',
    JWT_EXPIRES_IN: '7d',
    JWT_REFRESH_EXPIRES_IN: '30d',
  },
}));

describe('AuthService Unit Tests', () => {
  beforeEach(async () => {
    // Clean up data before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.user.deleteMany();
  });

  describe('register', () => {
    it('should register a new user successfully', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@test.com',
        password: 'password123',
      };

      const result = await AuthService.register(userData);

      expect(result).toMatchObject({
        user: {
          firstName: userData.firstName,
          lastName: userData.lastName,
          email: userData.email,
          role: 'NORMAL',
        },
      });

      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();

      // Verify user was created in database
      const createdUser = await testPrisma.user.findUnique({
        where: { email: userData.email },
      });

      expect(createdUser).toBeDefined();
      expect(createdUser?.firstName).toBe(userData.firstName);
      expect(createdUser?.password).not.toBe(userData.password); // Should be hashed
    });

    it('should register a user with default role', async () => {
      const userData = {
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@test.com',
        password: 'password123',
      };

      const result = await AuthService.register(userData);

      expect(result.user.role).toBe('NORMAL');
    });

    it('should throw error if user already exists', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@test.com',
        password: 'password123',
      };

      // Create user first
      await testPrisma.user.create({
        data: {
          ...userData,
          password: await bcrypt.hash(userData.password, 12),
        },
      });

      // Try to register again
      await expect(AuthService.register(userData)).rejects.toThrow(
        'User with this email already exists'
      );
    });

    it('should hash password correctly', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@test.com',
        password: 'password123',
      };

      await AuthService.register(userData);

      const user = await testPrisma.user.findUnique({
        where: { email: userData.email },
      });

      expect(user?.password).not.toBe(userData.password);
      expect(
        await bcrypt.compare(userData.password, user?.password || '')
      ).toBe(true);
    });
  });

  describe('login', () => {
    beforeEach(async () => {
      // Create a test user for login tests
      await testPrisma.user.create({
        data: {
          id: 'test-user-1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should login with valid credentials', async () => {
      const credentials = {
        email: 'john.doe@test.com',
        password: 'password123',
      };

      const result = await AuthService.login(credentials);

      expect(result).toMatchObject({
        user: {
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@test.com',
          role: 'NORMAL',
        },
      });

      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });

    it('should throw error for invalid email', async () => {
      const credentials = {
        email: 'nonexistent@test.com',
        password: 'password123',
      };

      await expect(AuthService.login(credentials)).rejects.toThrow(
        'Invalid email or password'
      );
    });

    it('should throw error for invalid password', async () => {
      const credentials = {
        email: 'john.doe@test.com',
        password: 'wrongpassword',
      };

      await expect(AuthService.login(credentials)).rejects.toThrow(
        'Invalid email or password'
      );
    });

    it('should throw error for user without password', async () => {
      // Create user without password
      await testPrisma.user.create({
        data: {
          id: 'test-user-no-password',
          firstName: 'No',
          lastName: 'Password',
          email: 'nopassword@test.com',
          role: 'NORMAL',
        },
      });

      const credentials = {
        email: 'nopassword@test.com',
        password: 'password123',
      };

      await expect(AuthService.login(credentials)).rejects.toThrow(
        'User account not properly configured'
      );
    });
  });

  describe('refreshToken', () => {
    const testJwtSecret =
      process.env.JWT_SECRET ?? 'test_jwt_secret_key_for_testing_only';

    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'test-user-2',
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'jane.smith@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'PREMIUM',
        },
      });
    });

    it('should refresh token successfully', async () => {
      // Generate a valid refresh token
      const user = await testPrisma.user.findUnique({
        where: { email: 'jane.smith@test.com' },
      });

      const refreshToken = jwt.sign(
        {
          userId: user?.id,
          email: user?.email,
          role: user?.role,
        },
        testJwtSecret,
        { expiresIn: '30d' }
      );

      const result = await AuthService.refreshToken(refreshToken);

      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });

    it('should throw error for invalid refresh token', async () => {
      const invalidToken = 'invalid.token.here';

      await expect(AuthService.refreshToken(invalidToken)).rejects.toThrow(
        'Invalid refresh token'
      );
    });

    it('should throw error for non-existent user', async () => {
      // First create a user to get a valid token, then delete the user
      await testPrisma.user.create({
        data: {
          id: 'temp-user-for-token',
          firstName: 'Temp',
          lastName: 'User',
          email: 'temp@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });

      const refreshToken = jwt.sign(
        {
          userId: 'temp-user-for-token',
          email: 'temp@test.com',
          role: 'NORMAL',
        },
        testJwtSecret,
        { expiresIn: '30d' }
      );

      // Delete the user to make the token invalid
      await testPrisma.user.delete({
        where: { id: 'temp-user-for-token' },
      });

      await expect(AuthService.refreshToken(refreshToken)).rejects.toThrow(
        'Invalid refresh token'
      );
    });
  });

  describe('changePassword', () => {
    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'test-user-3',
          firstName: 'Bob',
          lastName: 'Johnson',
          email: 'bob.johnson@test.com',
          password: await bcrypt.hash('oldpassword', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should change password successfully', async () => {
      await AuthService.changePassword(
        'test-user-3',
        'oldpassword',
        'newpassword123'
      );

      const user = await testPrisma.user.findUnique({
        where: { id: 'test-user-3' },
      });

      expect(await bcrypt.compare('newpassword123', user?.password || '')).toBe(
        true
      );
    });

    it('should throw error for incorrect current password', async () => {
      await expect(
        AuthService.changePassword(
          'test-user-3',
          'wrongpassword',
          'newpassword123'
        )
      ).rejects.toThrow('Current password is incorrect');
    });

    it('should throw error for non-existent user', async () => {
      await expect(
        AuthService.changePassword(
          'non-existent-user',
          'oldpassword',
          'newpassword123'
        )
      ).rejects.toThrow('User not found');
    });
  });

  describe('getUserById', () => {
    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'test-user-4',
          firstName: 'Alice',
          lastName: 'Brown',
          email: 'alice.brown@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'ADMIN',
          devId: 'device123',
          ipAddress: '192.168.1.1',
          phoneNumber: '0401234567',
          lowBattery: 1,
        },
      });
    });

    it('should get user by id successfully', async () => {
      const user = await AuthService.getUserById('test-user-4');

      expect(user).toMatchObject({
        id: 'test-user-4',
        firstName: 'Alice',
        lastName: 'Brown',
        email: 'alice.brown@test.com',
        role: 'ADMIN',
        devId: 'device123',
        ipAddress: '192.168.1.1',
        phoneNumber: '0401234567',
        lowBattery: 1,
      });

      expect(user?.createdAt).toBeDefined();
      expect(user?.updatedAt).toBeDefined();
    });

    it('should return null for non-existent user', async () => {
      const user = await AuthService.getUserById('non-existent-user');

      expect(user).toBeNull();
    });
  });

  describe('updateUserProfile', () => {
    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'test-user-5',
          firstName: 'Charlie',
          lastName: 'Wilson',
          email: 'charlie.wilson@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should update user profile successfully', async () => {
      const updateData = {
        firstName: 'Charles',
        lastName: 'Wilson Jr.',
        phoneNumber: '0409876543',
      };

      const updatedUser = await AuthService.updateUserProfile(
        'test-user-5',
        updateData
      );

      expect(updatedUser).toMatchObject({
        id: 'test-user-5',
        firstName: 'Charles',
        lastName: 'Wilson Jr.',
        email: 'charlie.wilson@test.com',
        role: 'NORMAL',
        phoneNumber: '0409876543',
      });

      expect(updatedUser?.updatedAt).toBeDefined();
    });

    it('should update email successfully', async () => {
      const updateData = {
        email: 'new.email@test.com',
      };

      const updatedUser = await AuthService.updateUserProfile(
        'test-user-5',
        updateData
      );

      expect(updatedUser?.email).toBe('new.email@test.com');
    });
  });

  describe('resetPassword', () => {
    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'test-user-6',
          firstName: 'David',
          lastName: 'Lee',
          email: 'david.lee@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should handle password reset for existing user', async () => {
      // Should not throw error even though implementation is not complete
      await expect(
        AuthService.resetPassword('david.lee@test.com')
      ).resolves.not.toThrow();
    });

    it('should handle password reset for non-existent user', async () => {
      // Should not throw error for security reasons
      await expect(
        AuthService.resetPassword('nonexistent@test.com')
      ).resolves.not.toThrow();
    });
  });
});
