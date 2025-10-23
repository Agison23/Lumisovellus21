import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // Create default users (from legacy web system)
  const hashedPassword = await bcrypt.hash('admin123', 15);
  const hashedUserPassword = await bcrypt.hash('user123', 15);
  const hashedRescuePassword = await bcrypt.hash('rescue123', 15);

  const adminUser = await prisma.user.upsert({
    where: { email: 'admin@lumisovellus.fi' },
    update: {},
    create: {
      firstName: 'Admin',
      lastName: 'User',
      email: 'admin@lumisovellus.fi',
      password: hashedPassword,
      role: 'ADMIN',
    },
  });

  const normalUser = await prisma.user.upsert({
    where: { email: 'user@lumisovellus.fi' },
    update: {},
    create: {
      firstName: 'Test',
      lastName: 'User',
      email: 'user@lumisovellus.fi',
      password: hashedUserPassword,
      role: 'NORMAL',
    },
  });

  const rescueUser = await prisma.user.upsert({
    where: { email: 'rescue@lumisovellus.fi' },
    update: {},
    create: {
      firstName: 'Rescue',
      lastName: 'Operator',
      email: 'rescue@lumisovellus.fi',
      password: hashedRescuePassword,
      role: 'RESCUE',
    },
  });

  // Create mobile users
  const mobileUser1 = await prisma.user.upsert({
    where: { devId: 'test-device-001' },
    update: {},
    create: {
      firstName: 'Mobile',
      lastName: 'User1',
      devId: 'test-device-001',
      ipAddress: '192.168.1.100',
      phoneNumber: '+358401234567',
      lowBattery: 0,
      role: 'NORMAL',
    },
  });

  const mobileUser2 = await prisma.user.upsert({
    where: { devId: 'test-device-002' },
    update: {},
    create: {
      firstName: 'Premium',
      lastName: 'User',
      devId: 'test-device-002',
      ipAddress: '192.168.1.101',
      phoneNumber: '+358401234568',
      lowBattery: 1,
      role: 'PREMIUM',
    },
  });


  // Create mobile user roles
  await prisma.role.upsert({
    where: { name: 'normal' },
    update: {},
    create: {
      id: crypto.randomUUID(),
      name: 'normal',
      permissions: 'rescue',
    },
  });

  await prisma.role.upsert({
    where: { name: 'premium' },
    update: {},
    create: {
      id: crypto.randomUUID(),
      name: 'premium',
      permissions: 'rescue,snow condition',
    },
  });

  // Create snow types (from legacy web system)
  const snowTypes = [
    {
      name: 'Uusi lumi',
      colour: '#FFFFFF',
      skiability: 5,
      categoryId: 1,
      explanation: 'Tuore, pehmeä lumi',
    },
    {
      name: 'Kova lumi',
      colour: '#E0E0E0',
      skiability: 3,
      categoryId: 1,
      explanation: 'Kovettunutta lunta',
    },
    {
      name: 'Jäinen lumi',
      colour: '#B0C4DE',
      skiability: 2,
      categoryId: 1,
      explanation: 'Jäätynyttä lunta',
    },
    {
      name: 'Märkä lumi',
      colour: '#87CEEB',
      skiability: 1,
      categoryId: 1,
      explanation: 'Märkää, raskasta lunta',
    },
    {
      name: 'Harsi',
      colour: '#F0F8FF',
      skiability: 4,
      categoryId: 2,
      explanation: 'Pinta harsia',
    },
    {
      name: 'Kuura',
      colour: '#F5F5F5',
      skiability: 3,
      categoryId: 2,
      explanation: 'Kuurakerros',
    },
  ];

  for (const snowType of snowTypes) {
    await prisma.snowType.upsert({
      where: { name: snowType.name },
      update: {},
      create: {
        id: crypto.randomUUID(),
        ...snowType,
      },
    });
  }

  // Create segments (Pallas area segments from legacy system)
  const segments = [
    {
      name: 'Pallas-Yllästunturi National Park - Main Trail',
      terrain: 'Mountain trail',
      avalancheDanger: false,
      coordinates: [
        { order: 1, latitude: 68.0324, longitude: 24.0736 },
        { order: 2, latitude: 68.0356, longitude: 24.0892 },
        { order: 3, latitude: 68.0398, longitude: 24.1045 },
        { order: 4, latitude: 68.0445, longitude: 24.1198 },
      ],
    },
    {
      name: 'Taivaskero Summit',
      terrain: 'Summit approach',
      avalancheDanger: true,
      coordinates: [
        { order: 1, latitude: 68.0567, longitude: 24.1234 },
        { order: 2, latitude: 68.0589, longitude: 24.1267 },
        { order: 3, latitude: 68.0612, longitude: 24.1298 },
        { order: 4, latitude: 68.0634, longitude: 24.1329 },
      ],
    },
    {
      name: 'Sammakkolampi Loop',
      terrain: 'Forest trail',
      avalancheDanger: false,
      coordinates: [
        { order: 1, latitude: 68.0123, longitude: 24.0456 },
        { order: 2, latitude: 68.0145, longitude: 24.0478 },
        { order: 3, latitude: 68.0167, longitude: 24.0501 },
        { order: 4, latitude: 68.0189, longitude: 24.0523 },
        { order: 5, latitude: 68.0156, longitude: 24.0489 },
      ],
    },
    {
      name: 'Pyhäkero Ridge',
      terrain: 'Ridge trail',
      avalancheDanger: false,
      coordinates: [
        { order: 1, latitude: 68.0789, longitude: 24.1567 },
        { order: 2, latitude: 68.0812, longitude: 24.1589 },
        { order: 3, latitude: 68.0834, longitude: 24.1612 },
        { order: 4, latitude: 68.0856, longitude: 24.1634 },
      ],
    },
    {
      name: 'Lappea Valley',
      terrain: 'Valley trail',
      avalancheDanger: false,
      coordinates: [
        { order: 1, latitude: 67.9876, longitude: 23.9876 },
        { order: 2, latitude: 67.9898, longitude: 23.9898 },
        { order: 3, latitude: 67.9921, longitude: 23.9921 },
        { order: 4, latitude: 67.9943, longitude: 23.9943 },
      ],
    },
  ];

  for (const segmentData of segments) {
    const segment = await prisma.segment.upsert({
      where: { name: segmentData.name },
      update: {},
      create: {
        id: crypto.randomUUID(),
        name: segmentData.name,
        terrain: segmentData.terrain,
        avalancheDanger: segmentData.avalancheDanger,
      },
    });

    // Create coordinates for the segment
    for (const coord of segmentData.coordinates) {
      await prisma.coordinate.upsert({
        where: {
          order_segment: {
            order: coord.order,
            segment: segment.id,
          },
        },
        update: {},
        create: {
          id: crypto.randomUUID(),
          segment: segment.id,
          order: coord.order,
          latitude: coord.latitude,
          longitude: coord.longitude,
        },
      });
    }
  }

  // Create sample reviews
  const segments_list = await prisma.segment.findMany();
  const snowTypes_list = await prisma.snowType.findMany();

  for (let i = 0; i < 10; i++) {
    const randomSegment =
      segments_list[Math.floor(Math.random() * segments_list.length)];
    const randomSnowType =
      snowTypes_list[Math.floor(Math.random() * snowTypes_list.length)];
    const randomUser = Math.random() > 0.5 ? normalUser : rescueUser;

    if (randomSegment && randomSnowType) {
      await prisma.userReview.create({
        data: {
          id: crypto.randomUUID(),
          segment: randomSegment.id,
          snowType: randomSnowType.id,
          details: Math.floor(Math.random() * 5) + 1,
          comment: `Sample review ${i + 1} for ${randomSegment.name}. Conditions were ${randomSnowType.name.toLowerCase()}.`,
          userId: randomUser.id,
          time: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000), // Random time in last week
        },
      });
    }
  }

  // Create sample updates
  for (let i = 0; i < 5; i++) {
    const randomSegment =
      segments_list[Math.floor(Math.random() * segments_list.length)];
    const randomSnowType =
      snowTypes_list[Math.floor(Math.random() * snowTypes_list.length)];

    if (randomSegment && randomSnowType) {
      await prisma.snowUpdate.create({
        data: {
          id: crypto.randomUUID(),
          creator: adminUser.id,
          segment: randomSegment.id,
          description: `Official snow update ${i + 1} for ${randomSegment.name}. Current conditions updated.`,
          weather: 'Clear',
          temperature: Math.random() * 10 - 5, // Random temp between -5 and 5
          windSpeed: Math.random() * 20, // Random wind speed 0-20 km/h
          visibility: Math.floor(Math.random() * 5000) + 1000, // Random visibility 1-6km
          status: 'ACTIVE',
          priority: Math.floor(Math.random() * 3) + 1, // Random priority 1-3
          snowConditions: {
            create: {
              id: crypto.randomUUID(),
              snowType: randomSnowType.id,
              layer: 'SURFACE',
              depth: Math.random() * 50 + 10, // Random depth 10-60cm
              coverage: Math.floor(Math.random() * 40) + 60, // Random coverage 60-100%
              quality: Math.floor(Math.random() * 5) + 1, // Random quality 1-5
              hardness: Math.floor(Math.random() * 5) + 1, // Random hardness 1-5
              moisture: Math.floor(Math.random() * 5) + 1, // Random moisture 1-5
              notes: `Surface conditions: ${randomSnowType.name.toLowerCase()}`,
            },
          },
        },
      });
    }
  }

  // Create sample mobile users
  const mobileUsers = [
    {
      devId: 'test-device-001',
      firstName: 'Mobile',
      lastName: 'User1',
      ipAddress: '192.168.1.100,50943',
      phoneNumber: '+358401234567',
      role: 'PREMIUM',
    },
    {
      devId: 'test-device-002',
      firstName: 'Mobile',
      lastName: 'User2',
      ipAddress: '192.168.1.101,50943',
      phoneNumber: '+358401234568',
      role: 'NORMAL',
    },
  ];

  for (const mobileUser of mobileUsers) {
    const createdUser = await prisma.user.upsert({
      where: { devId: mobileUser.devId },
      update: {},
      create: {
        ...mobileUser,
        role: mobileUser.role as any,
      },
    });

    // Create sample location data
    const currentTime = Math.floor(Date.now() / 1000);
    await prisma.locationData.create({
      data: {
        id: crypto.randomUUID(),
        userId: createdUser.id,
        timestamp: currentTime,
        gpsCoord: `68.${Math.floor(Math.random() * 1000)},24.${Math.floor(Math.random() * 1000)}`,
      },
    });
  }
}

main()
  .catch((e) => {
    console.error('❌ Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
