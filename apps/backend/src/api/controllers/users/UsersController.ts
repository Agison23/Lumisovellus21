import { Request, Response } from 'express';
import { UsersService } from '../../services/users/UsersService';
import { ApiResponseHandler } from '../../middleware/responseHandler';
import { asyncHandler } from '../../middleware/errorHandler';

export class UsersController {
  private usersService: UsersService;

  constructor() {
    this.usersService = new UsersService();
  }

  updateLocation = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const { deviceId } = req.params;
    const locationData = req.body;
    const ipAddress = `${req.ip},${process.env.PORT || 3001}`;
    
    await this.usersService.updateLocation(deviceId, locationData, ipAddress);
    ApiResponseHandler.success(res, { status: 'ok' });
  });

  updateBattery = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const { deviceId } = req.params;
    const batteryData = req.body;
    
    await this.usersService.updateBattery(deviceId, batteryData);
    ApiResponseHandler.success(res, { status: 'ok' });
  });

  updateRole = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const { deviceId } = req.params;
    const roleData = req.body;
    
    const result = await this.usersService.updateRole(deviceId, roleData);
    ApiResponseHandler.success(res, result);
  });

  getUserRole = asyncHandler(async (req: Request, res: Response): Promise<void> => {
    const { deviceId } = req.params;
    
    const result = await this.usersService.getUserRole(deviceId);
    ApiResponseHandler.success(res, result);
  });
}
