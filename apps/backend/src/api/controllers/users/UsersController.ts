import { Request, Response } from 'express';
import { UsersService } from '../../services/users/UsersService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';
import { AuthenticatedRequest } from '../../types';
import { AuthService } from '../../services/auth/AuthService';

export class UsersController {
  private usersService: UsersService;

  constructor() {
    this.usersService = new UsersService();
  }

  updateLocation = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { deviceId } = req.params;
      const locationData = req.body;
      const ipAddress = `${req.ip},${process.env.PORT || 3001}`;

      await this.usersService.updateLocation(deviceId, locationData, ipAddress);
      ApiResponseHandler.success(res, { status: 'ok' });
    }
  );

  updateBattery = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { deviceId } = req.params;
      const batteryData = req.body;

      await this.usersService.updateBattery(deviceId, batteryData);
      ApiResponseHandler.success(res, { status: 'ok' });
    }
  );

  updateRole = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { deviceId } = req.params;
      const roleData = req.body;

      const result = await this.usersService.updateRole(deviceId, roleData);
      ApiResponseHandler.success(res, result);
    }
  );

  getUserRole = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { deviceId } = req.params;

      const result = await this.usersService.getUserRole(deviceId);
      ApiResponseHandler.success(res, result);
    }
  );

  getAllUsers = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const users = await this.usersService.getAllUsers();
      ApiResponseHandler.success(res, users);
    }
  );

  getCurrentUser = asyncHandler(
    async (req: AuthenticatedRequest, res: Response): Promise<void> => {
      if (!req.user) {
        ApiResponseHandler.unauthorized(res, 'Authentication required');
        return;
      }

      const user = await AuthService.getUserById(req.user.id);

      if (!user) {
        ApiResponseHandler.notFound(res, 'User not found');
        return;
      }

      ApiResponseHandler.success(res, user);
    }
  );

  updateUser = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { id } = req.params;
      const updateData = req.body;

      const updatedUser = await this.usersService.updateUser(id, updateData);
      ApiResponseHandler.success(res, updatedUser);
    }
  );

  deleteUser = asyncHandler(
    async (req: Request, res: Response): Promise<void> => {
      const { id } = req.params;

      const result = await this.usersService.deleteUser(id);
      ApiResponseHandler.success(res, result);
    }
  );
}
