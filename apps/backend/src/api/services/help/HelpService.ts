import { BaseService } from '../BaseService';
import {
  HelpRequestCreate,
  HelpRequest,
  HelpResponseUpdate,
  NearbyUser,
  HelpRequestHelper,
} from '../../types';

export class HelpService extends BaseService {
  /**
   * Calculate distance between two GPS coordinates using Haversine formula
   * @param lat1 Latitude of first point
   * @param lon1 Longitude of first point
   * @param lat2 Latitude of second point
   * @param lon2 Longitude of second point
   * @returns Distance in kilometers
   */
  private calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
  ): number {
    const R = 6371; // Earth's radius in kilometers
    const dLat = this.toRadians(lat2 - lat1);
    const dLon = this.toRadians(lon2 - lon1);

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRadians(lat1)) *
        Math.cos(this.toRadians(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  private toRadians(degrees: number): number {
    return degrees * (Math.PI / 180);
  }

  /**
   * Parse GPS coordinates from string format "lat,lon"
   * @param gpsCoord GPS coordinate string
   * @returns Object with latitude and longitude
   */
  private parseGPSCoordinates(gpsCoord: string): { lat: number; lon: number } {
    const [lat, lon] = gpsCoord
      .split(',')
      .map((coord) => parseFloat(coord.trim()));
    return { lat, lon };
  }

  /**
   * Find nearby users based on GPS coordinates and distance
   * @param requesterGPS GPS coordinates of help requester
   * @param maxDistance Maximum distance in kilometers
   * @param timeWindow Time window in seconds (default: 2 hours)
   * @returns Array of nearby users with distance information
   */
  private async findNearbyUsers(
    requesterGPS: string,
    maxDistance: number,
    timeWindow: number = 7200
  ): Promise<Array<{ userId: string; distance: number; user: any }>> {
    const requesterCoords = this.parseGPSCoordinates(requesterGPS);
    const timeThreshold = Math.floor(Date.now() / 1000) - timeWindow;

    // Get all users with recent location data
    const recentUsers = await this.prisma.locationData.findMany({
      where: {
        timestamp: { gte: timeThreshold },
      },
      include: {
        user: true,
      },
      orderBy: {
        timestamp: 'desc',
      },
    });

    const nearbyUsers: Array<{ userId: string; distance: number; user: any }> =
      [];

    for (const locationData of recentUsers) {
      try {
        const userCoords = this.parseGPSCoordinates(locationData.gpsCoord);
        const distance = this.calculateDistance(
          requesterCoords.lat,
          requesterCoords.lon,
          userCoords.lat,
          userCoords.lon
        );

        if (distance <= maxDistance) {
          nearbyUsers.push({
            userId: locationData.userId,
            distance: Math.round(distance * 100) / 100, // Round to 2 decimal places
            user: locationData.user,
          });
        }
      } catch (error) {
        // Skip invalid GPS coordinates
        console.warn(
          `Invalid GPS coordinates for user ${locationData.userId}: ${locationData.gpsCoord}`
        );
      }
    }

    // Sort by distance (closest first)
    return nearbyUsers.sort((a, b) => a.distance - b.distance);
  }

  async createHelpRequest(
    helpData: HelpRequestCreate & { userId: string }
  ): Promise<{ nearbyUsers: number; nearbyUsersList?: NearbyUser[] }> {
    try {
      const userId = helpData.userId;

      // Create or update help request
      await this.prisma.helpRequest.upsert({
        where: { userId: userId },
        update: {
          timestamp: parseInt(helpData.timestamp.toString()),
          gpsCoord: helpData.gpsCoord,
          helpType: helpData.helpType,
          roomId: helpData.chatRoomId,
          updatedAt: new Date(),
        },
        create: {
          id: crypto.randomUUID(),
          userId: userId,
          timestamp: parseInt(helpData.timestamp.toString()),
          gpsCoord: helpData.gpsCoord,
          helpType: helpData.helpType,
          roomId: helpData.chatRoomId,
        },
      });

      // Set nearby radius to 30km for all help types
      const maxDistance = 30; // 30km radius for all help requests

      // Find nearby users using proper distance calculation
      const nearbyUsers = await this.findNearbyUsers(
        helpData.gpsCoord,
        maxDistance,
        7200 // 2 hours
      );

      // Filter out the help requester themselves
      const otherNearbyUsers = nearbyUsers.filter(
        (user) => user.userId !== userId
      );

      // Create nearby user entries for help coordination
      const createdNearbyUsers: NearbyUser[] = [];
      for (const nearbyUser of otherNearbyUsers) {
        try {
          await this.prisma.nearbyUser.create({
            data: {
              id: crypto.randomUUID(),
              helpGiver: nearbyUser.userId,
              helpRequester: userId,
              state: 0, // Pending
            },
          });
          createdNearbyUsers.push({
            userId: nearbyUser.userId,
            distance: nearbyUser.distance,
          });
        } catch (error) {
          // Ignore duplicate entries
          console.warn(`Failed to create help notification: ${error}`);
        }
      }

      return {
        nearbyUsers: createdNearbyUsers.length,
        nearbyUsersList: createdNearbyUsers,
      };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getAllHelpRequests(): Promise<HelpRequest[]> {
    try {
      const helpRequests = await this.prisma.helpRequest.findMany({
        orderBy: {
          timestamp: 'desc',
        },
        include: {
          user: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
              phoneNumber: true,
              lowBattery: true,
            },
          },
        },
      });

      return helpRequests;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async updateHelpResponse(
    responseData: HelpResponseUpdate
  ): Promise<{ status: string }> {
    try {
      await this.prisma.nearbyUser.update({
        where: {
          helpGiver_helpRequester: {
            helpGiver: responseData.helpGiver,
            helpRequester: responseData.helpRequester,
          },
        },
        data: {
          state: responseData.state,
          updatedAt: new Date(),
        },
      });

      return { status: 'ok' };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  /**
   * Get users who can help with a specific help request
   * @param helpRequestId The ID of the help request
   * @returns Array of users who can help with their status and distance
   */
  async getHelpRequestHelpers(
    helpRequestId: string
  ): Promise<HelpRequestHelper[]> {
    try {
      // First, get the help request to verify it exists
      const helpRequest = await this.prisma.helpRequest.findUnique({
        where: { id: helpRequestId },
        include: {
          user: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
            },
          },
        },
      });

      if (!helpRequest) {
        return []; // Return empty array for non-existent help request
      }

      // Get all nearby users for this help request
      const nearbyUsers = await this.prisma.nearbyUser.findMany({
        where: { helpRequester: helpRequest.userId },
        include: {
          giver: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
              phoneNumber: true,
              lowBattery: true,
            },
          },
        },
        orderBy: {
          createdAt: 'asc', // Order by when they were notified
        },
      });

      // Get the most recent location data for each helper to calculate distance
      const helperIds = nearbyUsers.map((nu) => nu.helpGiver);
      const recentLocations = await this.prisma.locationData.findMany({
        where: {
          userId: { in: helperIds },
          timestamp: { gte: Math.floor(Date.now() / 1000) - 7200 }, // Last 2 hours
        },
        orderBy: {
          timestamp: 'desc',
        },
        distinct: ['userId'], // Get only the most recent location per user
      });

      // Create a map of user ID to their most recent location
      const locationMap = new Map();
      recentLocations.forEach((loc) => {
        locationMap.set(loc.userId, loc);
      });

      // Calculate distances and format response
      const helpers = nearbyUsers.map((nearbyUser) => {
        const user = nearbyUser.giver;
        const recentLocation = locationMap.get(user.id);

        let distance = 0;
        if (recentLocation) {
          try {
            const requesterCoords = this.parseGPSCoordinates(
              helpRequest.gpsCoord
            );
            const helperCoords = this.parseGPSCoordinates(
              recentLocation.gpsCoord
            );
            distance = this.calculateDistance(
              requesterCoords.lat,
              requesterCoords.lon,
              helperCoords.lat,
              helperCoords.lon
            );
          } catch (error) {
            console.warn(`Invalid GPS coordinates for user ${user.id}`);
            distance = -1; // Indicate invalid coordinates
          }
        } else {
          distance = -1; // No recent location data
        }

        return {
          userId: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          phoneNumber: user.phoneNumber,
          distance: Math.round(distance * 100) / 100, // Round to 2 decimal places
          state: nearbyUser.state,
          lowBattery: user.lowBattery,
          lastSeen: recentLocation
            ? new Date(recentLocation.timestamp * 1000)
            : new Date(0),
        };
      });

      // Sort by state (pending first), then by distance
      return helpers.sort((a, b) => {
        if (a.state !== b.state) {
          return a.state - b.state; // 0 (pending) comes first
        }
        if (a.distance === -1 && b.distance === -1) return 0;
        if (a.distance === -1) return 1; // No location data goes last
        if (b.distance === -1) return -1;
        return a.distance - b.distance; // Closer users first
      });
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
