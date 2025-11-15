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

  // Create snow types (from mock-data.ts)
  // Primary snow types (primarySnowTypeId: null) - these are the main categories
  // Secondary snow types (primarySnowTypeId: <uuid>) - these are subtypes
  const snowTypes = [
    {
      name: 'Korppu',
      colour: '#3838a0',
      skiability: 3,
      primarySnowTypeId: null,
      explanation: 'Kova hangen pinnalla oleva kansi. Korppu voi olla luonteeltaan tasaista tai rosoista.',
    },
    {
      name: 'Sohjo',
      colour: '#919394',
      skiability: 2,
      primarySnowTypeId: null,
      explanation: 'Vesipitoinen ja osittain sulanut lumi suojasäällä.',
    },
    {
      name: 'Jää',
      colour: '#34929A',
      skiability: 2,
      primarySnowTypeId: null,
      explanation: 'Hangen pinnalla oleva kova ja rikkoutumaton jäinen kerros. Jää on syntynyt sulamis-jäätymisreaktion tuloksena.',
    },
    {
      name: 'Uusi lumi',
      colour: '#5AABED',
      skiability: 4,
      primarySnowTypeId: null,
      explanation: 'Vastasatanut pehmeä lumi.',
    },
    {
      name: 'Tuulen pieksemä lumi',
      colour: '#7C759F',
      skiability: 3,
      primarySnowTypeId: null,
      explanation: 'Tuulen kovettama ja moninpaikoin epätasaiseksi muotoilema lumi.',
    },
    {
      name: 'Vähäinen lumi',
      colour: '#6D4F32',
      skiability: null,
      primarySnowTypeId: null,
      explanation: '',
    },
    {
      name: 'Lumeton maa',
      colour: '#000000',
      skiability: null,
      primarySnowTypeId: null,
      explanation: '',
    },
    {
      name: 'Vitilumi',
      colour: '#5AABED',
      skiability: 5,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Vastasatanutta, kevyttä, pehmeää ja hieman tiivistyvää pakkaslunta.',
    },
    {
      name: 'Puuterilumi',
      colour: '#5AABED',
      skiability: 5,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Vastasatanutta irtonaista, höyhenenkevyttä ja tiivistymätöntä lunta. Puuterilunta muodostuu yleensä tyynellä ilmalla ja kovalla pakkasella.',
    },
    {
      name: 'Märkä uusi lumi',
      colour: '#5AABED',
      skiability: 4,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Lunta, josta voit helposti tehdä lumipallon. Märkää lunta muodostuu sateen tapahtuessa lähellä nollaa tai reilusti suojan puolella.',
    },
    {
      name: 'Sastrugi',
      colour: '#7C759F',
      skiability: 1,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Tuulen aiheuttamaa lumiaallokkoa, joka on kovaa, jäistä ja terväharjanteista.',
    },
    {
      name: 'Aaltoileva lumi',
      colour: '#7C759F',
      skiability: 4,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Tuulen muotoilema uuden lumen alue. Aallot ovat pehmeitä ja hyvin rikottavissa.',
    },
    {
      name: 'Tuiskulumi',
      colour: '#7C759F',
      skiability: 4,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Tasainen, tuulen kerrostama ja pakkaama laatta tai linssi. Tuiskulunta voi kertyä myös ilman lumisadetta, jos tuuli siirtää lunta paikasta toiseen. Tuiskulunta syntyy yleensä suojapuolelle.',
    },
    {
      name: 'Ohut korppu',
      colour: '#3838a0',
      skiability: 3,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Hiihtäjän painosta rikkoutuva lumikansi. Korpun alla lumi voi olla paikoitellen upottavaa.',
    },
    {
      name: 'Rikkoutuva korppu',
      colour: '#3838a0',
      skiability: 2,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Satunnaisesti kantava, yllättäen rikkoutuva lumen pinta. Kansi voi olla hyvinkin paksu, jos sen alla on huokoista lunta.',
    },
    {
      name: 'Kantava korppu',
      colour: '#3838a0',
      skiability: 3,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Tukeva ja kantava lumikansi, jonka pinta on usein hyvin kovaa ja tiivistä.',
    },
    {
      name: 'Rikkoutuva jää',
      colour: '#34929A',
      skiability: 1,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Hangen pinnalla oleva kova ja rikkoutuva jäinen kerros.',
    },
    {
      name: 'Kastuva lumi',
      colour: '#919394',
      skiability: 3,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Lämpenemisen tai vesisateen myötä pinnalta alkaen märkä tai kostea lumi.',
    },
    {
      name: 'Saturoitunut lumi',
      colour: '#919394',
      skiability: 2,
      primarySnowTypeId: null, // Will be set after primary types are created
      explanation: 'Märkä, läpi koko kerroksen sohjoutuva ja kermavaahtomainen lumi',
    }
  ];

  // Create snow types and store their IDs for secondary relationships
  const createdSnowTypes: { [key: string]: string } = {};

  for (const snowType of snowTypes) {
    const result = await prisma.snowType.upsert({
      where: { name: snowType.name },
      update: {},
      create: {
        id: crypto.randomUUID(),
        ...snowType,
      },
    });
    createdSnowTypes[snowType.name] = result.id;
  }

  // Secondary snow type relationships based on category structure
  // Also update the primarySnowTypeId field for secondary types
  const updateSecondaryType = async (
    primaryName: string,
    secondaryName: string
  ) => {
    const primaryId = createdSnowTypes[primaryName];
    const secondaryId = createdSnowTypes[secondaryName];

    if (!primaryId || !secondaryId) {
      return;
    }

    // Update the secondary type's primarySnowTypeId
    await prisma.snowType.update({
      where: { id: secondaryId },
      data: { primarySnowTypeId: primaryId },
    });

    // Create the SnowTypeSecondary relationship
    const existing = await prisma.snowTypeSecondary.findFirst({
      where: {
        primarySnowTypeId: primaryId,
        secondarySnowTypeId: secondaryId,
      },
    });

    if (!existing) {
      await prisma.snowTypeSecondary.create({
        data: {
          id: crypto.randomUUID(),
          primarySnowTypeId: primaryId,
          secondarySnowTypeId: secondaryId,
        },
      });
    }
  };

  // Korppu → subtypes
  await updateSecondaryType('Korppu', 'Ohut korppu');
  await updateSecondaryType('Korppu', 'Rikkoutuva korppu');
  await updateSecondaryType('Korppu', 'Kantava korppu');

  // Sohjo → subtypes
  await updateSecondaryType('Sohjo', 'Kastuva lumi');
  await updateSecondaryType('Sohjo', 'Saturoitunut lumi');

  // Jää → subtypes
  await updateSecondaryType('Jää', 'Rikkoutuva jää');

  // Uusi lumi → subtypes
  await updateSecondaryType('Uusi lumi', 'Vitilumi');
  await updateSecondaryType('Uusi lumi', 'Puuterilumi');
  await updateSecondaryType('Uusi lumi', 'Märkä uusi lumi');

  // Tuulen pieksemä lumi → subtypes
  await updateSecondaryType('Tuulen pieksemä lumi', 'Sastrugi');
  await updateSecondaryType('Tuulen pieksemä lumi', 'Aaltoileva lumi');
  await updateSecondaryType('Tuulen pieksemä lumi', 'Tuiskulumi');

  // Create segments (Pallas area segments from legacy system)
  const segments = [
    {
      id: crypto.randomUUID(),
      name: 'Laukukero Pohjoisseinä',
      terrain: 'Tuulikangas',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0613, longitude: 24.0316 },
        { order: 1, latitude: 68.0639, longitude: 24.0333 },
        { order: 2, latitude: 68.067, longitude: 24.0398 },
        { order: 3, latitude: 68.0702, longitude: 24.021 },
        { order: 4, latitude: 68.0655, longitude: 24.0042 },
        { order: 5, latitude: 68.0625, longitude: 24.0102 },
        { order: 6, latitude: 68.0613, longitude: 24.0316 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Lehmäkero länsiseinä ja laakso',
      terrain: 'Tuulikangas ja varvikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0826, longitude: 24.0381 },
        { order: 1, latitude: 68.0844, longitude: 24.0425 },
        { order: 2, latitude: 68.0883, longitude: 24.0359 },
        { order: 3, latitude: 68.0979, longitude: 24.0258 },
        { order: 4, latitude: 68.1046, longitude: 24.0358 },
        { order: 5, latitude: 68.1081, longitude: 24.0499 },
        { order: 6, latitude: 68.0937, longitude: 24.0562 },
        { order: 7, latitude: 68.0874, longitude: 24.0628 },
        { order: 8, latitude: 68.0846, longitude: 24.0666 },
        { order: 9, latitude: 68.0807, longitude: 24.0633 },
        { order: 10, latitude: 68.0793, longitude: 24.0652 },
        { order: 11, latitude: 68.0737, longitude: 24.0667 },
        { order: 12, latitude: 68.0752, longitude: 24.061 },
        { order: 13, latitude: 68.0759, longitude: 24.0576 },
        { order: 14, latitude: 68.0806, longitude: 24.0498 },
        { order: 15, latitude: 68.0826, longitude: 24.0381 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Orotuskero eteläseinä ja laakso',
      terrain: 'Tuulikangas ja varvikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0749, longitude: 24.0536 },
        { order: 1, latitude: 68.0747, longitude: 24.0383 },
        { order: 2, latitude: 68.0702, longitude: 24.021 },
        { order: 3, latitude: 68.0655, longitude: 24.0042 },
        { order: 4, latitude: 68.0701, longitude: 23.9948 },
        { order: 5, latitude: 68.0776, longitude: 24.0119 },
        { order: 6, latitude: 68.08, longitude: 24.0191 },
        { order: 7, latitude: 68.082, longitude: 24.025 },
        { order: 8, latitude: 68.0826, longitude: 24.0381 },
        { order: 9, latitude: 68.0806, longitude: 24.0498 },
        { order: 10, latitude: 68.0759, longitude: 24.0576 },
        { order: 11, latitude: 68.0749, longitude: 24.0536 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Pallas-Palkas itäseinä',
      terrain: 'Rakka, puurajassa varvikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0309, longitude: 24.1142 },
        { order: 1, latitude: 68.0392, longitude: 24.1059 },
        { order: 2, latitude: 68.0483, longitude: 24.1096 },
        { order: 3, latitude: 68.0534, longitude: 24.0967 },
        { order: 4, latitude: 68.0638, longitude: 24.0945 },
        { order: 5, latitude: 68.0659, longitude: 24.1027 },
        { order: 6, latitude: 68.0567, longitude: 24.1122 },
        { order: 7, latitude: 68.0515, longitude: 24.1258 },
        { order: 8, latitude: 68.0447, longitude: 24.1273 },
        { order: 9, latitude: 68.0408, longitude: 24.1248 },
        { order: 10, latitude: 68.037, longitude: 24.1227 },
        { order: 11, latitude: 68.0309, longitude: 24.1142 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Laukukero itäseinä',
      terrain: 'Tuulikangas ja varvikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.048, longitude: 24.0443 },
        { order: 1, latitude: 68.0497, longitude: 24.053 },
        { order: 2, latitude: 68.0593, longitude: 24.0562 },
        { order: 3, latitude: 68.067, longitude: 24.0398 },
        { order: 4, latitude: 68.0639, longitude: 24.0333 },
        { order: 5, latitude: 68.0613, longitude: 24.0316 },
        { order: 6, latitude: 68.0563, longitude: 24.0386 },
        { order: 7, latitude: 68.048, longitude: 24.0443 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Laukukero länsiseinä',
      terrain: 'Tuulikangas ja varvikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0625, longitude: 24.0102 },
        { order: 1, latitude: 68.0613, longitude: 24.0316 },
        { order: 2, latitude: 68.0563, longitude: 24.0386 },
        { order: 3, latitude: 68.048, longitude: 24.0443 },
        { order: 4, latitude: 68.0508, longitude: 24.0364 },
        { order: 5, latitude: 68.0525, longitude: 24.0296 },
        { order: 6, latitude: 68.0546, longitude: 24.0244 },
        { order: 7, latitude: 68.056, longitude: 24.0194 },
        { order: 8, latitude: 68.057, longitude: 24.0171 },
        { order: 9, latitude: 68.0625, longitude: 24.0102 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Pallas-Palkas länsiseinä',
      terrain: 'Tuulikangas ja varvikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0309, longitude: 24.1142 },
        { order: 1, latitude: 68.0336, longitude: 24.0972 },
        { order: 2, latitude: 68.0401, longitude: 24.0807 },
        { order: 3, latitude: 68.0401, longitude: 24.0807 },
        { order: 4, latitude: 68.0513, longitude: 24.0622 },
        { order: 5, latitude: 68.0638, longitude: 24.0945 },
        { order: 6, latitude: 68.0534, longitude: 24.0967 },
        { order: 7, latitude: 68.0483, longitude: 24.1096 },
        { order: 8, latitude: 68.0392, longitude: 24.1059 },
        { order: 9, latitude: 68.0309, longitude: 24.1142 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Vatikuru',
      terrain: 'Tuulikangas alaosassa puronvarsilla katajikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0593, longitude: 24.0627 },
        { order: 1, latitude: 68.0625, longitude: 24.0628 },
        { order: 2, latitude: 68.0702, longitude: 24.0737 },
        { order: 3, latitude: 68.0737, longitude: 24.0667 },
        { order: 4, latitude: 68.0752, longitude: 24.061 },
        { order: 5, latitude: 68.0759, longitude: 24.0576 },
        { order: 6, latitude: 68.0749, longitude: 24.0536 },
        { order: 7, latitude: 68.0681, longitude: 24.0413 },
        { order: 8, latitude: 68.067, longitude: 24.0398 },
        { order: 9, latitude: 68.0593, longitude: 24.0562 },
        { order: 10, latitude: 68.0593, longitude: 24.0561 },
        { order: 11, latitude: 68.0593, longitude: 24.0627 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Pyhä-Lehmäkero itäseinä',
      terrain: 'Raakakivikko',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0659, longitude: 24.1027 },
        { order: 1, latitude: 68.0702, longitude: 24.0737 },
        { order: 2, latitude: 68.0737, longitude: 24.0667 },
        { order: 3, latitude: 68.0793, longitude: 24.0652 },
        { order: 4, latitude: 68.0807, longitude: 24.0633 },
        { order: 5, latitude: 68.0846, longitude: 24.0666 },
        { order: 6, latitude: 68.0874, longitude: 24.0628 },
        { order: 7, latitude: 68.0937, longitude: 24.0562 },
        { order: 8, latitude: 68.1007, longitude: 24.0692 },
        { order: 9, latitude: 68.0992, longitude: 24.0745 },
        { order: 10, latitude: 68.0955, longitude: 24.0722 },
        { order: 11, latitude: 68.0917, longitude: 24.0792 },
        { order: 12, latitude: 68.0871, longitude: 24.0859 },
        { order: 13, latitude: 68.082, longitude: 24.0892 },
        { order: 14, latitude: 68.0794, longitude: 24.0917 },
        { order: 15, latitude: 68.0746, longitude: 24.0984 },
        { order: 16, latitude: 68.0694, longitude: 24.1053 },
        { order: 17, latitude: 68.0659, longitude: 24.1027 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Pyhäkero eteläseinä',
      terrain: 'Raakakivikko ja tuulikangas',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0702, longitude: 24.0737 },
        { order: 1, latitude: 68.0659, longitude: 24.1027 },
        { order: 2, latitude: 68.0638, longitude: 24.0945 },
        { order: 3, latitude: 68.0513, longitude: 24.0622 },
        { order: 4, latitude: 68.0593, longitude: 24.0627 },
        { order: 5, latitude: 68.0625, longitude: 24.0628 },
        { order: 6, latitude: 68.0702, longitude: 24.0737 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Paratiisikuru',
      terrain: 'Vakio',
      avalancheDanger: false,
      isLowerSegment: 5,
      coordinates: [
        { order: 0, latitude: 68.0728, longitude: 24.038 },
        { order: 1, latitude: 68.0725, longitude: 24.0341 },
        { order: 2, latitude: 68.0725, longitude: 24.0341 },
        { order: 3, latitude: 68.0724, longitude: 24.0306 },
        { order: 4, latitude: 68.0712, longitude: 24.0248 },
        { order: 5, latitude: 68.0706, longitude: 24.0227 },
        { order: 6, latitude: 68.07, longitude: 24.0234 },
        { order: 7, latitude: 68.0694, longitude: 24.0261 },
        { order: 8, latitude: 68.0677, longitude: 24.0361 },
        { order: 9, latitude: 68.068, longitude: 24.0391 },
        { order: 10, latitude: 68.0687, longitude: 24.041 },
        { order: 11, latitude: 68.0699, longitude: 24.0412 },
        { order: 12, latitude: 68.0711, longitude: 24.0404 },
        { order: 13, latitude: 68.0728, longitude: 24.038 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Pyhäkuru',
      terrain: 'Vakio',
      avalancheDanger: true,
      isLowerSegment: 11,
      coordinates: [
        { order: 0, latitude: 68.0809, longitude: 24.0697 },
        { order: 1, latitude: 68.0801, longitude: 24.0685 },
        { order: 2, latitude: 68.0788, longitude: 24.0677 },
        { order: 3, latitude: 68.0779, longitude: 24.0689 },
        { order: 4, latitude: 68.077, longitude: 24.0704 },
        { order: 5, latitude: 68.0763, longitude: 24.0722 },
        { order: 6, latitude: 68.0759, longitude: 24.0755 },
        { order: 7, latitude: 68.0763, longitude: 24.0778 },
        { order: 8, latitude: 68.0769, longitude: 24.0806 },
        { order: 9, latitude: 68.0778, longitude: 24.0826 },
        { order: 10, latitude: 68.0785, longitude: 24.084 },
        { order: 11, latitude: 68.0791, longitude: 24.0851 },
        { order: 12, latitude: 68.0796, longitude: 24.0859 },
        { order: 13, latitude: 68.0805, longitude: 24.0835 },
        { order: 14, latitude: 68.0813, longitude: 24.08 },
        { order: 15, latitude: 68.0812, longitude: 24.0759 },
        { order: 16, latitude: 68.0812, longitude: 24.0738 },
        { order: 17, latitude: 68.0811, longitude: 24.0716 },
        { order: 18, latitude: 68.0809, longitude: 24.0697 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Soilenrinne',
      terrain: 'Vakio',
      avalancheDanger: false,
      isLowerSegment: 8,
      coordinates: [
        { order: 0, latitude: 68.0596, longitude: 24.0304 },
        { order: 1, latitude: 68.0588, longitude: 24.0279 },
        { order: 2, latitude: 68.0583, longitude: 24.0258 },
        { order: 3, latitude: 68.0575, longitude: 24.0232 },
        { order: 4, latitude: 68.05656, longitude: 24.02018 },
        { order: 5, latitude: 68.05627, longitude: 24.01968 },
        { order: 6, latitude: 68.05423, longitude: 24.02676 },
        { order: 7, latitude: 68.05476, longitude: 24.02791 },
        { order: 8, latitude: 68.05588, longitude: 24.03123 },
        { order: 9, latitude: 68.05744, longitude: 24.0336 },
        { order: 10, latitude: 68.05824, longitude: 24.03453 },
        { order: 11, latitude: 68.0596, longitude: 24.0304 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Veitikka',
      terrain: 'Vakio',
      avalancheDanger: false,
      isLowerSegment: 10,
      coordinates: [
        { order: 0, latitude: 68.0685, longitude: 24.0584 },
        { order: 1, latitude: 68.0691, longitude: 24.058 },
        { order: 2, latitude: 68.0696, longitude: 24.0575 },
        { order: 3, latitude: 68.07, longitude: 24.0573 },
        { order: 4, latitude: 68.0708, longitude: 24.0572 },
        { order: 5, latitude: 68.0718, longitude: 24.0577 },
        { order: 6, latitude: 68.0718, longitude: 24.0601 },
        { order: 7, latitude: 68.0717, longitude: 24.0621 },
        { order: 8, latitude: 68.0713, longitude: 24.064 },
        { order: 9, latitude: 68.0709, longitude: 24.0652 },
        { order: 10, latitude: 68.0706, longitude: 24.0657 },
        { order: 11, latitude: 68.0692, longitude: 24.0644 },
        { order: 12, latitude: 68.0688, longitude: 24.0629 },
        { order: 13, latitude: 68.0687, longitude: 24.0615 },
        { order: 14, latitude: 68.0684, longitude: 24.0604 },
        { order: 15, latitude: 68.0682, longitude: 24.0594 },
        { order: 16, latitude: 68.0685, longitude: 24.0584 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Viivakuru',
      terrain: 'Vakio',
      avalancheDanger: false,
      isLowerSegment: 6,
      coordinates: [
        { order: 0, latitude: 68.0502, longitude: 24.1112 },
        { order: 1, latitude: 68.0506, longitude: 24.1123 },
        { order: 2, latitude: 68.0509, longitude: 24.1133 },
        { order: 3, latitude: 68.0516, longitude: 24.1152 },
        { order: 4, latitude: 68.0521, longitude: 24.117 },
        { order: 5, latitude: 68.0528, longitude: 24.1186 },
        { order: 6, latitude: 68.0531, longitude: 24.1195 },
        { order: 7, latitude: 68.0531, longitude: 24.1201 },
        { order: 8, latitude: 68.0529, longitude: 24.1204 },
        { order: 9, latitude: 68.0527, longitude: 24.1203 },
        { order: 10, latitude: 68.0524, longitude: 24.1198 },
        { order: 11, latitude: 68.052, longitude: 24.1189 },
        { order: 12, latitude: 68.0513, longitude: 24.1172 },
        { order: 13, latitude: 68.051, longitude: 24.1161 },
        { order: 14, latitude: 68.0507, longitude: 24.115 },
        { order: 15, latitude: 68.0503, longitude: 24.114 },
        { order: 16, latitude: 68.0501, longitude: 24.1132 },
        { order: 17, latitude: 68.0497, longitude: 24.1121 },
        { order: 18, latitude: 68.0499, longitude: 24.1114 },
        { order: 19, latitude: 68.0502, longitude: 24.1112 },
      ],
    },
    {
      id: crypto.randomUUID(),
      name: 'Orotuskero pohjoinen',
      terrain: 'Kivirakka, alhaalla kosteikkoa',
      avalancheDanger: false,
      isLowerSegment: null,
      coordinates: [
        { order: 0, latitude: 68.0826, longitude: 24.0381 },
        { order: 1, latitude: 68.0844, longitude: 24.0425 },
        { order: 2, latitude: 68.0883, longitude: 24.0359 },
        { order: 3, latitude: 68.0979, longitude: 24.0258 },
        { order: 4, latitude: 68.0701, longitude: 23.9948 },
        { order: 5, latitude: 68.0776, longitude: 24.0119 },
        { order: 6, latitude: 68.08, longitude: 24.0191 },
        { order: 7, latitude: 68.082, longitude: 24.025 },
        { order: 8, latitude: 68.0826, longitude: 24.0381 },
      ],
    },
  ];

  for (const segmentData of segments) {
    const segment = await prisma.segment.upsert({
      // Use unique name to avoid conflicts if data already exists
      where: { name: segmentData.name },
      update: {
        terrain: segmentData.terrain,
        avalancheDanger: segmentData.avalancheDanger,
        isLowerSegment: segmentData.isLowerSegment,
      },
      create: {
        id: segmentData.id,
        name: segmentData.name,
        terrain: segmentData.terrain,
        avalancheDanger: segmentData.avalancheDanger,
        isLowerSegment: segmentData.isLowerSegment,
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

  // Create a comprehensive test segment with all data for testing GET /api/v1/segments
  const testSegment = await prisma.segment.findFirst({
    where: { name: 'Metsä' },
  });
  const snowTypes_list_for_test = await prisma.snowType.findMany();

  if (testSegment && snowTypes_list_for_test.length >= 4) {
    // Create a guide update with 2 primary and 2 secondary snow types
    const primary1 = createdSnowTypes['Uusi lumi'];
    const primary2 = createdSnowTypes['Korppu'];
    const secondary1 = createdSnowTypes['Vitilumi'];
    const secondary2 = createdSnowTypes['Ohut korppu'];

    if (primary1 && primary2 && secondary1 && secondary2) {
      await prisma.snowUpdate.create({
        data: {
          id: crypto.randomUUID(),
          creator: adminUser.id,
          segment: testSegment.id,
          description: 'Comprehensive test guide update with multiple snow types.',
          status: 'ACTIVE',
          priority: 1,
          snowConditions: {
            create: [
              {
                id: crypto.randomUUID(),
                snowType: primary1,
                secondarySnowType: secondary1,
                layer: 'SURFACE',
              },
              {
                id: crypto.randomUUID(),
                snowType: primary2,
                secondarySnowType: secondary2,
                layer: 'MIDDLE',
              },
            ],
          },
        },
      });
    }

    // Create 5 user reviews for this segment (to test the limit of 3)
    const testSnowType = snowTypes_list_for_test[0];
    if (testSnowType) {
      for (let i = 0; i < 5; i++) {
        const hazards: ('stones' | 'branches')[] = [];
        if (i % 2 === 0) hazards.push('stones');
        if (i % 3 === 0) hazards.push('branches');

        // Randomly assign secondary snow type (optional)
        const secondarySnowType =
          i % 2 === 0 && snowTypes_list_for_test.length > 1
            ? snowTypes_list_for_test[
                Math.floor(Math.random() * (snowTypes_list_for_test.length - 1)) + 1
              ]
            : null;

        await prisma.userReview.create({
          data: {
            id: crypto.randomUUID(),
            segment: testSegment.id,
            snowType: testSnowType.id,
            secondarySnowType: secondarySnowType?.id,
            hazards: hazards.length > 0 ? hazards : undefined,
            comment: `Test review ${i + 1} for comprehensive testing`,
            userId: normalUser.id,
            time: new Date(Date.now() - i * 24 * 60 * 60 * 1000), // Staggered times
          },
        });
      }
    }
  }

  // Create sample reviews
  const segments_list = await prisma.segment.findMany();
  const snowTypes_list = await prisma.snowType.findMany();
  const hazardTypes: ('stones' | 'branches')[] = ['stones', 'branches'];

  for (let i = 0; i < 10; i++) {
    const randomSegment =
      segments_list[Math.floor(Math.random() * segments_list.length)];
    const randomSnowType =
      snowTypes_list[Math.floor(Math.random() * snowTypes_list.length)];
    const randomUser = Math.random() > 0.5 ? normalUser : rescueUser;
    // Randomly select 0-2 hazards
    const randomHazards = hazardTypes
      .filter(() => Math.random() > 0.5)
      .slice(0, Math.floor(Math.random() * 3));

    // Randomly assign secondary snow type (optional, ~50% chance)
    const randomSecondarySnowType =
      Math.random() > 0.5 && snowTypes_list.length > 1
        ? snowTypes_list.filter((st) => st.id !== randomSnowType.id)[
            Math.floor(
              Math.random() * (snowTypes_list.length - 1)
            )
          ]
        : null;

    if (randomSegment && randomSnowType) {
      await prisma.userReview.create({
        data: {
          id: crypto.randomUUID(),
          segment: randomSegment.id,
          snowType: randomSnowType.id,
          secondarySnowType: randomSecondarySnowType?.id,
          hazards: randomHazards.length > 0 ? randomHazards : undefined,
          comment: `Sample review ${i + 1} for ${randomSegment.name}. Conditions were ${randomSnowType.name.toLowerCase()}.`,
          userId: randomUser.id,
          time: new Date(Date.now() - Math.random() * 7 * 24 * 60 * 60 * 1000), // Random time in last week
        },
      });
    }
  }

  // Create sample guide updates (SnowUpdates created by admin)
  // These should have primary and secondary snow types to test the guideUpdate response
  for (let i = 0; i < 5; i++) {
    const randomSegment =
      segments_list[Math.floor(Math.random() * segments_list.length)];
    
    // Select 1-2 primary snow types
    const numPrimary = Math.floor(Math.random() * 2) + 1; // 1 or 2
    const primarySnowTypes = snowTypes_list
      .sort(() => Math.random() - 0.5)
      .slice(0, numPrimary);
    
    // Select 0-2 secondary snow types
    const numSecondary = Math.floor(Math.random() * 3); // 0, 1, or 2
    const secondarySnowTypes = snowTypes_list
      .filter((st) => !primarySnowTypes.some((pst) => pst.id === st.id))
      .sort(() => Math.random() - 0.5)
      .slice(0, numSecondary);

    if (randomSegment && primarySnowTypes.length > 0) {
      const conditionsToCreate: Array<{
        id: string;
        snowType: string;
        secondarySnowType?: string;
        layer: 'SURFACE' | 'MIDDLE' | 'BASE';
      }> = [];

      // Create conditions for primary snow types
      primarySnowTypes.forEach((primaryType, index) => {
        const layer: 'SURFACE' | 'MIDDLE' | 'BASE' =
          index === 0 ? 'SURFACE' : index === 1 ? 'MIDDLE' : 'BASE';
        const secondaryType =
          index < secondarySnowTypes.length
            ? secondarySnowTypes[index]
            : undefined;

        conditionsToCreate.push({
          id: crypto.randomUUID(),
          snowType: primaryType.id,
          secondarySnowType: secondaryType?.id,
          layer,
        });
      });

      // Handle remaining secondary snow types (if we have more secondaries than primaries)
      if (secondarySnowTypes.length > primarySnowTypes.length) {
        const basePrimaryType = primarySnowTypes[0];
        for (
          let j = primarySnowTypes.length;
          j < secondarySnowTypes.length;
          j++
        ) {
          conditionsToCreate.push({
            id: crypto.randomUUID(),
            snowType: basePrimaryType.id,
            secondarySnowType: secondarySnowTypes[j].id,
            layer: 'BASE',
          });
        }
      }

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
            create: conditionsToCreate.map((cond) => ({
              id: cond.id,
              snowType: cond.snowType,
              secondarySnowType: cond.secondarySnowType,
              layer: cond.layer,
              depth: Math.random() * 50 + 10, // Random depth 10-60cm
              coverage: Math.floor(Math.random() * 40) + 60, // Random coverage 60-100%
              quality: Math.floor(Math.random() * 5) + 1, // Random quality 1-5
              hardness: Math.floor(Math.random() * 5) + 1, // Random hardness 1-5
              moisture: Math.floor(Math.random() * 5) + 1, // Random moisture 1-5
              notes: `Conditions: ${primarySnowTypes.map((p) => p.name).join(', ')}`,
            })),
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
