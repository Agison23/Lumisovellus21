import { BaseService } from "../BaseService";
import {
  LocationUpdateRequest,
  BatteryUpdateRequest,
  RoleUpdateRequest,
  UserRole,
} from "../../types";

export class UsersService extends BaseService {
  async updateLocation(
    deviceId: string,
    locationData: LocationUpdateRequest,
    ipAddress: string,
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
          firstName: locationData.firstName || "Mobile User",
          lastName: locationData.lastName || null,
          ipAddress,
          phoneNumber: locationData.phoneNumber || null,
          role: "NORMAL",
        },
      });

      // Get user to get their UUID
      const user = await this.prisma.user.findUnique({
        where: { devId: deviceId },
        select: { id: true },
      });

      if (!user) {
        throw new Error("User not found");
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
    batteryData: BatteryUpdateRequest,
  ): Promise<void> {
    try {
      const lowBattery = batteryData.batteryStatus === "low" ? 1 : 0;

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
    roleData: RoleUpdateRequest,
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
        permissions: roleDataFromDb?.permissions || "",
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
        throw new Error("User not found");
      }

      const roleData = await this.prisma.role.findUnique({
        where: { name: user.role.toLowerCase() },
      });

      return {
        role: user.role.toLowerCase(),
        permissions: roleData?.permissions || "",
      };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
