import { randomUUID } from 'crypto';
import { BaseService } from '../BaseService';
import {
  HelpEventCreate,
  HelpEventLocation,
  HelpEventParticipation,
  HelpEventRescueeView,
  HelpEventRescuerView,
  HelpEventStatus,
  HelpEventSummary,
  HelpNeedType,
  HelpRequest,
  Rescuee,
} from '../../types';

type NearbyUserWithLocation = {
  id: string;
  helpGiver: string;
  helpRequester: string;
  state: number;
  acceptedAt: Date | null;
  acceptedLatitude: number | null;
  acceptedLongitude: number | null;
  acceptedAccuracy: number | null;
  updatedAt: Date;
};

export class HelpService extends BaseService {
  private readonly MAX_DISTANCE_KM = 30;
  private readonly DEFAULT_LOCATION_ACCURACY = 50;

  private toRadians(degrees: number): number {
    return degrees * (Math.PI / 180);
  }

  private calculateDistance(
    lat1: number,
    lon1: number,
    lat2: number,
    lon2: number
  ): number {
    const R = 6371;
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

  private parseGPSCoordinates(gpsCoord: string): { lat: number; lon: number } {
    const [lat, lon] = gpsCoord
      .split(',')
      .map((coord) => parseFloat(coord.trim()));
    return { lat, lon };
  }

  private normalizeNeedType(value: string): HelpNeedType {
    switch (value) {
      case 'seriousEmerg':
      case 'health':
        return 'health';
      case 'minorHelp':
      case 'equipment':
        return 'equipment';
      case 'lost':
      case 'help':
        return 'lost';
      default:
        return 'equipment';
    }
  }

  private toHelpEventLocation(
    gpsCoord: string,
    accuracy?: number | null
  ): HelpEventLocation {
    const { lat, lon } = this.parseGPSCoordinates(gpsCoord);
    return {
      latitude: lat,
      longitude: lon,
      accuracy: accuracy ?? this.DEFAULT_LOCATION_ACCURACY,
    };
  }

  private mapBatteryLevel(lowBattery: number | null | undefined): number | null {
    if (typeof lowBattery === 'number') {
      return lowBattery > 0 ? 15 : 85;
    }
    return null;
  }

  private async findRecentLocation(userId: string) {
    return this.prisma.locationData.findFirst({
      where: { userId },
      orderBy: { timestamp: 'desc' },
    });
  }

  private async buildRescuee(helpRequest: HelpRequest): Promise<Rescuee> {
    const fallbackLocation = this.toHelpEventLocation(
      helpRequest.gpsCoord,
      helpRequest.locationAccuracy
    );

    const [user, recentLocation] = await Promise.all([
      this.prisma.user.findUnique({
        where: { id: helpRequest.userId },
        select: {
          id: true,
          lowBattery: true,
        },
      }),
      this.findRecentLocation(helpRequest.userId),
    ]);

    const location =
      recentLocation !== null
        ? this.toHelpEventLocation(recentLocation.gpsCoord, null)
        : fallbackLocation;

    return {
      userId: helpRequest.userId,
      needType: this.normalizeNeedType(helpRequest.helpType),
      userStatus: {
        location,
        batteryLevel: this.mapBatteryLevel(user?.lowBattery ?? null),
      },
    };
  }

  private async buildAcceptedRescuers(
    helpRequest: HelpRequest
  ): Promise<HelpEventParticipation[]> {
    const participants = await this.prisma.nearbyUser.findMany({
      where: { helpRequester: helpRequest.userId, state: 1 },
      orderBy: { acceptedAt: 'asc' },
    });

    return Promise.all(
      participants.map(async (participant) => {
        const castParticipant = participant as NearbyUserWithLocation;
        let location =
          this.formatLocationFromNearbyUser(castParticipant) ?? null;

        if (!location) {
          const recentLocation = await this.findRecentLocation(
            castParticipant.helpGiver
          );
          if (recentLocation) {
            location = this.toHelpEventLocation(recentLocation.gpsCoord, null);
          }
        }

        return {
          acceptanceId: castParticipant.id,
          eventId: helpRequest.id,
          responderId: castParticipant.helpGiver,
          location,
          acceptedAt: (
            castParticipant.acceptedAt ?? castParticipant.updatedAt
          ).toISOString(),
        };
      })
    );
  }

  private formatLocationFromNearbyUser(
    record: NearbyUserWithLocation
  ): HelpEventLocation | null {
    if (
      record.acceptedLatitude === null ||
      record.acceptedLongitude === null
    ) {
      return null;
    }

    return {
      latitude: record.acceptedLatitude,
      longitude: record.acceptedLongitude,
      accuracy:
        record.acceptedAccuracy ?? this.DEFAULT_LOCATION_ACCURACY,
    };
  }

  private async getHelpRequestById(eventId: string): Promise<HelpRequest> {
    const helpRequest = await this.prisma.helpRequest.findUnique({
      where: { id: eventId },
    });
    if (!helpRequest) {
      throw new Error('Help event not found');
    }
    return helpRequest;
  }

  private async buildSummary(
    helpRequest: HelpRequest
  ): Promise<HelpEventSummary> {
    const [rescuee, rescuerCount] = await Promise.all([
      this.buildRescuee(helpRequest),
      this.prisma.nearbyUser.count({
        where: { helpRequester: helpRequest.userId, state: 1 },
      }),
    ]);

    return {
      eventId: helpRequest.id,
      status: helpRequest.status,
      rescuee,
      location: this.toHelpEventLocation(
        helpRequest.gpsCoord,
        helpRequest.locationAccuracy
      ),
      rescuerCount,
      createdAt: helpRequest.createdAt.toISOString(),
    };
  }

  private async buildRescueeView(
    helpRequest: HelpRequest
  ): Promise<HelpEventRescueeView> {
    const [summary, acceptedRescuers] = await Promise.all([
      this.buildSummary(helpRequest),
      this.buildAcceptedRescuers(helpRequest),
    ]);

    return {
      ...summary,
      acceptedRescuers,
      updatedAt: helpRequest.updatedAt?.toISOString() ?? null,
    };
  }

  private async buildRescuerView(
    helpRequest: HelpRequest
  ): Promise<HelpEventRescuerView> {
    const summary = await this.buildSummary(helpRequest);
    return summary;
  }

  private async findNearbyUsers(
    requesterGPS: string,
    maxDistance: number,
    timeWindow: number = 7200
  ): Promise<Array<{ userId: string; distance: number }>> {
    const requesterCoords = this.parseGPSCoordinates(requesterGPS);
    const timeThreshold = Math.floor(Date.now() / 1000) - timeWindow;

    const recentUsers = await this.prisma.locationData.findMany({
      where: {
        timestamp: { gte: timeThreshold },
      },
      orderBy: {
        timestamp: 'desc',
      },
      distinct: ['userId'],
    });

    const nearbyUsers: Array<{ userId: string; distance: number }> = [];

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
            distance: Math.round(distance * 100) / 100,
          });
        }
      } catch (error) {
        console.warn(
          `Invalid GPS coordinates for user ${locationData.userId}: ${locationData.gpsCoord}`
        );
      }
    }

    return nearbyUsers.sort((a, b) => a.distance - b.distance);
  }

  async createHelpEvent(
    userId: string,
    helpData: HelpEventCreate
  ): Promise<HelpEventRescueeView> {
    try {
      const gpsCoord = `${helpData.location.latitude},${helpData.location.longitude}`;

      const helpRequest = await this.prisma.helpRequest.upsert({
        where: { userId },
        update: {
          timestamp: helpData.timestamp,
          gpsCoord,
          helpType: helpData.needType,
          roomId: helpData.chatRoomId,
          status: 'active',
          locationAccuracy: helpData.location.accuracy ?? null,
          updatedAt: new Date(),
        },
        create: {
          id: randomUUID(),
          userId,
          timestamp: helpData.timestamp,
          gpsCoord,
          helpType: helpData.needType,
          roomId: helpData.chatRoomId,
          status: 'active',
          locationAccuracy: helpData.location.accuracy ?? null,
        },
      });

      // Reset previous notifications
      await this.prisma.nearbyUser.deleteMany({
        where: { helpRequester: userId, state: 0 },
      });

      const nearbyUsers = await this.findNearbyUsers(
        gpsCoord,
        this.MAX_DISTANCE_KM,
        7200
      );

      const candidateUsers = nearbyUsers.filter(
        (candidate) => candidate.userId !== userId
      );

      for (const candidate of candidateUsers) {
        try {
          await this.prisma.nearbyUser.upsert({
            where: {
              helpGiver_helpRequester: {
                helpGiver: candidate.userId,
                helpRequester: userId,
              },
            },
            update: {
              state: 0,
              acceptedAt: null,
              acceptedLatitude: null,
              acceptedLongitude: null,
              acceptedAccuracy: null,
            },
            create: {
              id: randomUUID(),
              helpGiver: candidate.userId,
              helpRequester: userId,
              state: 0,
            },
          });
        } catch (error) {
          console.warn(`Failed to create help notification: ${error}`);
        }
      }

      return this.buildRescueeView(helpRequest);
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async listNearbyHelpEvents(
    lat: number,
    lng: number,
    accuracyMeters: number = 3000
  ): Promise<HelpEventSummary[]> {
    try {
      const radiusKm = accuracyMeters / 1000;
      const helpRequests = await this.prisma.helpRequest.findMany({
        where: { status: 'active' },
        orderBy: { createdAt: 'desc' },
      });

      const summaries: HelpEventSummary[] = [];

      for (const helpRequest of helpRequests) {
        const location = this.toHelpEventLocation(
          helpRequest.gpsCoord,
          helpRequest.locationAccuracy
        );
        const distance = this.calculateDistance(
          lat,
          lng,
          location.latitude,
          location.longitude
        );

        if (distance <= radiusKm) {
          summaries.push(await this.buildSummary(helpRequest));
        }
      }

      return summaries;
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async getHelpEventView(
    eventId: string,
    viewerId: string
  ): Promise<HelpEventRescueeView | HelpEventRescuerView> {
    try {
      const helpRequest = await this.getHelpRequestById(eventId);

      if (viewerId === helpRequest.userId) {
        return this.buildRescueeView(helpRequest);
      }

      const participant = await this.prisma.nearbyUser.findUnique({
        where: {
          helpGiver_helpRequester: {
            helpGiver: viewerId,
            helpRequester: helpRequest.userId,
          },
        },
      });

      if (!participant) {
        throw new Error('Viewer is not part of this help event');
      }

      return this.buildRescuerView(helpRequest);
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async acceptHelpEvent(
    eventId: string,
    responderId: string,
    location: HelpEventLocation
  ): Promise<HelpEventRescuerView> {
    try {
      const helpRequest = await this.getHelpRequestById(eventId);

      if (helpRequest.userId === responderId) {
        throw new Error('Rescuee cannot accept their own help event');
      }

      await this.prisma.nearbyUser.upsert({
        where: {
          helpGiver_helpRequester: {
            helpGiver: responderId,
            helpRequester: helpRequest.userId,
          },
        },
        update: {
          state: 1,
          acceptedAt: new Date(),
          acceptedLatitude: location.latitude,
          acceptedLongitude: location.longitude,
          acceptedAccuracy: location.accuracy ?? this.DEFAULT_LOCATION_ACCURACY,
        },
        create: {
          id: randomUUID(),
          helpGiver: responderId,
          helpRequester: helpRequest.userId,
          state: 1,
          acceptedAt: new Date(),
          acceptedLatitude: location.latitude,
          acceptedLongitude: location.longitude,
          acceptedAccuracy: location.accuracy ?? this.DEFAULT_LOCATION_ACCURACY,
        },
      });

      return this.buildRescuerView(helpRequest);
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async withdrawHelpEvent(
    eventId: string,
    responderId: string
  ): Promise<HelpEventRescuerView> {
    try {
      const helpRequest = await this.getHelpRequestById(eventId);

      await this.prisma.nearbyUser.update({
        where: {
          helpGiver_helpRequester: {
            helpGiver: responderId,
            helpRequester: helpRequest.userId,
          },
        },
        data: {
          state: 2,
          acceptedAt: null,
          acceptedLatitude: null,
          acceptedLongitude: null,
          acceptedAccuracy: null,
        },
      });

      return this.buildRescuerView(helpRequest);
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }

  async updateHelpEventStatus(
    eventId: string,
    userId: string,
    status: HelpEventStatus
  ): Promise<HelpEventRescueeView> {
    try {
      const helpRequest = await this.getHelpRequestById(eventId);
      if (helpRequest.userId !== userId) {
        throw new Error('Only the rescuee can update the help event');
      }

      const updated = await this.prisma.helpRequest.update({
        where: { id: eventId },
        data: { status },
      });

      return this.buildRescueeView(updated);
    } catch (error) {
      return await this.handleDatabaseError(error);
    }
  }
}
