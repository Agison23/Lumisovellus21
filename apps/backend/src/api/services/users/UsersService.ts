import { BaseService } from '../BaseService';
import {
  LocationUpdateRequest,
  BatteryUpdateRequest,
  RoleUpdateRequest,
  UserRole,
} from '../../types';

export class UsersService extends BaseService {
  async updateLocation(
    deviceId: string,
    locationData: LocationUpdateRequest,
    ipAddress: string
  ): Promise<void> {
    try {
      // Create or update user (mobile user)
      await this.prisma.user.upsert({
        where: { devId: deviceId },
        update: {
          ipAddress,
          updatedAt: new Date(),
        },
        create: {
          devId: deviceId,
          firstName: locationData.firstName || 'Mobile User',
          lastName: locationData.lastName || null,
          ipAddress,
          phoneNumber: locationData.phoneNumber || null,
          role: 'NORMAL',
        },
      });

      // Get user to get their UUID
      const user = await this.prisma.user.findUnique({
        where: { devId: deviceId },
        select: { id: true },
      });

      if (!user) {
        throw new Error('User not found');
      }

      const parsedTimestamp = Number.isFinite(Number(locationData.timestamp))
        ? Number(locationData.timestamp)
        : Math.floor(Date.now() / 1000);

      await this.prisma.locationData.create({
        data: {
          id: crypto.randomUUID(),
          timestamp: parsedTimestamp,
          gpsCoord: locationData.gpsCoord,
          user: {
            connect: { id: user.id },
          },
        },
      });
    } catch (error) {
      await this.handleDatabaseError(error);
    }
  }

  async updateBattery(
    deviceId: string,
    batteryData: BatteryUpdateRequest
  ): Promise<void> {
    try {
      const lowBattery = batteryData.batteryStatus === 'low' ? 1 : 0;

      await this.prisma.user.update({
        where: { devId: deviceId },
        data: { lowBattery },
      });
    } catch (error) {
      await this.handleDatabaseError(error);
    }
  }

  async updateRole(
    deviceId: string,
    roleData: RoleUpdateRequest
  ): Promise<UserRole> {
    try {
      const updatedUser = await this.prisma.user.update({
        where: { devId: deviceId },
        data: { role: roleData.role as any }, // Cast to UserRole enum
      });

      // Get role permissions
      const roleDataFromDb = await this.prisma.role.findUnique({
        where: { name: roleData.role },
      });

      return {
        role: updatedUser.role.toLowerCase(),
        permissions: roleDataFromDb?.permissions || '',
      };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getUserRole(deviceId: string): Promise<UserRole> {
    try {
      const user = await this.prisma.user.findUnique({
        where: { devId: deviceId },
      });

      if (!user) {
        throw new Error('User not found');
      }

      const roleData = await this.prisma.role.findUnique({
        where: { name: user.role.toLowerCase() },
      });

      return {
        role: user.role.toLowerCase(),
        permissions: roleData?.permissions || '',
      };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getAllUsers() {
    try {
      const users = await this.prisma.user.findMany({
        select: {
          id: true,
          firstName: true,
          lastName: true,
          email: true,
          role: true,
          phoneNumber: true,
          lowBattery: true,
          createdAt: true,
          updatedAt: true,
        },
        orderBy: {
          createdAt: 'desc',
        },
      });

      return users;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async updateUser(
    userId: string,
    data: Partial<{
      firstName: string;
      lastName: string;
      email: string;
      role: string;
      phoneNumber: string;
    }>
  ) {
    try {
      // Check if user exists first
      const existingUser = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!existingUser) {
        throw new Error('User not found');
      }

      // Build update data object
      const updateData: any = {
        updatedAt: new Date(),
      };

      if (data.firstName !== undefined) updateData.firstName = data.firstName;
      if (data.lastName !== undefined) updateData.lastName = data.lastName;
      if (data.email !== undefined) updateData.email = data.email;
      if (data.role !== undefined) updateData.role = data.role;
      if (data.phoneNumber !== undefined)
        updateData.phoneNumber = data.phoneNumber;

      const updatedUser = await this.prisma.user.update({
        where: { id: userId },
        data: updateData,
        select: {
          id: true,
          firstName: true,
          lastName: true,
          email: true,
          role: true,
          phoneNumber: true,
          lowBattery: true,
          createdAt: true,
          updatedAt: true,
        },
      });

      return updatedUser;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async deleteUser(userId: string) {
    try {
      // Check if user exists first
      const existingUser = await this.prisma.user.findUnique({
        where: { id: userId },
      });

      if (!existingUser) {
        throw new Error('User not found');
      }

      // Delete related data first (in correct order to avoid foreign key constraints)
      await this.prisma.nearbyUser.deleteMany({
        where: {
          OR: [{ helpGiver: userId }, { helpRequester: userId }],
        },
      });

      await this.prisma.helpRequest.deleteMany({
        where: { userId },
      });

      await this.prisma.locationData.deleteMany({
        where: { userId },
      });

      await this.prisma.userReview.deleteMany({
        where: { userId },
      });

      // Finally delete the user
      await this.prisma.user.delete({
        where: { id: userId },
      });

      return { message: 'User deleted successfully' };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
