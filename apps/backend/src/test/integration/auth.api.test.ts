import { describe, it, expect, beforeEach, afterAll } from 'vitest';
import request from 'supertest';
import express from 'express';
import { testPrisma } from '../vitest.setup';
import { AuthController } from '../../api/controllers/auth/AuthController';
import { authenticateToken } from '../../api/middleware/auth';
import authRoutes from '../../api/routes/auth/authRoutes';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

// Create test app
const app = express();
app.use(express.json());
app.use('/auth', authRoutes);

describe('Auth API Integration Tests', () => {
  beforeEach(async () => {
    // Clean up users before each test
    await testPrisma.user.deleteMany();
  });

  describe('POST /auth/register', () => {
    it('should register a new user successfully', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@test.com',
        password: 'password123',
        role: 'NORMAL',
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(201);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          user: {
            firstName: userData.firstName,
            lastName: userData.lastName,
            email: userData.email,
            role: userData.role,
          },
          accessToken: expect.any(String),
          refreshToken: expect.any(String),
        },
      });

      // Verify user was created in database
      const createdUser = await testPrisma.user.findUnique({
        where: { email: userData.email },
      });

      expect(createdUser).toBeDefined();
      expect(createdUser?.firstName).toBe(userData.firstName);
    });

    it('should register user with default role', async () => {
      const userData = {
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane.smith@test.com',
        password: 'password123',
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(201);

      expect(response.body.data.user.role).toBe('NORMAL');
    });

    it('should return validation error for invalid email', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'invalid-email',
        password: 'password123',
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(400);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Validation failed',
        },
      });
    });

    it('should return validation error for short password', async () => {
      const userData = {
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@test.com',
        password: '123',
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(400);

      expect(response.body.error.message).toBe('Validation failed');
    });

    it('should return conflict error for existing email', async () => {
      // Create existing user
      await testPrisma.user.create({
        data: {
          id: 'existing-user',
          firstName: 'Existing',
          lastName: 'User',
          email: 'existing@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });

      const userData = {
        firstName: 'New',
        lastName: 'User',
        email: 'existing@test.com',
        password: 'password123',
      };

      const response = await request(app)
        .post('/auth/register')
        .send(userData)
        .expect(409);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'CONFLICT',
        },
      });
    });
  });

  describe('POST /auth/login', () => {
    beforeEach(async () => {
      // Create a test user for login tests
      await testPrisma.user.create({
        data: {
          id: 'login-user-1',
          firstName: 'Login',
          lastName: 'User',
          email: 'login@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should login successfully with valid credentials', async () => {
      const credentials = {
        email: 'login@test.com',
        password: 'password123',
      };

      const response = await request(app)
        .post('/auth/login')
        .send(credentials)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          user: {
            firstName: 'Login',
            lastName: 'User',
            email: 'login@test.com',
            role: 'NORMAL',
          },
          accessToken: expect.any(String),
          refreshToken: expect.any(String),
        },
      });
    });

    it('should return unauthorized for invalid credentials', async () => {
      const credentials = {
        email: 'login@test.com',
        password: 'wrongpassword',
      };

      const response = await request(app)
        .post('/auth/login')
        .send(credentials)
        .expect(401);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
        },
      });
    });

    it('should return validation error for invalid email format', async () => {
      const credentials = {
        email: 'invalid-email',
        password: 'password123',
      };

      const response = await request(app)
        .post('/auth/login')
        .send(credentials)
        .expect(400);

      expect(response.body.error.message).toBe('Validation failed');
    });
  });

  describe('POST /auth/refresh-token', () => {
    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'refresh-user-1',
          firstName: 'Refresh',
          lastName: 'User',
          email: 'refresh@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should refresh token successfully', async () => {
      // Generate a valid refresh token
      const refreshToken = jwt.sign(
        {
          userId: 'refresh-user-1',
          email: 'refresh@test.com',
          role: 'NORMAL',
        },
        process.env.JWT_SECRET || 'test_jwt_secret_key_for_testing_only',
        { expiresIn: '30d' }
      );

      const response = await request(app)
        .post('/auth/refresh-token')
        .send({ refreshToken })
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          accessToken: expect.any(String),
          refreshToken: expect.any(String),
        },
      });
    });

    it('should return unauthorized for invalid refresh token', async () => {
      const response = await request(app)
        .post('/auth/refresh-token')
        .send({ refreshToken: 'invalid.token.here' })
        .expect(401);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
        },
      });
    });

    it('should return validation error for missing refresh token', async () => {
      const response = await request(app)
        .post('/auth/refresh-token')
        .send({})
        .expect(400);

      expect(response.body.error.message).toBe('Validation failed');
    });
  });

  describe('POST /auth/logout', () => {
    let validToken: string;

    beforeEach(async () => {
      // Create a test user and generate token
      await testPrisma.user.create({
        data: {
          id: 'logout-user-1',
          firstName: 'Logout',
          lastName: 'User',
          email: 'logout@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });

      validToken = jwt.sign(
        {
          userId: 'logout-user-1',
          email: 'logout@test.com',
          role: 'NORMAL',
        },
        process.env.JWT_SECRET || 'test_jwt_secret_key_for_testing_only',
        { expiresIn: '7d' }
      );
    });

    it('should logout successfully with valid token', async () => {
      const response = await request(app)
        .post('/auth/logout')
        .set('Authorization', `Bearer ${validToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          message: 'Logged out successfully',
        },
      });
    });

    it('should return unauthorized without token', async () => {
      const response = await request(app).post('/auth/logout').expect(401);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
        },
      });
    });

    it('should return unauthorized with invalid token', async () => {
      const response = await request(app)
        .post('/auth/logout')
        .set('Authorization', 'Bearer invalid.token.here')
        .expect(401);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
        },
      });
    });
  });

  describe('GET /auth/profile', () => {
    let validToken: string;

    beforeEach(async () => {
      // Create a test user and generate token
      await testPrisma.user.create({
        data: {
          id: 'profile-user-1',
          firstName: 'Profile',
          lastName: 'User',
          email: 'profile@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'PREMIUM',
          devId: 'device123',
          ipAddress: '192.168.1.1',
          phoneNumber: '0401234567',
          lowBattery: 0,
        },
      });

      validToken = jwt.sign(
        {
          userId: 'profile-user-1',
          email: 'profile@test.com',
          role: 'PREMIUM',
        },
        process.env.JWT_SECRET || 'test_jwt_secret_key_for_testing_only',
        { expiresIn: '7d' }
      );
    });

    it('should get profile successfully', async () => {
      const response = await request(app)
        .get('/auth/profile')
        .set('Authorization', `Bearer ${validToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          id: 'profile-user-1',
          firstName: 'Profile',
          lastName: 'User',
          email: 'profile@test.com',
          role: 'PREMIUM',
          devId: 'device123',
          ipAddress: '192.168.1.1',
          phoneNumber: '0401234567',
          lowBattery: 0,
        },
      });
    });

    it('should return unauthorized without token', async () => {
      const response = await request(app).get('/auth/profile').expect(401);

      expect(response.body.error.code).toBe('UNAUTHORIZED');
    });
  });

  describe('PUT /auth/profile', () => {
    let validToken: string;

    beforeEach(async () => {
      // Create a test user and generate token
      await testPrisma.user.create({
        data: {
          id: 'update-user-1',
          firstName: 'Update',
          lastName: 'User',
          email: 'update@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });

      validToken = jwt.sign(
        {
          userId: 'update-user-1',
          email: 'update@test.com',
          role: 'NORMAL',
        },
        process.env.JWT_SECRET || 'test_jwt_secret_key_for_testing_only',
        { expiresIn: '7d' }
      );
    });

    it('should update profile successfully', async () => {
      const updateData = {
        firstName: 'Updated',
        lastName: 'Name',
        phoneNumber: '0409876543',
      };

      const response = await request(app)
        .put('/auth/profile')
        .set('Authorization', `Bearer ${validToken}`)
        .send(updateData)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          id: 'update-user-1',
          firstName: 'Updated',
          lastName: 'Name',
          email: 'update@test.com',
          role: 'NORMAL',
          phoneNumber: '0409876543',
        },
      });
    });

    it('should return validation error for invalid email', async () => {
      const updateData = {
        email: 'invalid-email',
      };

      const response = await request(app)
        .put('/auth/profile')
        .set('Authorization', `Bearer ${validToken}`)
        .send(updateData)
        .expect(400);

      expect(response.body.error.message).toBe('Validation failed');
    });
  });

  describe('PUT /auth/change-password', () => {
    let validToken: string;

    beforeEach(async () => {
      // Create a test user and generate token
      await testPrisma.user.create({
        data: {
          id: 'password-user-1',
          firstName: 'Password',
          lastName: 'User',
          email: 'password@test.com',
          password: await bcrypt.hash('oldpassword', 12),
          role: 'NORMAL',
        },
      });

      validToken = jwt.sign(
        {
          userId: 'password-user-1',
          email: 'password@test.com',
          role: 'NORMAL',
        },
        process.env.JWT_SECRET || 'test_jwt_secret_key_for_testing_only',
        { expiresIn: '7d' }
      );
    });

    it('should change password successfully', async () => {
      const passwordData = {
        currentPassword: 'oldpassword',
        newPassword: 'newpassword123',
      };

      const response = await request(app)
        .put('/auth/change-password')
        .set('Authorization', `Bearer ${validToken}`)
        .send(passwordData)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          message: 'Password changed successfully',
        },
      });

      // Verify password was changed
      const user = await testPrisma.user.findUnique({
        where: { id: 'password-user-1' },
      });

      expect(await bcrypt.compare('newpassword123', user?.password || '')).toBe(
        true
      );
    });

    it('should return unauthorized for incorrect current password', async () => {
      const passwordData = {
        currentPassword: 'wrongpassword',
        newPassword: 'newpassword123',
      };

      const response = await request(app)
        .put('/auth/change-password')
        .set('Authorization', `Bearer ${validToken}`)
        .send(passwordData)
        .expect(401);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'UNAUTHORIZED',
        },
      });
    });

    it('should return validation error for short new password', async () => {
      const passwordData = {
        currentPassword: 'oldpassword',
        newPassword: '123',
      };

      const response = await request(app)
        .put('/auth/change-password')
        .set('Authorization', `Bearer ${validToken}`)
        .send(passwordData)
        .expect(400);

      expect(response.body.error.message).toBe('Validation failed');
    });
  });

  describe('GET /auth/verify-token', () => {
    let validToken: string;

    beforeEach(async () => {
      // Create a test user and generate token
      await testPrisma.user.create({
        data: {
          id: 'verify-user-1',
          firstName: 'Verify',
          lastName: 'User',
          email: 'verify@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'ADMIN',
        },
      });

      validToken = jwt.sign(
        {
          userId: 'verify-user-1',
          email: 'verify@test.com',
          role: 'ADMIN',
        },
        process.env.JWT_SECRET || 'test_jwt_secret_key_for_testing_only',
        { expiresIn: '7d' }
      );
    });

    it('should verify token successfully', async () => {
      const response = await request(app)
        .get('/auth/verify-token')
        .set('Authorization', `Bearer ${validToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          valid: true,
          user: {
            id: 'verify-user-1',
            firstName: 'Verify',
            lastName: 'User',
            email: 'verify@test.com',
            role: 'ADMIN',
          },
        },
      });
    });

    it('should return unauthorized without token', async () => {
      const response = await request(app).get('/auth/verify-token').expect(401);

      expect(response.body.error.code).toBe('UNAUTHORIZED');
    });
  });

  describe('POST /auth/reset-password', () => {
    beforeEach(async () => {
      // Create a test user
      await testPrisma.user.create({
        data: {
          id: 'reset-user-1',
          firstName: 'Reset',
          lastName: 'User',
          email: 'reset@test.com',
          password: await bcrypt.hash('password123', 12),
          role: 'NORMAL',
        },
      });
    });

    it('should handle password reset request', async () => {
      const response = await request(app)
        .post('/auth/reset-password')
        .send({ email: 'reset@test.com' })
        .expect(200);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          message: 'If the email exists, a password reset link has been sent',
        },
      });
    });

    it('should handle password reset for non-existent email', async () => {
      const response = await request(app)
        .post('/auth/reset-password')
        .send({ email: 'nonexistent@test.com' })
        .expect(200);

      // Should still return success for security reasons
      expect(response.body.success).toBe(true);
    });

    it('should return validation error for invalid email', async () => {
      const response = await request(app)
        .post('/auth/reset-password')
        .send({ email: 'invalid-email' })
        .expect(400);

      expect(response.body.error.message).toBe('Validation failed');
    });
  });
});
