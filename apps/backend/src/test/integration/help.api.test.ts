import { describe, it, expect, beforeEach } from 'vitest';
import request from 'supertest';
import express from 'express';
import jwt from 'jsonwebtoken';
import { testPrisma } from '../vitest.setup';
import helpRoutes from '../../api/routes/help/helpRoutes';
import { errorHandler } from '../../api/middleware/errorHandler';

const app = express();
app.use(express.json());
app.use('/', helpRoutes);
app.use(errorHandler);

const JWT_SECRET = 'test_help_event_secret';
process.env.JWT_SECRET = JWT_SECRET;

describe('Help Events API', () => {
  let rescueeToken: string;
  let rescueeId: string;

  const basePayload = {
    timestamp: Math.floor(Date.now() / 1000),
    location: {
      latitude: 65.01,
      longitude: 25.45,
      accuracy: 20,
    },
    needType: 'health',
    chatRoomId: 'room-help',
  };

  const authHeader = (token: string) => ({
    Authorization: `Bearer ${token}`,
  });

  beforeEach(async () => {
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.user.deleteMany();

    const rescuee = await testPrisma.user.create({
      data: {
        id: 'integration-rescuee',
        firstName: 'Rescuee',
        lastName: 'Integration',
        email: 'help-rescuee@example.com',
        role: 'NORMAL',
      },
    });

    rescueeId = rescuee.id;
    rescueeToken = jwt.sign({ userId: rescuee.id }, JWT_SECRET, {
      expiresIn: '1h',
    });
  });

  it('creates a help event', async () => {
    const response = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload)
      .expect(201);

    expect(response.body.data.eventId).toBeDefined();
    expect(response.body.data.rescuee.userId).toBe(rescueeId);
  });

  it('lists nearby help events', async () => {
    await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload)
      .expect(201);

    const response = await request(app)
      .get('/help/events/nearby')
      .set(authHeader(rescueeToken))
      .query({ lat: 65.01, lng: 25.45, accuracy: 5000 })
      .expect(200);

    expect(response.body.data).toHaveLength(1);
  });

  it('allows rescuer to accept and withdraw from event', async () => {
    const eventResponse = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload);

    const eventId = eventResponse.body.data.eventId;

    const rescuer = await testPrisma.user.create({
      data: {
        id: 'integration-rescuer',
        firstName: 'Rescuer',
        lastName: 'Integration',
        email: 'help-rescuer@example.com',
        role: 'RESCUE',
      },
    });

    const rescuerToken = jwt.sign({ userId: rescuer.id }, JWT_SECRET, {
      expiresIn: '1h',
    });

    await request(app)
      .post(`/help/events/${eventId}/acceptance`)
      .set(authHeader(rescuerToken))
      .send({
        location: {
          latitude: 65.011,
          longitude: 25.452,
          accuracy: 15,
        },
      })
      .expect(200);

    await request(app)
      .delete(`/help/events/${eventId}/acceptance`)
      .set(authHeader(rescuerToken))
      .expect(200);
  });

  it('returns context-aware views', async () => {
    const eventResponse = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload);

    const eventId = eventResponse.body.data.eventId;

    const rescueeView = await request(app)
      .get(`/help/events/${eventId}/view`)
      .set(authHeader(rescueeToken))
      .expect(200);
    expect(rescueeView.body.data.rescuee.userId).toBe(rescueeId);

    const rescuer = await testPrisma.user.create({
      data: {
        id: 'integration-view-rescuer',
        firstName: 'Viewer',
        lastName: 'Rescuer',
        email: 'viewer-rescuer@example.com',
        role: 'RESCUE',
      },
    });
    const rescuerToken = jwt.sign({ userId: rescuer.id }, JWT_SECRET, {
      expiresIn: '1h',
    });
    await request(app)
      .post(`/help/events/${eventId}/acceptance`)
      .set(authHeader(rescuerToken))
      .send({ location: { latitude: 65.01, longitude: 25.46 } })
      .expect(200);

    const rescuerView = await request(app)
      .get(`/help/events/${eventId}/view`)
      .set(authHeader(rescuerToken))
      .expect(200);
    expect(rescuerView.body.data.rescuee.userId).toBe(rescueeId);
  });

  it('allows rescuee to update event status', async () => {
    const eventResponse = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload);

    const eventId = eventResponse.body.data.eventId;

    const updated = await request(app)
      .patch(`/help/events/${eventId}`)
      .set(authHeader(rescueeToken))
      .send({ status: 'completed' })
      .expect(200);

    expect(updated.body.data.status).toBe('completed');
  });

  it('rejects invalid help event payloads', async () => {
    const invalidPayload = {
      // missing location
      timestamp: Math.floor(Date.now() / 1000),
      needType: 'invalid-type',
      chatRoomId: '',
    };

    const response = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(invalidPayload)
      .expect(400);

    expect(response.body.success).toBe(false);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });

  it('denies event view to non-participants', async () => {
    const { body } = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload)
      .expect(201);

    const eventId = body.data.eventId;

    const outsider = await testPrisma.user.create({
      data: {
        id: 'integration-outsider',
        firstName: 'Out',
        lastName: 'Sider',
        email: 'outsider@example.com',
        role: 'RESCUE',
      },
    });

    const outsiderToken = jwt.sign({ userId: outsider.id }, JWT_SECRET, {
      expiresIn: '1h',
    });

    const response = await request(app)
      .get(`/help/events/${eventId}/view`)
      .set(authHeader(outsiderToken))
      .expect(403);

    expect(response.body.error.code).toBe('FORBIDDEN');
  });

  it('prevents non-rescuee users from updating event status', async () => {
    const { body } = await request(app)
      .post('/help/events')
      .set(authHeader(rescueeToken))
      .send(basePayload)
      .expect(201);

    const eventId = body.data.eventId;

    const otherUser = await testPrisma.user.create({
      data: {
        id: 'integration-non-owner',
        firstName: 'Other',
        lastName: 'User',
        email: 'other-user@example.com',
        role: 'NORMAL',
      },
    });

    const otherToken = jwt.sign({ userId: otherUser.id }, JWT_SECRET, {
      expiresIn: '1h',
    });

    const response = await request(app)
      .patch(`/help/events/${eventId}`)
      .set(authHeader(otherToken))
      .send({ status: 'cancelled' })
      .expect(403);

    expect(response.body.error.code).toBe('FORBIDDEN');
  });
});
