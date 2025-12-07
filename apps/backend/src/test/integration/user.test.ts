import { describe, it, expect, beforeEach } from 'vitest';
import { testPrisma } from '../vitest.setup';

describe('User Integration Tests', () => {
  beforeEach(async () => {
    // Clean up users before each test (in correct order to avoid foreign key constraints)
    await testPrisma.nearbyUser.deleteMany();
    await testPrisma.helpRequest.deleteMany();
    await testPrisma.userReview.deleteMany();
    await testPrisma.locationData.deleteMany();
    await testPrisma.user.deleteMany();
  });

  it('should create a user successfully', async () => {
    const userData = {
      id: 'test-user-1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@test.com',
      password: 'hashedpassword123',
      role: 'NORMAL' as const,
      devId: 'test-dev-123',
      ipAddress: '192.168.1.1',
      phoneNumber: '0401234567',
      lowBattery: 0,
    };

    const user = await testPrisma.user.create({
      data: userData,
    });

    expect(user).toMatchObject({
      id: userData.id,
      firstName: userData.firstName,
      lastName: userData.lastName,
      email: userData.email,
      role: userData.role,
    });
  });

  it('should find user by email', async () => {
    const userData = {
      id: 'test-user-2',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane.smith@test.com',
      password: 'hashedpassword456',
      role: 'PREMIUM' as const,
    };

    await testPrisma.user.create({
      data: userData,
    });

    const foundUser = await testPrisma.user.findUnique({
      where: { email: userData.email },
    });

    expect(foundUser).not.toBeNull();
    expect(foundUser?.email).toBe(userData.email);
  });

  it('should update user successfully', async () => {
    const userData = {
      id: 'test-user-3',
      firstName: 'Bob',
      lastName: 'Johnson',
      email: 'bob.johnson@test.com',
      password: 'hashedpassword789',
      role: 'NORMAL' as const,
    };

    const user = await testPrisma.user.create({
      data: userData,
    });

    const updatedUser = await testPrisma.user.update({
      where: { id: user.id },
      data: { role: 'PREMIUM' },
    });

    expect(updatedUser.role).toBe('PREMIUM');
  });

  it('should delete user successfully', async () => {
    const userData = {
      id: 'test-user-4',
      firstName: 'Alice',
      lastName: 'Brown',
      email: 'alice.brown@test.com',
      password: 'hashedpassword101',
      role: 'NORMAL' as const,
    };

    const user = await testPrisma.user.create({
      data: userData,
    });

    await testPrisma.user.delete({
      where: { id: user.id },
    });

    const deletedUser = await testPrisma.user.findUnique({
      where: { id: user.id },
    });

    expect(deletedUser).toBeNull();
  });
});
