import { PrismaClient } from '@prisma/client';

async function run() {
  const prisma = new PrismaClient();
  try {
    const snowTypes = await prisma.snowType.findMany();
    const segments = await prisma.segment.findMany({ take: 1 });
    console.log('snowTypes count:', snowTypes.length);
    console.log('first segment:', segments[0]);
  } catch (err) {
    console.error('Prisma error:', err);
  } finally {
    await prisma.$disconnect();
  }
}

run();



