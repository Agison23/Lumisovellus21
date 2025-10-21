import { BaseService } from '../BaseService';
import {
  HelpRequestCreate,
  HelpRequest,
  HelpResponseUpdate,
} from '../../types';

export class HelpService extends BaseService {
  async createHelpRequest(
    helpData: HelpRequestCreate & { userId: string }
  ): Promise<{ nearbyUsers: number }> {
    try {
      // Use the authenticated user's ID directly
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

      // Find nearby users (simplified version of the legacy logic)
      const maxDistance = helpData.helpType === 'seriousEmerg' ? 1 : 3;

      // Get recent users within time window
      const twoHoursAgo = Math.floor(Date.now() / 1000) - 7200;
      const nearbyUsers = await this.prisma.locationData.findMany({
        where: {
          timestamp: { gte: twoHoursAgo },
          userId: { not: userId },
        },
        include: {
          user: true,
        },
      });

      // Create nearby user entries for help coordination
      for (const nearbyUser of nearbyUsers) {
        try {
          await this.prisma.nearbyUser.create({
            data: {
              id: crypto.randomUUID(),
              helpGiver: nearbyUser.userId,
              helpRequester: userId,
              state: 0, // Pending
            },
          });
        } catch (error) {
          // Ignore duplicate entries
        }
      }

      return { nearbyUsers: nearbyUsers.length };
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getAllHelpRequests(): Promise<HelpRequest[]> {
    try {
      const helpRequests = await this.prisma.helpRequest.findMany({
        include: {
          user: true,
        },
        orderBy: { timestamp: 'desc' },
      });

      return helpRequests.map((request) => ({
        id: request.userId,
        userId: request.userId,
        timestamp: request.timestamp,
        gpsCoord: request.gpsCoord,
        helpType: request.helpType,
        roomId: request.roomId,
        createdAt: request.createdAt,
        updatedAt: request.updatedAt,
      }));
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async updateHelpResponse(responseData: HelpResponseUpdate): Promise<void> {
    try {
      await this.prisma.nearbyUser.update({
        where: {
          helpGiver_helpRequester: {
            helpGiver: responseData.helpGiver,
            helpRequester: responseData.helpRequester,
          },
        },
        data: { state: parseInt(responseData.state.toString()) },
      });
    } catch (error) {
      await this.handleDatabaseError(error);
    }
  }
}
