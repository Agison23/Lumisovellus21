import { Request, Response } from 'express';
import { z } from 'zod';
import { AuthService } from '../../services/auth/AuthService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { AuthenticatedRequest } from '../../types';
import {
  loginSchema,
  registerSchema,
  changePasswordSchema,
  updateProfileSchema,
  refreshTokenSchema,
  resetPasswordSchema,
} from '../../middleware/validation';

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const validatedData = registerSchema.parse(req.body);

      const result = await AuthService.register(validatedData);

      ApiResponseHandler.success(res, result, 201, {
        message: 'User registered successfully',
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        ApiResponseHandler.validationError(
          res,
          'Validation failed',
          error.errors
        );
        return;
      }

      if (error instanceof Error) {
        if (error.message.includes('already exists')) {
          ApiResponseHandler.conflict(res, error.message);
          return;
        }
      }

      console.error('Registration error:', error);
      ApiResponseHandler.internalError(res, 'Registration failed');
    }
  }

  static async login(req: Request, res: Response): Promise<void> {
    try {
      const validatedData = loginSchema.parse(req.body);

      const result = await AuthService.login(validatedData);

      ApiResponseHandler.success(res, result, 200, {
        message: 'Login successful',
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        ApiResponseHandler.validationError(
          res,
          'Validation failed',
          error.errors
        );
        return;
      }

      if (error instanceof Error) {
        if (error.message.includes('Invalid email or password')) {
          ApiResponseHandler.unauthorized(res, error.message);
          return;
        }
      }

      console.error('Login error:', error);
      ApiResponseHandler.internalError(res, 'Login failed');
    }
  }

  static async refreshToken(req: Request, res: Response): Promise<void> {
    try {
      const validatedData = refreshTokenSchema.parse(req.body);

      const result = await AuthService.refreshToken(validatedData.refreshToken);

      ApiResponseHandler.success(res, result, 200, {
        message: 'Token refreshed successfully',
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        ApiResponseHandler.validationError(
          res,
          'Validation failed',
          error.errors
        );
        return;
      }

      if (error instanceof Error) {
        if (
          error.message.includes('Invalid refresh token') ||
          error.message.includes('User not found')
        ) {
          ApiResponseHandler.unauthorized(res, error.message);
          return;
        }
      }

      console.error('Token refresh error:', error);
      ApiResponseHandler.internalError(res, 'Token refresh failed');
    }
  }

  static async logout(req: AuthenticatedRequest, res: Response): Promise<void> {
    try {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      await AuthService.logout(req.user.id);

      ApiResponseHandler.success(
        res,
        { message: 'Logged out successfully' },
        200
      );
    } catch (error) {
      console.error('Logout error:', error);
      ApiResponseHandler.internalError(res, 'Logout failed');
    }
  }

  static async changePassword(
    req: AuthenticatedRequest,
    res: Response
  ): Promise<void> {
    try {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const validatedData = changePasswordSchema.parse(req.body);

      await AuthService.changePassword(
        req.user.id,
        validatedData.currentPassword,
        validatedData.newPassword
      );

      ApiResponseHandler.success(
        res,
        { message: 'Password changed successfully' },
        200
      );
    } catch (error) {
      if (error instanceof z.ZodError) {
        ApiResponseHandler.validationError(
          res,
          'Validation failed',
          error.errors
        );
        return;
      }

      if (error instanceof Error) {
        if (error.message.includes('Current password is incorrect')) {
          ApiResponseHandler.unauthorized(res, error.message);
          return;
        }
        if (error.message.includes('User not found')) {
          ApiResponseHandler.notFound(res, error.message);
          return;
        }
      }

      console.error('Change password error:', error);
      ApiResponseHandler.internalError(res, 'Password change failed');
    }
  }

  static async resetPassword(req: Request, res: Response): Promise<void> {
    try {
      const validatedData = resetPasswordSchema.parse(req.body);

      await AuthService.resetPassword(validatedData.email);

      // Always return success for security (don't reveal if email exists)
      ApiResponseHandler.success(
        res,
        {
          message: 'If the email exists, a password reset link has been sent',
        },
        200
      );
    } catch (error) {
      if (error instanceof z.ZodError) {
        ApiResponseHandler.validationError(
          res,
          'Validation failed',
          error.errors
        );
        return;
      }

      console.error('Password reset error:', error);
      ApiResponseHandler.internalError(res, 'Password reset failed');
    }
  }

  static async getProfile(
    req: AuthenticatedRequest,
    res: Response
  ): Promise<void> {
    try {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const user = await AuthService.getUserById(req.user.id);

      if (!user) {
        ApiResponseHandler.notFound(res, 'User not found');
        return;
      }

      ApiResponseHandler.success(res, user, 200);
    } catch (error) {
      console.error('Get profile error:', error);
      ApiResponseHandler.internalError(res, 'Failed to get profile');
    }
  }

  static async updateProfile(
    req: AuthenticatedRequest,
    res: Response
  ): Promise<void> {
    try {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const validatedData = updateProfileSchema.parse(req.body);

      const updatedUser = await AuthService.updateUserProfile(
        req.user.id,
        validatedData
      );

      ApiResponseHandler.success(res, updatedUser, 200, {
        message: 'Profile updated successfully',
      });
    } catch (error) {
      if (error instanceof z.ZodError) {
        ApiResponseHandler.validationError(
          res,
          'Validation failed',
          error.errors
        );
        return;
      }

      if (error instanceof Error) {
        if (error.message.includes('already exists')) {
          ApiResponseHandler.conflict(res, error.message);
          return;
        }
      }

      console.error('Update profile error:', error);
      ApiResponseHandler.internalError(res, 'Profile update failed');
    }
  }

  static async verifyToken(
    req: AuthenticatedRequest,
    res: Response
  ): Promise<void> {
    try {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      ApiResponseHandler.success(
        res,
        {
          valid: true,
          user: req.user,
        },
        200
      );
    } catch (error) {
      console.error('Token verification error:', error);
      ApiResponseHandler.internalError(res, 'Token verification failed');
    }
  }
}
