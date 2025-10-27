import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient({
  datasources: {
    db: {
      url:
        process.env.DATABASE_URL ||
        'mysql://root:testpassword@localhost:3307/testdb',
    },
  },
});

export default async function setup() {
  try {
    // Connect to the test database
    await prisma.$connect();

    // Clean up all existing data in the correct order (respecting foreign key constraints)
    await prisma.snowUpdateReviewReference.deleteMany();
    await prisma.snowUpdateAttachment.deleteMany();
    await prisma.snowUpdateCondition.deleteMany();
    await prisma.snowUpdate.deleteMany();
    await prisma.userReview.deleteMany();
    await prisma.locationData.deleteMany();
    await prisma.nearbyUser.deleteMany();
    await prisma.helpRequest.deleteMany();
    await prisma.coordinate.deleteMany();
    await prisma.segment.deleteMany();
    await prisma.snowType.deleteMany();
    await prisma.user.deleteMany();
    await prisma.role.deleteMany();
    await prisma.weather.deleteMany();
  } catch (error) {
    console.error('Error setting up test database:', error);
    throw error;
  } finally {
    await prisma.$disconnect();
  }
}
