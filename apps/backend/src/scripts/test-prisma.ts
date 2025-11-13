import { PrismaClient } from '@prisma/client';

async function run() {
  const prisma = new PrismaClient();
  try {
    const snowTypes = await prisma.snowType.findMany();
    const segments = await prisma.segment.findMany({ take: 1 });
    // snowTypes count: snowTypes.length
    // first segment: segments[0]
  } catch (err) {
    // Prisma error: err
  } finally {
    await prisma.$disconnect();
  }
}

run();
