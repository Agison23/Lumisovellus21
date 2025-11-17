import { describe, it, expect, beforeEach } from 'vitest';
import { HelpService } from '../../api/services/help/HelpService';
import { testPrisma } from '../vitest.setup';
import type { HelpEventCreate } from '../../api/types';

describe('HelpService', () => {
  let helpService: HelpService;
  let rescueeId: string;

  beforeEach(async () => {
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.user.deleteMany();

    helpService = new HelpService();

    const rescuee = await testPrisma.user.create({
      data: {
        id: 'rescuee-user',
        firstName: 'Rescuee',
        lastName: 'User',
        email: 'rescuee@example.com',
        role: 'NORMAL',
      },
    });

    rescueeId = rescuee.id;
  });

  const baseEvent: HelpEventCreate = {
    timestamp: Math.floor(Date.now() / 1000),
    location: {
      latitude: 65.01,
      longitude: 25.45,
      accuracy: 25,
    },
    needType: 'health',
    chatRoomId: 'room-1',
  };

  it('creates a help event and returns rescuee view', async () => {
    const event = await helpService.createHelpEvent(rescueeId, baseEvent);
    expect(event.eventId).toBeDefined();
    expect(event.rescuee.userId).toBe(rescueeId);
    expect(event.location.latitude).toBeCloseTo(baseEvent.location.latitude);
    expect(event.acceptedRescuers).toHaveLength(0);
  });

  it('lists nearby help events within radius', async () => {
    await helpService.createHelpEvent(rescueeId, baseEvent);

    const farUser = await testPrisma.user.create({
      data: {
        id: 'far-user',
        firstName: 'Far',
        lastName: 'Away',
        email: 'far@example.com',
        role: 'RESCUE',
      },
    });

    await testPrisma.locationData.create({
      data: {
        id: 'location-far',
        userId: farUser.id,
        timestamp: Math.floor(Date.now() / 1000),
        gpsCoord: '66.00,26.00',
      },
    });

    const events = await helpService.listNearbyHelpEvents(
      65.01,
      25.45,
      5000
    );
    expect(events).toHaveLength(1);
  });

  it('allows rescuer to accept and withdraw from event', async () => {
    const rescueEvent = await helpService.createHelpEvent(rescueeId, baseEvent);

    const rescuer = await testPrisma.user.create({
      data: {
        id: 'rescuer',
        firstName: 'Rescuer',
        lastName: 'One',
        email: 'rescuer@example.com',
        role: 'RESCUE',
      },
    });

    const acceptView = await helpService.acceptHelpEvent(
      rescueEvent.eventId,
      rescuer.id,
      {
        latitude: 65.011,
        longitude: 25.452,
        accuracy: 15,
      }
    );

    expect(acceptView.eventId).toBe(rescueEvent.eventId);
    const withdrawView = await helpService.withdrawHelpEvent(
      rescueEvent.eventId,
      rescuer.id
    );
    expect(withdrawView.eventId).toBe(rescueEvent.eventId);
  });

  it('returns context aware views', async () => {
    const rescueEvent = await helpService.createHelpEvent(rescueeId, baseEvent);

    const rescueeView = await helpService.getHelpEventView(
      rescueEvent.eventId,
      rescueeId
    );
    expect(rescueeView).toHaveProperty('acceptedRescuers');

    const rescuer = await testPrisma.user.create({
      data: {
        id: 'viewer-rescuer',
        firstName: 'Viewer',
        lastName: 'Rescuer',
        email: 'viewer@example.com',
        role: 'RESCUE',
      },
    });

    await helpService.acceptHelpEvent(rescueEvent.eventId, rescuer.id, {
      latitude: 65.012,
      longitude: 25.456,
      accuracy: 20,
    });

    const rescuerView = await helpService.getHelpEventView(
      rescueEvent.eventId,
      rescuer.id
    );
    expect(rescuerView).not.toHaveProperty('acceptedRescuers');
  });

  it('updates help event status', async () => {
    const rescueEvent = await helpService.createHelpEvent(rescueeId, baseEvent);
    const updated = await helpService.updateHelpEventStatus(
      rescueEvent.eventId,
      rescueeId,
      'completed'
    );
    expect(updated.status).toBe('completed');
  });

  it('prevents rescuee from accepting their own help event', async () => {
    const rescueEvent = await helpService.createHelpEvent(rescueeId, baseEvent);

    await expect(
      helpService.acceptHelpEvent(rescueEvent.eventId, rescueeId, {
        latitude: baseEvent.location.latitude,
        longitude: baseEvent.location.longitude,
      })
    ).rejects.toThrow('Rescuee cannot accept their own help event');
  });

  it('rejects rescuer view requests for non-participants', async () => {
    const rescueEvent = await helpService.createHelpEvent(rescueeId, baseEvent);

    const outsider = await testPrisma.user.create({
      data: {
        id: 'outsider',
        firstName: 'Outside',
        lastName: 'Viewer',
        email: 'outside@example.com',
        role: 'RESCUE',
      },
    });

    await expect(
      helpService.getHelpEventView(rescueEvent.eventId, outsider.id)
    ).rejects.toThrow('Viewer is not part of this help event');
  });

  it('prevents non-rescuee users from updating event status', async () => {
    const rescueEvent = await helpService.createHelpEvent(rescueeId, baseEvent);

    const otherUser = await testPrisma.user.create({
      data: {
        id: 'non-owner',
        firstName: 'Other',
        lastName: 'User',
        email: 'other@example.com',
        role: 'NORMAL',
      },
    });

    await expect(
      helpService.updateHelpEventStatus(rescueEvent.eventId, otherUser.id, 'cancelled')
    ).rejects.toThrow('Only the rescuee can update the help event');
  });
});
